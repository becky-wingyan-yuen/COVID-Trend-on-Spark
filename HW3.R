rm(list=ls())

library(sparklyr)
library(dplyr)
library(tidyverse)

sc <- spark_connect(master = "local")

urlfile = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv"
urlfile1 = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

UID_ISO_FIPS_LookUp_Table = read_csv(url(urlfile))
time_series_covid19_confirmed_global = read_csv(url(urlfile1))

names(UID_ISO_FIPS_LookUp_Table)[which(names(UID_ISO_FIPS_LookUp_Table)=="Long_")] = "Long"
names(time_series_covid19_confirmed_global)[which(names(time_series_covid19_confirmed_global)=="Province/State")] = "Province_State"
names(time_series_covid19_confirmed_global)[which(names(time_series_covid19_confirmed_global)=="Country/Region")] = "Country_Region"

save(UID_ISO_FIPS_LookUp_Table, file = "./data/UID_ISO_FIPS_LookUp_Table.csv")
save(time_series_covid19_confirmed_global, file = "./data/time_series_covid19_confirmed_global.csv")


#names(time_series_covid19_confirmed_global)[5:dim(time_series_covid19_confirmed_global)[2]] = 
#  as.character(as.numeric(mdy(names(time_series_covid19_confirmed_global)[5:dim(time_series_covid19_confirmed_global)[2]])))



LookUp_Table = copy_to(sc, UID_ISO_FIPS_LookUp_Table, overwrite = TRUE)
time_series = copy_to(sc, time_series_covid19_confirmed_global, overwrite = TRUE)


All_data = inner_join(time_series, LookUp_Table, by = c("Country_Region","Lat","Long"))

All_data_country = sdf_copy_to(sc, All_data) %>%
  dplyr::filter(Country_Region%in%c("Germany","China","Japan","United Kingdom","US","Brazil","Mexico"))



All_data_long_country = reshape(data = as_tibble(All_data_country),
                                idvar= "UID",
                                varying = colnames(All_data_country)[5:1147], 
                                v.names = "n_case",
                                timevar= "date",
                                times = colnames(All_data_country)[5:1147], 
                                new.row.names = 1:320040,
                                direction = "long")

table(All_data_long_country$Country_Region)


save(All_data_country, file = "./data/All_data_country_wide.csv")
save(All_data_long_country, file = "./data/All_data_country_long.csv")



###### Plotting Graphs ###### 


library(ggplot2)
library(tidyr)
library(dplyr)
library(lubridate, warn.conflicts = FALSE)

temp_date = All_data_long_country$date

for( i in 1:length(temp_date) ){
  
  if( str_length(temp_date[i]) == 4 ){
    temp_date[i] = paste(c("0",substr(temp_date[i],1,1),"0",substr(temp_date[i],2,2),"20",substr(temp_date[i],3,4)), collapse="")
  }else if( str_length(temp_date[i]) == 6 ){
    temp_date[i] = paste(c(substr(temp_date[i],1,4),"20",substr(temp_date[i],5,6)), collapse="")
  }else{  ## str_length(temp_date[i]) == 5 or 7
    temp_date[i] = paste(c("0",substr(temp_date[i],1,3),"20",substr(temp_date[i],4,5)), collapse="")
  }
  
}

table(str_length(temp_date))

All_data_long_country$date_int = as.numeric(mdy(temp_date))
All_data_long_country$date = mdy(temp_date)


sum(is.na(All_data_long_country$date))
sum(is.na(All_data_long_country$Country_Region))
sum(is.na(All_data_long_country$Population))
sum(is.na(All_data_long_country$n_case))

#All_data_long_country$n_case = as.numeric(All_data_long_country$n_case)

#All_data_long_country = All_data_long_country[-which(is.na(All_data_long_country$n_case)),]


All_data_long_date_country = All_data_long_country %>% 
  group_by(date, Country_Region) %>% 
  summarize(ncase_bydate = sum(n_case), total_population = sum(Population)) %>% 
  arrange(date) 



