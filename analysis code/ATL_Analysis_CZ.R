## summary of code
## explore relationship between water compliance and income in ATL and 
## rest of Georgia separately


EPD_EJS <- read.csv("datasets/EPD_EJS_MERGED.csv")
nc <- read.csv("datasets/noncompliance.csv") ## from Hansen

# merge in County names
County_df <- EPD_EJS%>%
  select(FPS_ID, County)%>%
  unique()


noncomp_cnty <- merge(nc, County_df, by = "FPS_ID")

noncomp_cnty$Noncompliance_Ratio <- noncomp_cnty$noncompliance

noncomp_cnty <- noncomp_cnty %>%
  select(-noncompliance)

write.csv(noncomp_cnty, "datasets/EPD_EJS_MERGED_cnty.csv", row.names = FALSE)

# check relationship between compliance and income
lm(data = noncomp_cnty, Noncompliance_Ratio~LOWINCPCT)

# test income-assessment relationship for atl separately
EPD_ATL_df <- EPD_EJS%>%
  filter(County == "Cherokee County" | County =="Clayton County" |
           County == "Cobb County" | County =="DeKalb County" |
           County =="Douglas County" |
           County == "Fayette County" | County =="Forsyth County" |
           County == "Fulton County" | County =="Gwinnett County" |
           County == "Henry County" | County =="Rockdale County")



# examine median and avg. % income by assessment outcome
EPD_ATL_df$Assessment <- factor(EPD_ATL_df$Assessment, levels = c("Not Supporting", "Supporting", "Assessment Pending"))
EPD_ATL_df %>%
  group_by(Assessment)%>%
  summarise(
    med_perc_li = median(LOWINCPCT),
    avg_perc_li = mean(LOWINCPCT)
  )
# still a difference in median percentile between supporting + nonsupporting

# create dataset with non-Atlanta Counties only
EPD_nonATL_df <- EPD_EJS%>%
  filter(County != "Cherokee County" & County !="Clayton County" &
           County != "Cobb County" & County !="DeKalb County" &
           County !="Douglas County" &
           County != "Fayette County" & County !="Forsyth County" &
           County != "Fulton County" & County !="Gwinnett County" &
           County != "Henry County" & County !="Rockdale County")

EPD_nonATL_df$Assessment <- factor(EPD_nonATL_df$Assessment, levels = c("Not Supporting", "Supporting", "Assessment Pending"))
EPD_nonATL_df %>%
  group_by(Assessment)%>%
  summarise(
    med_perc_li = median(LOWINCPCT),
    avg_perc_li = mean(LOWINCPCT)
  )
# still a difference in median percentile between supporting + nonsupporting

## test noncompliance ratio for atl separately

# create dataset with Atlanta Counties only
ATL_df <- noncomp_cnty%>%
  filter(County == "Cherokee County" | County =="Clayton County" |
           County == "Cobb County" | County =="DeKalb County" |
           County =="Douglas County" |
           County == "Fayette County" | County =="Forsyth County" |
           County == "Fulton County" | County =="Gwinnett County" |
           County == "Henry County" | County =="Rockdale County")

# create dataset with non-Atlanta Counties only
nonATL_df <- noncomp_cnty%>%
  filter(County != "Cherokee County" & County !="Clayton County" &
           County != "Cobb County" & County !="DeKalb County" &
           County !="Douglas County" &
           County != "Fayette County" & County !="Forsyth County" &
           County != "Fulton County" & County !="Gwinnett County" &
           County != "Henry County" & County !="Rockdale County")

# compare distributions

# ATL
ggplot(data = ATL_df)+
  geom_histogram(aes(x = Noncompliance_Ratio))
ggplot(data = ATL_df)+
  geom_histogram(aes(x = LOWINCPCT))

# non ATL
ggplot(data = nonATL_df)+
  geom_histogram(aes(x = Noncompliance_Ratio))
ggplot(data = nonATL_df)+
  geom_histogram(aes(x = LOWINCPCT))
# more low income communities outside of ATL


# checking significance of income - noncompliance correlation outside of ATL
lm.1 <- lm(data = nonATL_df, Noncompliance_Ratio ~LOWINCPCT)

# relationship is still signficant but very weak
summary(lm.1)

nonATL_df$pred <- predict(lm.1)

ggplot(data = nonATL_df)+
  geom_point(aes(x = Noncompliance_Ratio,LOWINCPCT))+
  geom_line(aes(x = LOWINCPCT, y=pred), color = "red")



# checking significance of income - noncompliance correlation in ATL counties
lm.2 <- lm(data = ATL_df, Noncompliance_Ratio ~LOWINCPCT)

# relationship is still signficant but very weak
summary(lm.2)

ggplot(data = ATL_df)+
  geom_point(aes(x = LOWINCPCT, y=Noncompliance_Ratio))
