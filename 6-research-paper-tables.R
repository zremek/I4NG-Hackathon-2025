source("1-load-data.R")
source("2-preparation.R")
source("3-modeling.R")

  
# produce tables for paper #### 

# variable names with acronyms and frqs

sjPlot::view_df(c_fin, show.frq = T, show.prc = T, show.na = T, max.len = 20, file = "var-names-acronyms.html")

# descriptive-stats-by-TRC
library(table1)

table1(~ TRC + CNTR_C + GDF_C + EDY_C + HTI_C + AGE_C + FLC + PGW + IFS + SMP + LMA + BSC + NETUALL + SCNTR + GENTR + DIGSKILLT, data = remove_all_labels(c_fin))

trcf_c_fin <- c_fin %>%
  mutate(trcf = factor(case_when(
    TRC == 0 ~ "0",
    TRC == 1 ~ "1",
    is.na(TRC) ~ "Missing"
  )))

table1(~ CNTR_C + GDF_C + EDY_C + HTI_C + AGE_C + FLC + PGW + IFS + SMP + LMA + BSC + NETUALL + SCNTR + GENTR + DIGSKILLT | trcf, data = remove_all_labels(trcf_c_fin))


# descriptive-stats-by-TRC.html

## tab 1 shows percentages used in "The Confidence Gap" section of the brief #### 

c_mutated_tab <- c_mutated %>% 
  filter(no_int_access_or_use == 0) %>% 
  select(w1weight, TRC, w1dq3, w1dq9) %>% 
  mutate(NETU_T = case_when(
    w1dq3 == 1 | w1dq3 == 2 ~ 1, 
    is.na(w1dq3) ~ NA_integer_, 
    .default = 0), 
    NETU_T = set_label(NETU_T, "Uses internet almost all the time or several times a day"), 
    TRC = set_label(TRC, "Knows how to check truthfulness of online content"), 
    NETU_T = set_labels(NETU_T, labels = c("Yes" = 1, "No" = 0)), 
    TRC = set_labels(TRC, labels = c("Very true" = 1, "Other" = 0)))  


tab_xtab(c_mutated_tab$TRC, c_mutated_tab$NETU_T,
         weight.by = c_mutated_tab$w1weight, 
         show.obs = F, 
         show.col.prc = T, 
         show.row.prc = T, 
         show.summary = F,
         emph.total = T, 
         use.viewer = F,
         title = "Checking truthfulness of online content vs. frequent internet usage. Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; grouped categories, weighted percentages of answers.",
         file = "t1.html")

## tab2 shows distribution of original categories used to create tab1 #### 

tab_xtab(c_mutated_tab$w1dq9, c_mutated_tab$w1dq3,
         weight.by = c_mutated_tab$w1weight, 
         show.obs = F, 
         show.col.prc = T, 
         show.row.prc = T, 
         show.summary = F,
         emph.total = T, 
         use.viewer = F,
         title = "Checking truthfulness of online content vs. frequent internet usage. Original categories; weighted percentages of answers.",
         file = "t2.html")

## tab3 shows distribution as in tab2, but with unweighted counts and percentages #### 

tab_xtab(c_mutated_tab$w1dq9, c_mutated_tab$w1dq3,
         show.obs = T, 
         show.col.prc = T, 
         show.row.prc = T, 
         show.na = T,
         show.summary = F,
         emph.total = T, 
         use.viewer = F,
         title = "Checking truthfulness of online content vs. frequent internet usage. Original categories and missings (NA); unweighted counts and percentages of answers.",
         file = "t3.html")

## tab4 shows two logistic models' statistics #### 

tab_model(
  M0,
  M2,
  title = "Dependent variable: Knows how to check truthfulness of online content (1 = 'Very true', 0 = other). Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; logistic regression method, weighted data.",
  dv.labels = c(
    "M0: inital model",
    "M2: final model"
  ),
  use.viewer = F,show.reflvl = T, pred.labels = F,
  file = "tab-models-M0-M2.html"
)

## tab5 shows four logistic models' statistics #### 

tab_model(
  M0,
  M3,
  M2,
  M1,
  title = "Dependent variable: Knows how to check truthfulness of online content (1 = 'Very true', 0 = other). Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; logistic regression method, weighted data.",
  dv.labels = c(
    "M0: inital model",
    "M3: M0 without income and gentrust",
    "M2: final model",
    "M1: M2 without income and gentrust"
  ),
  use.viewer = F,show.reflvl = T, pred.labels = F,
  file = "tab-models-four.html"
)


## tab6 shows three other logistic models' statistics #### 

tab_model(
  M0,
  M3,
  M4,
  title = "Dependent variable: Knows how to check truthfulness of online content (1 = 'Very true', 0 = other). Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; logistic regression method, weighted data.",
  dv.labels = c(
    "M0: inital model",
    "M3: M0 without income and gentrust",
    "M4: without age, science trust, gentrust"
  ),
  use.viewer = F,show.reflvl = T, pred.labels = F,
  file = "6-tab-models.html"
)


## tab7 shows three other logistic models' statistics #### 

tab_model(
  M0,
  M3,
  title = "Dependent variable: Knows how to check truthfulness of online content (1 = 'Very true', 0 = other). Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; logistic regression method, weighted data.",
  dv.labels = c(
    "Model 1: inital model",
    "Model 2: without income and gentrust"
  ),
  use.viewer = F,show.reflvl = T, pred.labels = F,
  file = "7-tab-models.html"
)


# VIF #### 

library(car)
car::vif(M0)

car::vif(M1)

car::vif(M2)

