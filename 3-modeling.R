
library(survey)

# Define the survey design #### 
design <- svydesign(
  ids = ~1,
  weights = ~w1weight,
  data = c_fin
)

# run logistic regression with all predictors #### 

M0 <- svyglm(
  TRC ~ CNTR_C + 
    FLC + PGW + IFS + SMP + LMA + BSC + # know-hows
    NETUALL + SCNTR + GENTR + DIGSKILLT + # int usage, trust in scientists, gen trust, part. in digi training
    GDF_C + EDY_C + AGE_C + HTI_C, # controls with income, 
  design = design,
  family = quasibinomial()
)

summary(M0)


exp(cbind(OR = coef(M0), confint(M0)))


# teraz dwa modele bez krajów - kraje nie działają #### 

## bez zaufania ess i bez dochodu M1



M1 <- svyglm(
  TRC ~ FLC + PGW + IFS + SMP + LMA + BSC + # know-hows
    NETUALL + SCNTR + DIGSKILLT + # int usage, trust in scientists, participated in digi training
    GDF_C + EDY_C + AGE_C, # controls without income
  design = design,
  family = quasibinomial()
)

summary(M1)


exp(cbind(OR = coef(M1), confint(M1)))



## bez zaufania ess i bez dochodu M1



M2 <- svyglm(
  TRC ~ FLC + PGW + IFS + SMP + LMA + BSC + # know-hows
    NETUALL + SCNTR + GENTR + DIGSKILLT + # int usage, trust in scientists, gen trust, part. in digi training
    GDF_C + EDY_C + AGE_C + HTI_C, # controls with income
  design = design,
  family = quasibinomial()
)

summary(M2)


exp(cbind(OR = coef(M2), confint(M2)))

tab_model(M1, M2, M0)

# produce suplementary tables 

library(webshot)

c_mutated_tab <- c_mutated %>% 
  filter(no_int_access_or_use == 0) %>% 
  select(w1weight, TRC, w1dq3) %>% 
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
         show.na = T, 
         show.obs = F, 
         show.col.prc = T, 
         show.row.prc = T, 
         show.summary = F,
         emph.total = T, 
         use.viewer = F,
         digits = 0,
         file = "t.html")

webshot("t.html", "t.pdf", vheight = 200, vwidth = 400)
