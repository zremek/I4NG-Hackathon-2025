library(tidyverse)

# load CRONOS3 Wave 1 edition 1.1
# DOI: 10.21338/cron3w1e01.1

cronos <- haven::read_spss("data/CRON3W1e01.1.sav")

# load ESS11 - integrated file, edition 3.0
# DOI: 10.21338/ess11e03_0

ess <- haven::read_spss("data/ESS11.sav")

