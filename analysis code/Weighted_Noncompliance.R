library(tidyverse)

# load datasets
tractwater <- read.csv("EPD_tract.csv")
ejs <- read.csv("datasets/EJScreenData.csv")

unique(tractwater$SizeUnit)
# all units in miles

# size = length of assessed reach
ggplot(data = tractwater)+
  geom_histogram(aes(x = Size), alpha = 0.5, fill = "red")


# filter for GA
ejs_ses <- ejs %>%
  filter(STATE_NAME == "GEORGIA")%>%
  select(ID,CNTY_NAME, LOWINCPCT)

# rename column names to match
colnames(ejs_ses)
colnames(tractwater)
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
  select(Assessment, FPS_ID, latitude, longitude, Size)%>%
  drop_na()
water_1$FPS_ID
ejs_ses$FPS_ID

# binarize assessment outcome
water_1$Binary_Assess <- ifelse(water_1$Assessment == "Supporting", 1, 0)


# merge data sets 
data <- merge(ejs_ses, water_1, by = "FPS_ID")
data


# calculate noncompliance ratio as miles of supporting/total miles assessed
# per census tract

weighted_df <- data %>%
  group_by(FPS_ID)%>%
  summarize(support_miles = sum(Size*Binary_Assess),
            total_miles = sum(Size),
            unweighted_compliance = mean(Binary_Assess),
            unweighted_noncompliance = 1 - unweighted_compliance)

compliance_ratios <- weighted_df %>%
  mutate(Compliance_Ratio = support_miles / total_miles)%>%
  mutate(Noncompliance_Ratio = 1 - Compliance_Ratio)

# merge low income back in
income_df <- data%>%
  select(FPS_ID, County, LOWINCPCT)%>%
  unique()

compliance_ratios <- merge(compliance_ratios, income_df, by = "FPS_ID")

# convert income to percentage (only run once)
# compliance_ratios$LOWINCPCT <- compliance_ratios$LOWINCPCT*100


# compare weighted and unweighted versions
ggplot(data = compliance_ratios)+
  geom_histogram(aes(x = Noncompliance_Ratio))+
  geom_histogram(aes(x = unweighted_noncompliance), fill = "red", alpha = 0.5)
# not a huge difference in distribution

# compare with income
ggplot(data = compliance_ratios)+
  geom_point(aes(x = LOWINCPCT, y = Noncompliance_Ratio))+
  geom_point(aes(x = LOWINCPCT, y = unweighted_noncompliance), color = "blue", alpha = 0.5)
# not a huge difference in relationship with income

# compare using regression
lm.weighted <- lm(data = compliance_ratios, Noncompliance_Ratio ~ LOWINCPCT)
summary(lm.weighted)

lm.unweighted <- lm(data = compliance_ratios, unweighted_noncompliance ~ LOWINCPCT)
summary(lm.unweighted)
# not a huge difference in relationship with income

# which counties have highest noncompliance + highest low income
compliance_ratios <- compliance_ratios%>%
  arrange(desc(Noncompliance_Ratio), desc(LOWINCPCT))

compliance_ratios[1:20,7:9]

Fulton_df <-compliance_ratios%>%
  filter(County =="Fulton County")

Fulton_df$pred <- predict(lm(data = Fulton_df, Noncompliance_Ratio ~ LOWINCPCT))
ggplot(data = Fulton_df)+
  geom_point(aes(x = LOWINCPCT, y = Noncompliance_Ratio))+
  geom_line(aes(x = LOWINCPCT, y = pred), color = "red")

Clarke_df <-compliance_ratios%>%
  filter(County =="Clarke County")

Clarke_df$pred <- predict(lm(data = Clarke_df, Noncompliance_Ratio ~ LOWINCPCT))
ggplot(data = Clarke_df)+
  geom_point(aes(x = LOWINCPCT, y = Noncompliance_Ratio))+
  geom_line(aes(x = LOWINCPCT, y = pred), color = "red")

Muscogee_df <-compliance_ratios%>%
  filter(County =="Muscogee County")

Muscogee_df$pred <- predict(lm(data = Muscogee_df, Noncompliance_Ratio ~ LOWINCPCT))
ggplot(data = Muscogee_df)+
  geom_point(aes(x = LOWINCPCT, y = Noncompliance_Ratio))+
  geom_line(aes(x = LOWINCPCT, y = pred), color = "red")

Dougherty_df <-compliance_ratios%>%
  filter(County =="Dougherty County")

Dougherty_df$pred <- predict(lm(data = Dougherty_df, Noncompliance_Ratio ~ LOWINCPCT))
ggplot(data = Dougherty_df)+
  geom_point(aes(x = LOWINCPCT, y = Noncompliance_Ratio))+
  geom_line(aes(x = LOWINCPCT, y = pred), color = "red")

Carroll_df <-compliance_ratios%>%
  filter(County =="Carroll County")

Carroll_df$pred <- predict(lm(data = Carroll_df, Noncompliance_Ratio ~ LOWINCPCT))
ggplot(data = Carroll_df)+
  geom_point(aes(x = LOWINCPCT, y = Noncompliance_Ratio))+
  geom_line(aes(x = LOWINCPCT, y = pred), color = "red")+
  xlab("Low Income Percentile")+
  ylab("Noncompliance Ratio")+
  ggtitle("Noncompliance is Higher in Lower Income Regions of Carroll County")
summary(lm(data = Carroll_df, Noncompliance_Ratio ~ LOWINCPCT))


Bulloch_df <-compliance_ratios%>%
  filter(County =="Bulloch County")

Bulloch_df$pred <- predict(lm(data = Bulloch_df, Noncompliance_Ratio ~ LOWINCPCT))
ggplot(data = Bulloch_df)+
  geom_point(aes(x = LOWINCPCT, y = Noncompliance_Ratio))+
  geom_line(aes(x = LOWINCPCT, y = pred), color = "red")

compliance_ratios$GEOID <- compliance_ratios$FPS_ID

# export weighted compliance/noncompliance data set

write.csv(compliance_ratios, "compliance_weighted.csv", row.names = FALSE)

