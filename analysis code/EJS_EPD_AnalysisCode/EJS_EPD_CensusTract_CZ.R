# summary of script
# merged EPD_tract (from Michael) with EJS to get low income + compliance together

# install.packages("ggpubr")
library(tidyverse)
library(forcats)
library(ggpubr)

# load datasets
tractwater <- read.csv("datasets/EPD_tract.csv")
ejs <- read.csv("datasets/EJScreenData.csv")

# calculate compliance ratio as miles of supporting/miles of nonsupporting
tractwater$binary_var <- ifelse(df$original_var > 10, 1, 0)
  

# filter for GA
ejs_ses <- ejs %>%
  filter(STATE_NAME == "GEORGIA")%>%
  select(ID,CNTY_NAME, LOWINCPCT)

# rename column names to match
colnames(ejs_ses)
colnames(water)
names(ejs_ses)[names(ejs_ses) == "CNTY_NAME"] <-"County"
names(ejs_ses)[names(ejs_ses) == "ID"] <-"FPS_ID"
colnames(ejs_ses)

# change county name entries to match
names <- tractwater$County
county <- rep(c(" County"), length(names))
exp_names <- paste0(names, county)
tractwater$County <- exp_names
names(tractwater)
tractwater$County
names(tractwater)[names(tractwater) == "GEOID"] <-"FPS_ID"
colnames(tractwater)

# select EPD vars of interest
water_1 <- tractwater %>%
  select(Assessment, FPS_ID, latitude, longitude)
water_1$FPS_ID
ejs_ses$FPS_ID

# merge data sets 
data <- merge(ejs_ses, water_1, by = "FPS_ID")
data

# check total # of census tracts included
length(unique(data$FPS_ID))

# turn income proportions --> percentages (only run this once!)
# data <- data %>%
#   mutate(LOWINCPCT = LOWINCPCT * 100)

# export data set
write.csv(data, "datasets/EPD_EJS_MERGED.csv", row.names = FALSE)

# plot income by use 
data$Assessment <- factor(data$Assessment, levels = c("Not Supporting", "Supporting", "Assessment Pending"))

my_comparisons <- list(
  c("Supporting", "Not Supporting"),
  c("Supporting", "Assessment Pending"))


ggplot(data = data, aes(x=LOWINCPCT,y=Assessment, fill = Assessment))+
  geom_boxplot()+
  xlab("Low Income Percentile")+
  ylab("Outcome of Water Quality Assessment")+
  ggtitle("Water Quality Assessment Failure More Common in Low Income Regions of GA")+
  theme(plot.title = element_text(hjust = 0.5))+
  stat_compare_means(comparisons = my_comparisons, method = "t.test", 
                     label = "p.signif")+
  theme(legend.position = "none")+
  annotate("text", x = Inf, y = 3.4, hjust = 1.1, vjust = -0.5,
           label = "**** indicates p-value <0.0001", size = 4, color = "black")+
  coord_cartesian(clip = "off")+
  scale_x_continuous(labels = function(x) paste0(x, "%"))


# examine median and avg. % income by assessment outcome
data %>%
  group_by(Assessment)%>%
  summarise(
    med_perc_li = median(LOWINCPCT),
    avg_perc_li = mean(LOWINCPCT)
  )

# conduct t tests for significant difference in income between assessment types
not_supporting <- data %>%
  filter(Assessment == "Not Supporting")%>%
  select(LOWINCPCT)
length(not_supporting$LOWINCPCT)

supporting <- data %>%
  filter(Assessment == "Supporting")%>%
  select(LOWINCPCT)
length(supporting$LOWINCPCT)

pending <- data %>%
  filter(Assessment == "Assessment Pending")%>%
  select(LOWINCPCT)
length(pending$LOWINCPCT)

# check variance
var(not_supporting)
var(supporting)
var(pending)

# t tests
t.test(not_supporting, supporting, var.equal = TRUE)
t.test(pending, supporting, var.equal = FALSE)



