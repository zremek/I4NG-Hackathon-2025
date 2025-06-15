
# ============================== read me first ================================
# reproducibility note: #### 
# to run this script you need to source 3-modeling.R
# WARNING: this script creates a new directory and writes files to your machine.
# =============================================================================

# produce suplementary tables #### 

library(webshot)

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

## tab4 shows three logistic models' statistics #### 

tab_model(
  M0,
  M1,
  M2,
  title = "Dependent variable: Knows how to check truthfulness of online content (1 = 'Very true', 0 = other). Answers 'Very true' were treated as an indicator of confidence in digital fact-checking; logistic regression method, weighted data.",
  dv.labels = c(
    "M0: inital model",
    "M1: limited predictors",
    "M2: final model, p<0.05 predictors' odds ratios shown in the brief"
  ),
  use.viewer = F,
  file = "t4.html"
)

webshot("t1.html", "tab1-conf-gap-pct-supl.pdf",
        vheight = 200, vwidth = 400)

webshot("t2.html", "tab2-conf-gap-pct-org-categories-supl.pdf",
        vheight = 500, vwidth = 500)

webshot("t3.html", "tab3-conf-gap-n-pct-org-categories-unweight-supl.pdf",
        vheight = 500, vwidth = 500)

webshot("t4.html", "tab4-logistic-models-supl.pdf")

## new dir for tables in pdf and move files #### 
# create the target folder if it doesn't exist
dir.create(here("supplementary_tables"), showWarnings = FALSE)

# list of PDF files to move
pdf_files <- c(
  "tab1-conf-gap-pct-supl.pdf",
  "tab2-conf-gap-pct-org-categories-supl.pdf",
  "tab3-conf-gap-n-pct-org-categories-unweight-supl.pdf",
  "tab4-logistic-models-supl.pdf"
)

# move each file to the supplementary_tables folder
for (file in pdf_files) {
  from <- here(file)
  to <- here("supplementary_tables", file)
  if (file.exists(from)) {
    file.rename(from, to)
  } else {
    message(paste("File not found:", file))
  }
}