library(olsrr)
olsrr::ols_vif_tol(M0)

# corr matrix ####
tab_corr(c_fin %>% 
           select(-id, -w1weight, -CNTR_C) %>% 
           remove_all_labels(), show.p = T, triangle = "l", 
         file = "corr-matrix.html")

# AIC #### 

AIC(M0, M3, M2, M1)

# BIC #### 

bic_svyglm_fixed <- function(model, design) {
  if (!inherits(model, "svyglm")) {
    stop("Model must be of class 'svyglm'")
  }
  if (!inherits(design, "survey.design")) {
    stop("Design must be of class 'survey.design'")
  }
  
  k <- length(coef(model))
  dev <- model$deviance
  ll <- -0.5 * dev
  n <- sum(weights(design))
  
  cat("Deviance:", dev, "\n")
  cat("Log-likelihood (approx):", ll, "\n")
  cat("Number of parameters (k):", k, "\n")
  cat("Effective sample size (n):", n, "\n")
  
  BIC <- -2 * ll + log(n) * k
  return(BIC)
}

bic_svyglm_fixed(M0, design)
bic_svyglm_fixed(M3, design)
bic_svyglm_fixed(M2, design)
bic_svyglm_fixed(M1, design)


tibble(Model = c("M0", "M3", "M2", "M1"), BIC = c("6637.965", "7870.114", "6603.374", "7842.924"))

# nagelkerke #### 

M0_nag <- survey::psrsq(M0, method = "Nagelkerke")
M3_nag <- survey::psrsq(M3, method = "Nagelkerke")
M2_nag <- survey::psrsq(M2, method = "Nagelkerke")
M1_nag <- survey::psrsq(M1, method = "Nagelkerke")

tibble(Model = c("M0", "M3", "M2", "M1"), Nagelkerke = c(M0_nag, M3_nag, M2_nag, M1_nag))

# Testing for linearity of the logit #### 

# EDY_C
# HTI_C
# AGE_C
# SCNTR
# GENTR 

c_fin_log <- c_fin

create_log_interactions <- function(data, vars) {
  for (var in vars) {
    new_var <- paste0("log_", var)
    data[[new_var]] <- ifelse(data[[var]] > 0,
                              data[[var]] * log(data[[var]]),
                              0)
  }
  return(data)
}


vars_to_transform <- c("EDY_C", "HTI_C", "AGE_C", "SCNTR", "GENTR")

c_fin_log <- create_log_interactions(c_fin_log, vars_to_transform)

c_fin_log %>% 
  select(contains(c("EDY_C", "HTI_C", "AGE_C", "SCNTR", "GENTR"))) %>% 
  summary()

lintest <- glm(TRC ~ EDY_C + HTI_C+ AGE_C + SCNTR + GENTR + 
                 log_EDY_C + log_HTI_C + log_AGE_C + log_SCNTR + log_GENTR,
               data = c_fin_log,
               family = binomial())

summary(lintest)



# plots? 


ggplot(c_fin, aes(x = TRC, y = SCNTR)) + geom_jitter()
ggplot(c_fin, aes(x = factor(TRC), y = SCNTR)) + geom_boxplot()
ggplot(c_fin, aes(x = TRC, y = GENTR)) + geom_jitter()
ggplot(c_fin, aes(x = factor(TRC), y = GENTR)) + geom_boxplot()

ggplot(trcf_c_fin, aes(fill = trcf, x = CNTR_C)) + 
  geom_bar(position = "fill") + 
  coord_flip()

tab_xtab(var.row = c_fin$CNTR_C, var.col = c_fin$TRC, 
         show.na = T, show.row.prc = T, weight.by = c_fin$w1weight, 
         file = "trc-by-country-weighted.html")

tab_xtab(var.row = c_fin$CNTR_C, var.col = c_fin$TRC, 
         show.na = T, show.row.prc = T, 
         file = "trc-by-country.html")


# crosstab for confidence gap 

tab_xtab(c_mutated_tab$w1dq9, c_mutated_tab$w1dq3,
         weight.by = c_mutated_tab$w1weight, 
         show.obs = T, 
         show.col.prc = T, 
         show.row.prc = T, 
         show.summary = F,
         emph.total = T, 
         show.na = T) 
         
tab_xtab(c_mutated_tab$TRC, c_mutated_tab$NETU_T,
         weight.by = c_mutated_tab$w1weight, 
         show.obs = F, 
         show.col.prc = T, 
         show.row.prc = T, 
         show.summary = F,
         emph.total = T, 
         show.na = T, 
         title = "Checking truthfulness of online content vs. frequent internet usage. Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; grouped categories, weighted percentages of answers.")

tab_xtab(c_mutated_tab$TRC, c_mutated_tab$NETU_T,
         show.obs = T, 
         show.col.prc = T, 
         show.row.prc = T, 
         show.summary = F,
         emph.total = T, 
         show.na = T,
         title = "Checking truthfulness of online content vs. frequent internet usage. Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; grouped categories, weighted percentages of answers.")


# survey package



# Step 1: Create a survey design object
cdesign <- svydesign(
  ids = ~1,  # assuming simple random sampling
  data = c_mutated_tab,
  weights = ~w1weight
)

# Step 2: Create a crosstab (contingency table)
svytable(~ TRC + NETU_T, cdesign, exclude = NULL)

# Cronbach’s Alpha 

library(psych)

c_mutated %>% 
  filter(no_int_access_or_use == 0) %>% 
  select(pplfair_num, pplhlp_num, ppltrst_num) %>% 
  psych::alpha()



