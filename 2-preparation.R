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

