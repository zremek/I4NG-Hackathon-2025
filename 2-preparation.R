library(sjlabelled)
library(sjPlot)
library(sjmisc)
library(DataExplorer)
library(table1)

# select variables #### 
c_selected <- cronos %>% select(idno,
                                cntry,
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
                                w1weight) # weighting 

# create new variable no_int_access_or_use #### 
# to exclude respondents who did not use the internet
# or had no access to it 

c_mutated <- c_selected %>% mutate(
  no_int_access_or_use = case_when(
    netusoft == 1 | w1dq2_7 == 1 ~ 1, 
    .default = 0
  )
)

# tab_xtab(c_selected$netusoft, c_selected$w1dq2_7, show.na = T)
# 
# 320 + 189 - 163 = 346 # these resp. should be excluded
# 
# frq(c_mutated$no_int_access_or_use) # 1 is 346 resp. 

# join trust variables pplfair, pplhlp, ppltrst from ESS #### 


