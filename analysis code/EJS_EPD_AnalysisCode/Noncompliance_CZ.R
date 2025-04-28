# summary of script
# turn compliance ratio into noncompliance
# turn low income proportion into %

setwd("/Users/clairezegger/Downloads/Spring 2025/QTM 498R/coding")
# install.packages("ggpubr")
library(tidyverse)
library(forcats)
library(ggpubr)

compliance_df <- read.csv("datasets/Income Percentile.csv") # from hansen


# turn compliance into noncompliance
noncompliance_df <-compliance_df %>%
  mutate(noncompliance = 1 - Compliance_Ratio)%>%
  mutate(LOWINCPCT = LOWINCPCT*100)%>% # turn proportions --> %
  mutate(GEOID = FPS_ID)


# export data set
# use to make ComplianceIncomemap_CT_Joined map layer in Esri
write.csv(noncompliance_df, "datasets/NoncomplianceCensusTract.csv", row.names = FALSE)


