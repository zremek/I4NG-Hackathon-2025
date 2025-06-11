library(tidyverse)

# load CRONOS3 Wave 1 edition 1.1
# DOI: 10.21338/cron3w1e01.1

cronos <- haven::read_spss("data/CRON3W1e01.1.sav")

miss_cronos <- haven::read_spss("data/CRON3W1e01.1.sav", user_na = TRUE)


# load ESS11 - integrated file, edition 3.0
# DOI: 10.21338/ess11e03_0

ess11 <- haven::read_spss("data/ESS11.sav")

# load ESS10 - integrated file, edition 3.2
# DOI: 10.21338/ess10e03_2

ess10 <- haven::read_spss("data/ESS10.sav")

# load ESS10 Self-completion - integrated file, edition 3.1 
# DOI: 10.21338/ess10sce03_1

ess10sc <- haven::read_spss("data/ESS10SC.sav")



