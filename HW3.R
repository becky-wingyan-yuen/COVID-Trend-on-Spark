
rm(list=ls())

library(readr)

urlfile = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv"
urlfile1 = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

UID_ISO_FIPS_LookUp_Table = read_csv(url(urlfile))
time_series_covid19_confirmed_global = read_csv(url(urlfile1))

names(UID_ISO_FIPS_LookUp_Table)[which(names(UID_ISO_FIPS_LookUp_Table)=="Long_")] = "Long"
names(time_series_covid19_confirmed_global)[which(names(time_series_covid19_confirmed_global)=="Province/State")] = "Province_State"
names(time_series_covid19_confirmed_global)[which(names(time_series_covid19_confirmed_global)=="Country/Region")] = "Country_Region"

setwd("C:/Users/YUENWI~1/Documents/SURV675-S2024-Assignment3")

library(sparklyr)
library(dplyr)

options(sparklyr.log.console = TRUE)
options(sparklyr.verbose = TRUE)
sc <- spark_connect(master = "local", spark_home = "C:/Users/YUENWI~1/AppData/Local/spark/spark-2.4.3-bin-hadoop2.7")

sc <- spark_connect(master = "local")







Sys.getenv()

Sys.getenv("JAVA_HOME")

Sys.setenv(SPARK_HOME = "C:/Users/YUENWI~1/AppData/Local/spark/spark-2.4.3-bin-hadoop2.7")
Sys.setenv(HADOOP_HOME = "C:/Users/YUENWI~1/AppData/Local/spark/spark-2.4.3-bin-hadoop2.7")
Sys.setenv(JAVA_HOME = "C:/Program Files (x86)/Java/jre-1.8")

spark_config_settings()

sparklyr.gateway.port <- 8890



spark_disconnect_all()

#spark_web(sc)
#spark_log(sc)
Sys.getenv("SPARK_HOME")

system("java -version")

spark_install()
spark_installed_versions()


remotes::install_github("yitao-li/sparklyr", ref = "bugfix/spark-3.1.x-compat")



spark_uninstall(version = "2.4.3", hadoop = "2.7")




