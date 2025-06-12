
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

