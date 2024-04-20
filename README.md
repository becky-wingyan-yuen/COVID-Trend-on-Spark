# SURV675-S2024-Assignment3


## Contents

- [Description](#description)
- [Repo Contents](#repo-contents)
- [Main findings](#main-findings)
- [Session Info](#session-info)



### Description

In this project we aim to investigate the trend of COVID-19 cases over the past few years. All data are downloaded from [JHU CSSE COVID-19 Dataset](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data).


### Repo Contents 

- [code](./code): `R` code to reproduce the graphs.
- [data](./data): downloaded and processed data.
- [figures](./figures): output graphs.


### Main findings 

![Alt text](./figures/fig1.jpeg)
We can see that overall the number of cases has been increasing since 2020.

![Alt text](./figures/fig2.jpeg)
The trends in different countries are consistent with the overall trend.

![Alt text](./figures/fig3.jpeg)
That being said, the change in incident rates differs among different countries.


### Session Info


```
sessionInfo()

R version 4.2.2 Patched (2022-11-10 r83330)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.4 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0

locale:
 [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8        LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8    LC_PAPER=C.UTF-8      
 [8] LC_NAME=C              LC_ADDRESS=C           LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] forcats_1.0.0   stringr_1.5.1   purrr_1.0.2     readr_2.1.5     tibble_3.2.1    tidyverse_2.0.0 sparklyr_1.8.5  lubridate_1.9.3 dplyr_1.1.4     tidyr_1.3.1    
[11] ggplot2_3.5.0  

loaded via a namespace (and not attached):
 [1] pillar_1.9.0      compiler_4.2.2    dbplyr_2.5.0      tools_4.2.2       uuid_1.1-0        bit_4.0.4         jsonlite_1.8.8    lifecycle_1.0.3   gtable_0.3.1     
[10] timechange_0.1.1  pkgconfig_2.0.3   rlang_1.1.3       DBI_1.1.3         cli_3.6.2         rstudioapi_0.14   parallel_4.2.2    yaml_2.3.6        withr_2.5.0      
[19] httr_1.4.4        systemfonts_1.0.4 generics_0.1.3    vctrs_0.6.5       askpass_1.1       hms_1.1.2         bit64_4.0.5       grid_4.2.2        tidyselect_1.2.1 
[28] glue_1.6.2        R6_2.5.1          textshaping_0.3.6 fansi_1.0.3       vroom_1.6.0       farver_2.1.1      blob_1.2.3        tzdb_0.3.0        magrittr_2.0.3   
[37] scales_1.3.0      ellipsis_0.3.2    colorspace_2.0-3  ragg_1.3.0        labeling_0.4.2    config_0.3.2      utf8_1.2.2        stringi_1.7.8     openssl_2.0.4    
[46] munsell_0.5.0     crayon_1.5.2

```