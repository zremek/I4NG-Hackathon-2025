library(tidyverse)
library(here)

# ============================== read me first ================================
# reproducibility note: #### 
# to reproduce our analysis please create the catalog "data"
# in your working directory
# download four datasets: CRONOS3 Wave 1 edition 1.1, ESS11 - integrated file, edition 3.0, 
# ESS10 - integrated file, edition 3.2, and ESS10 Self-completion - integrated file, edition 3.1, 
# data in IBM SPSS .sav format, 
# unzip downloaded catalogs, 
# move all four .sav data files to the catalog "data"
# in your working directory
# =============================================================================


## load CRONOS3 Wave 1 edition 1.1 #### 
# DOI: 10.21338/cron3w1e01.1
# citation: European Social Survey European Research Infrastructure (ESS ERIC) (2025) CRONOS3 Wave 1. Sikt - Norwegian Agency for Shared Services in Education and Research. https://doi.org/10.21338/cronos3-w1.

cronos <- haven::read_spss(here::here("data", "CRON3W1e01.1.sav"))


miss_cronos <- haven::read_spss(here::here("data", "CRON3W1e01.1.sav"),
                                user_na = TRUE) # to preserve user-defined missings


## load ESS11 - integrated file, edition 3.0 #### 
# DOI: 10.21338/ess11e03_0
# citation: European Social Survey European Research Infrastructure (ESS ERIC) (2025) ESS11 - integrated file, edition 3.0 [Data set]. Sikt - Norwegian Agency for Shared Services in Education and Research. https://doi.org/10.21338/ess11e03_0.

ess11 <- haven::read_spss(here::here("data", "ESS11.sav"))

## load ESS10 - integrated file, edition 3.2 #### 
# DOI: 10.21338/ess10e03_2
# citation: European Social Survey European Research Infrastructure (ESS ERIC) (2023) ESS10 - integrated file, edition 3.2 [Data set]. Sikt - Norwegian Agency for Shared Services in Education and Research. https://doi.org/10.21338/ess10e03_2. 

ess10 <- haven::read_spss(here::here("data", "ESS10.sav"))

## load ESS10 Self-completion - integrated file, edition 3.1 ####
# DOI: 10.21338/ess10sce03_1
# citation: European Social Survey European Research Infrastructure (ESS ERIC) (2023) ESS10 Self-completion - integrated file, edition 3.1 [Data set]. Sikt - Norwegian Agency for Shared Services in Education and Research. https://doi.org/10.21338/ess10sce03_1.

ess10sc <- haven::read_spss(here::here("data", "ESS10SC.sav"))

