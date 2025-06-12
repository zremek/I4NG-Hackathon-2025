library(sjlabelled)
library(sjPlot)
library(sjmisc)
library(DataExplorer)
library(table1)

# select variables #### 
c_selected <- cronos %>% select(idno,
                                cntry,
                                mode, 
                                essround,
                                gndr,
                                eduyrs,
                                age,
                                hinctnta,
                                netusoft,
                                # id and control variables
                                w1dq2_1:w1dq18,
                                # devices and computer skills
                                w1sq16,
                                # trust in scientists
                                w1dq19_1:w1dq19_3,
                                # digital skills trainings 
                                w1weight) # weighting 

# create new variable no_int_access_or_use #### 
# to exclude respondents who did not use the internet
# or had no access to it 

c_mutated <- c_selected %>%
  mutate(no_int_access_or_use = case_when(
    netusoft == 1 | w1dq2_7 == 1 ~ 1, .default = 0))

# tab_xtab(c_selected$netusoft, c_selected$w1dq2_7, show.na = T)
# 
# 320 + 189 - 163 = 346 # these resp. should be excluded
# 
# frq(c_mutated$no_int_access_or_use) # value 1 is 346 resp. 

# prepare country names #### 

c_mutated$CNTR_C <- as_label(c_mutated$cntry)

# join trust variables pplfair, pplhlp, ppltrst from ESS #### 

binded_ess <- bind_rows(ess10 %>% select(idno, cntry, mode, essround, pplfair, pplhlp, ppltrst),
                        ess10sc %>% select(idno, cntry, mode, essround, pplfair, pplhlp, ppltrst),
                        ess11 %>% select(idno, cntry, mode, essround, pplfair, pplhlp, ppltrst))

c_mutated <- left_join(x = c_mutated, 
                       y = binded_ess)

# prepare control variables #### 

c_mutated <- c_mutated %>% 
  mutate(
    GDF_C = case_when(gndr == 2 ~ 1, .default = 0), # Female is 1
    EDY_C = as.numeric(eduyrs), # Years of full-time education completed
    HTI_C = as.numeric(hinctnta), # Household's total net income, all sources in deciles
    AGE_C = as.numeric(age) # Age of respondent, calculated
    )







