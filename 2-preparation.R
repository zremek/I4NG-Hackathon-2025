library(sjlabelled)
library(sjPlot)
library(sjmisc)
library(DataExplorer)
library(table1)

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

DataExplorer::create_report(c_selected)

c_selected %>% as_label() %>% drop_labels() %>% DataExplorer::create_report()

get_label(c_selected)

tab_xtab(c_selected$netusoft, c_selected$w1dq2_7, show.na = T)
# TODO może należy usunąć netuseoft=never + no access=marked 

320 + 189 - 163 # tyle osób do usunięcia 

frq(cronos$cntry) # w viewerze jest 6K obserwacji, w danych prawie 10K
# i to jest ok

frq(miss_cronos$w1dq18)
frq(c_selected$w1dq18)

tab_xtab(c_selected$w1dq18, c_selected$w1dq13)

na.omit(c_selected) %>% dim() # bez NA 7922

7922 / 9884 # tracimy 20% obserwacji 


# TODO dokleić z ess pplfair, pplhlp, ppltrst 

frq(c_selected$w1dq9)

# TODO 1. przeczyści zmienne tak, żeby numeryczne były numeryczne bez labelków np. wszystkie trust
# 2. zmienną zależną przekodować jako 5 "Very true of me" vs. reszta 
# 3. przygotować i przeliczyć indeksy computer skills  

