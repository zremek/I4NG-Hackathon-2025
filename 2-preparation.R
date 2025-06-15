library(sjlabelled)
library(sjPlot)
library(sjmisc)
library(DataExplorer)
library(table1)

# ============================== read me first ================================
# reproducibility note: #### 
# to run this script you need to source 1-load-data.R
# =============================================================================

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
    GDF_C = if_else(gndr == 2, 1, 0), # Female is 1
    EDY_C = as.numeric(eduyrs), # Years of full-time education completed
    HTI_C = as.numeric(hinctnta), # Household's total net income, all sources in deciles
    AGE_C = as.numeric(age) # Age of respondent, calculated
    )


# prepare all other dependent and independent variables #### 

c_mutated <- c_mutated %>%
  # Recode "know how" variables: 1 = "Very true of me" (value 5), 0 = all others
  mutate(across(
    .cols = c(w1dq9, w1dq5, w1dq6, w1dq7, w1dq12, w1dq13, w1dq15),
    .fns = ~ if_else(.x == 5, 1, 0),
    .names = "{.col}_bin"
  )) %>%
  rename(
    TRC = w1dq9_bin,   # Check truthfulness of online content
    FLC = w1dq5_bin,   # Create files on digital device
    PGW = w1dq6_bin,   # Write code in a programming language
    IFS = w1dq7_bin,   # Find product/service info online
    SMP = w1dq12_bin,  # Participate in social media
    LMA = w1dq13_bin,  # Limit access to social media content
    BSC = w1dq15_bin   # Change browser settings to limit cookies
  ) %>%
  # Recode internet use: 1 = "Almost all the time" (value 1), 0 = all others
  # "How often typically use internet on any device for work or personal use last month"
  mutate(
    NETUALL = if_else(w1dq3 == 1, 1, 0)
  ) %>%
  # Recode trust in scientists to numeric
  # "In general, how much do you trust scientists"
  mutate(
    SCNTR = as.numeric(w1sq16)
  ) %>%
  # Convert general trust variables to numeric and compute row mean
  mutate(
    pplfair_num = as.numeric(pplfair), # "Most people try to take advantage of you, or try to be fair"
    pplhlp_num  = as.numeric(pplhlp), # "Most of the time people helpful or mostly looking out for themselves"
    ppltrst_num = as.numeric(ppltrst), # "Most people can be trusted or you can't be too careful"
    GENTR = rowMeans(across(c(pplfair_num, pplhlp_num, ppltrst_num)), na.rm = TRUE)
  ) %>%
  # Create binary variable for digital skills training participation
  # w1dq19_1 Partic. in training courses to improve dig. s. last 12 months: Yes, by using own resources
  ### w1dq19_2 (...) Yes, by using resources provided by employer
  ### w1dq19_3 (...) Yes, by using resources provided by public institutions/NGO
  mutate(
    DIGSKILLT = if_else(
      w1dq19_1 == 1 | w1dq19_2 == 1 | w1dq19_3 == 1,
      1, 0
    )
  )


# set descriptive variable labels #### 

c_mutated <- c_mutated %>%
  mutate(
    TRC       = set_label(TRC,       "Knows how to check truthfulness of online content (1 = 'Very true', 0 = other)"),
    FLC       = set_label(FLC,       "Knows how to create files on a digital device (1 = 'Very true', 0 = other)"),
    PGW       = set_label(PGW,       "Knows how to write code in a programming language (1 = 'Very true', 0 = other)"),
    IFS       = set_label(IFS,       "Knows how to find information about goods or services online (1 = 'Very true', 0 = other)"),
    SMP       = set_label(SMP,       "Knows how to participate in social media (1 = 'Very true', 0 = other)"),
    LMA       = set_label(LMA,       "Knows how to limit access to profile or content on social media (1 = 'Very true', 0 = other)"),
    BSC       = set_label(BSC,       "Knows how to change browser settings to limit cookies (1 = 'Very true', 0 = other)"),
    NETUALL   = set_label(NETUALL,   "Uses internet almost all the time (1 = yes, 0 = other)"),
    SCNTR     = set_label(SCNTR,     "Trust in scientists (num)"),
    GENTR     = set_label(GENTR,     "General trust: mean of pplfair, pplhlp, ppltrst (num)"),
    DIGSKILLT = set_label(DIGSKILLT, "Participated in any digital skills training in the last 12 m. (1 = yes, 0 = none)"),
    GDF_C     = set_label(GDF_C,     "Gender (1 = Female, 0 = Male)"),
    EDY_C     = set_label(EDY_C,     "Years of full-time education completed (num)"),
    HTI_C     = set_label(HTI_C,     "Household total net income decile (num)"),
    AGE_C     = set_label(AGE_C,     "Age of respondent (num)")
  )





# create final dataset #### 

analysis_var_names <- c_mutated %>%
  select(all_of(names(.)[grepl("^[A-Z]", names(.))])) %>% 
  names() # set prepared variables' names

c_mutated <- c_mutated %>% 
  mutate(id = paste(idno, cntry, mode, essround, sep = "_")) # make unique ids

c_fin <- c_mutated %>% 
  filter(no_int_access_or_use == 0) %>% 
  # exclude respondents who did not use the internet or had no access to it 
  select(id, analysis_var_names, w1weight)

# haven::write_sav(data = c_fin, path = "data/cronos3_gotowe_hackaton.sav")
## save file 