graph2 = ggplot(data = All_data_long_date_country, mapping = aes(x = date, y = log(ncase_bydate)))
(fig2 = graph2 + geom_line(aes(group = Country_Region)) + 
    labs(x = "Date", y = "Number of cases (in log form)", 
         title = "Change of number of cases (in log form) by Country"))

ggsave("fig2.jpeg", width = 10, height = 5)


graph3 = ggplot(data = All_data_long_date_country, mapping = aes(x = date, y = ncase_bydate/total_population))
(fig3 = graph3 + geom_line(aes(group = Country_Region)) + 
    labs(x = "Date", y = "Incident Rate", 
         title = "Change of Incident Rate (cases per total population) by Country"))

ggsave("fig3.jpeg", width = 10, height = 5)

save(All_data_long_date_country, file = "./data/All_data_long_date_country_for_graph.csv")


###### Regression Analysis ###### 

All_data_long_country_copy = All_data_long_country

All_data_long_country$ndays_since_covid = as.numeric(All_data_long_country$date - sort(All_data_long_country$date)[1])
All_data_long_country_2 = All_data_long_country[-which(All_data_long_country$n_case==0),]
All_data_long_country$log_n_case = log(All_data_long_country$n_case)
All_data_long_country = All_data_long_country[-which(All_data_long_country$log_n_case==0),]

## US as reference
All_data_long_country$China = (All_data_long_country$Country_Region=="China")+0
All_data_long_country$Germany = (All_data_long_country$Country_Region=="Germany")+0
All_data_long_country$Japan = (All_data_long_country$Country_Region=="Japan")+0
All_data_long_country$Mexico = (All_data_long_country$Country_Region=="Mexico")+0
All_data_long_country$UK = (All_data_long_country$Country_Region=="United Kingdom")+0


All_data_long_country_lm = All_data_long_country[,which(colnames(All_data_long_country)%in%
                                                          c("Population","log_n_case","ndays_since_covid","China","Germany","Japan","Mexico","United Kingdom"))]
All_data_long_country_lm = All_data_long_country_lm[-which(All_data_long_country_lm$log_n_case==-Inf),]

save(All_data_long_country_lm, file = "./data/All_data_long_country_for_regression.csv")

spark_data_for_regrssion = copy_to(sc, All_data_long_country_lm, overwrite = TRUE)

model = spark_data_for_regrssion %>% ml_linear_regression(log_n_case ~ .) 
summary(model)










##################################################################################################################################
############################################################## Draft############################################################## 
##################################################################################################################################



#All_data_country = dplyr::pull(All_data, var = "Country_Region")

#All_data_country_clean = All_data_country %>% select(c(Country_Region,starts_with("1")))
All_data_country_clean = All_data_country %>% select(c(Country_Region,"18283"))

options("sparklyr.simple.errors" = TRUE)

All_data_long_country_tbl = All_data_country_clean %>% 
  group_by(Country_Region) %>% 
  pivot_longer(-Country_Region, names_to = "date", values_to = "n_case") %>% 
  collect()

# select(All_data, "Country_Region")

# filter(All_data, "Country_Region"%in%c("Germany","China","Japan","United Kingdom","US","Brail","Mexico"))

All_data %>% count(pick(starts_with("1")))
All_data %>% select(starts_with("1"))

colnames(All_data)[c(1:4,1148:1157)]



options(sparklyr.log.console = TRUE)
options(sparklyr.verbose = TRUE)

Sys.getenv()

spark_config_settings()


spark_disconnect_all()

#spark_web(sc)
#spark_log(sc)
Sys.getenv("SPARK_HOME")

system("java -version")

spark_available_versions()

spark_install()

spark_installed_versions()



spark_uninstall(version = "2.4.3", hadoop = "2.7")





library(sparklyr)
library(tidyverse)

tbl_mtcars <- copy_to(sc, mtcars, "spark_mtcars")

testing <- tbl_mtcars %>% 
  group_by(cyl) %>% 
  pivot_longer(!cyl,names_to = "variable",values_to = "values") %>% 
  collect()