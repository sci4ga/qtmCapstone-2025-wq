# qtmCapstone-2025-wq

## Contributing Members
Keerthy Rangan, Claire Zegger, Hansen Xu

## Featured Notebooks/Analysis/Deliverables
* [Data Story](https://storymaps.arcgis.com/stories/100c1d6313e843b9b59f5f519ce65049)
* [Data Repository](https://sci4ga.sharepoint.com/sites/ScienceforGeorgiaInc/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FScienceforGeorgiaInc%2FShared%20Documents%2FGeneral%2FPROGRAMS%2FDATA%20FOCUSED%20PROGRAMS%2FDATA%20REPOSITORY%2FQTM%20Spring%202025%2FWaterQuality%2FData%20Catalogue&viewid=3bfa4f5a%2Da38d%2D4219%2Db156%2D622e67e3eb53&p=true&ga=1&LOF=1)
* [Data Sets](https://sci4ga.sharepoint.com/sites/ScienceforGeorgiaInc/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FScienceforGeorgiaInc%2FShared%20Documents%2FGeneral%2FPROGRAMS%2FDATA%20FOCUSED%20PROGRAMS%2FDATA%20REPOSITORY%2FQTM%20Spring%202025%2FWaterQuality%2FCleanedDatasets&viewid=3bfa4f5a%2Da38d%2D4219%2Db156%2D622e67e3eb53&p=true&ga=1&LOF=1)
* [Analysis Code](https://github.com/sci4ga/qtmCapstone-2025-wq/tree/main/analysis%20code)

## Project Intro/Objective
Our project focused on what water quality looks like throughout Georgia, with specific focuses on contamination metrics and the whether waterbodies in Georgia are meeting standards/policies put out. We also examined different socioeconomic factors affecting water quality, such as income and population density, to see if policies need to be introduced that address correlations between SES and water quality metrics.


### Methods Used
* Summary Statistics
* Linear Regression
* Data Visualization
* Predictive Modeling

### Languages
* R 
* Python

### R Packages
* tidyverse
* modelr
* ggplot2
* ggpubr
* forcats

### Python Packages
* Pandas
* Numpy
* Matplotlib

## Project Description

## Datasets 

**Adopt a Stream**

Adopt a Stream (AAS) is a Citizen Science organization that encourages citizens to monitor Georgia’s streams, lakes, and other water bodies. We used 2 different datasets from 2022 from this organization to monitor two water quality metrics – E Coli Colony Averages and Dissolved Oxygen levels.

The bacterial dataset from AAS was used to create unsafe/safe thresholds for E Coli colony averages by examining the E Coli Colony Avg variable and creating thresholds based on prior research stating what specific amount of colony forming units is considered unsafe. Although we had single sample E Coli counts, we just used the overall average of a site’s E Coli colony counts. 

The chemical dataset from AAS was used to create unsafe/safe thresholds for Dissolved Oxygen levels by examining the water temperature variable in this dataset and creating  a regression between the water_temp and dissolved oxygen level variables, seeing if a specific amount of dissolved oxygen was lower than the predicted amount based on the best fit line. We categorized each site tested as safe or unsafe.

We also computed the correlations between each of the water quality metrics we used and  income levels, which we got from the EJScreen dataset. Since we measured income level based on census tract, we geocoded latitude and longitude locations from AAS to census tracts, and grouped the dissolved oxygen and E Coli levels based on census tract.

**EPD**

The Georgia Environmental Protection Division is an agency from the Natural Protection Division  that deals with protecting air, land, and water resources. The laws enacted by them regulate private and public facilities in areas of air and water quality. We used two different datasets from the EPD – Lakes/Sounds and Streams/Beaches. Merging these datasets allowed us to get data from many different water bodies, and the primary variables we used was the designated uses variable and their supporting assessment, which stated the designated use for a waterbody in a specific county. We also used the merged dataset to compute a noncompliance ratio based on the total amount of water bodies that supported their designated use. 

**EJScreen**

The census-tract level metric for low income percentile used in this project was obtained from EJScreen, a data mapping tool created by the Environmental Protection Agency (EPA). Socioeconomic status indicators (and specifically low income level) contained in EJScreen were retrieved from the  U.S. Census Bureau’s American Community Survey (ACS) 2018-2022 5-Year Estimates (ACS 2022). See [here](https://www.epa.gov/system/files/documents/2024-07/ejscreen-tech-doc-version-2-3.pdf) for in-depth documentation of EJScreen’s data sources and measurements.

**ACS**

The American Census Survey is an annual survey used to collect demographic information of the US population. We collected census tract-based data from 2022 on the population density of Georgia census tracts. We did so to measure the correlation between E Coli and income separated by different types of population densities. We looked at their correlation in rural and urban areas. Separating rural and urban densities by specific thresholds, we were able to find distinct types of correlations in these areas, due to population density potential causing more E Coli counts based on prior research.


## Analysis Choices

**Dissolved Oxygen**

To analyze Dissolved Oxygen in Georgia, we used Python.  First, we created thresholds for what is considered “Rarely Unsafe”, “Sometimes Unsafe”, “Tends to be Unsafe”, and “Often Unsafe”. Dissolved Oxygen can be affected by water temperature, so we performed a regression analysis to get a best-fit line between dissolved oxygen and water temperature. We were able to get predicted values of dissolved oxygen based on this line,and if the predicted value of dissolved oxygen based on the water temperature was higher than the actual dissolved oxygen value, it would be considered unsafe. After getting safe/unsafe measurements for all the latitudes/longitudes, we grouped them by site, and gave specific thresholds for the 4 categories listed above. If 95% of all the dissolved oxygen sites were “Unsafe”, we considered them “Often Unsafe’. If there were 50% of all sites considered as “Unsafe”, we made them “Tends to be Unsafe”. If it was 80%, they were “Sometimes Unsafe”. Else, they were considered “Rarely Unsafe”. We also made sure that the water temperature was not too high, so we made the water temperatures be from  less than 20 degrees C. We also made sure the pH was in a good range, so we made the dataset have pHs greater than 6.5 and less than 8.5. We then mapped these thresholds onto ArcGIS to get a geographic distribution of these sites.

After this, we examined their correlation with income. We did so by geocoding their latitudes and longitudes to Census Tract, as our income dataset was by Census Tract. After this, we generated a bar plot, with the threshold groups on the x-axis and the low-income percentages of each census tract on the y-axis. We also ran an ANOVA test to test if this correlation is statistically significant.

**E Coli Colony Averages**

To analyze E Coli colony averages in Georgia using Python, we first created thresholds for what is considered “Rarely Unsafe”, “Sometimes Unsafe”, “Tends to be Unsafe”, and “Often Unsafe”. We did research and found that sites with less than 100 average were considered “Rarely Unsafe”, sites with less than 235 cfu average were considered “Tends to be Unsafe”, sites with less than 410 were considered “Sometimes Unsafe”, and sites with greater than 410 were considered “Often Unsafe”. We also made sure that the water temperature was at a good threshold, so we made the minimum temperature greater than 10, and the maximum less than 49 deg C. We grouped these measurements by site, and then mapped these thresholds onto ArcGIS to get a geographic distribution of these sites.

After this, we examined their correlation with income. We did so by geocoding their latitudes and longitudes to Census Tract, as our income dataset was by Census Tract. After this, we separated these census tracts by population density, and considered population densities less than 500 as rural, and ones greater than 1000 as urban. We then generated heatmaps for each population density group’s correlations, and then performed ANOVAs for both categories to get their respective p-values to test for statistical significance. 

**Assessment Outcomes** 

In order to examine how water assessment outcomes differed by low income percentile, we merged the EPD_tract dataset to census tract low income percentiles from the EJScreen dataset. The assessment variable was factored into three levels: “Supporting,” “Pending” and “Not Supporting” and then the low income percentile of the census tract where that assessment occurred was plotted as a boxplot. The difference in the median low income percentile between assessment outcomes was verified as statistically significant by performing a two sample t-test. See [EJS_EPD_CensusTract_CZ.R](https://github.com/sci4ga/qtmCapstone-2025-wq/tree/main/analysis%20code/EJS_EPD_AnalysisCode) for full analysis code.

**Compliance Ratio**

This metric is manually created to test whether the community follows the original use of the water in each census tract. In the merged dataset as described in data catalogue-Hansen Xu, which was created by combining water quality datasets and income percentile datasets, we captured the column Assessment and Category. The category column is used to describe whether the water is under full review. Category 1 means the water is fully reviewed and censused, which is mapped as complied. Category 2-3N is pending, meaning the water is under review for now. The rest of the categories indicate that at least one use is violated for each of the water, which is assigned as not-complied. After that, we calculated the compliance ratio by each county, which is the number of compiled water divided by the total number of water in this county, getting the new column-Compliance_Ratio. After calculating this, we have the low-income percentile and compliance ratio in county level, which is great for searching their relationship. However, at this level, the number of the data points is still so small. To analyze each county in a more detailed way, we apply the same procedure on the level of census tracts that are used for testing, which allows us to investigate the relationship with 3000+ data entries. This more-refined dataset ensures the robustness of our finding, making statistically significant results in the end.

**Weighted Noncompliance Ratio**

In order to control for differences in the reach length of different water body assessments, we created a weighted noncompliance ratio that describes the proportion of noncompliant miles of assessed water out of the total miles of assessed water per census tract. For all entries in the EPD_tract dataset with an assessment outcome of “supporting” were binarized as 1 (“not supporting” and “pending assessments” were binarized as 0), multiplied by the size (in miles) of the assessment reach, then grouped by census tract and averaged to get a weighted compliance ratio. The weighted noncompliance ratio was then obtained by subtracting the weighted compliance ratio from 1. The resulting data table entitled “compliance_weighted.csv” was used to create the noncompliance ratio maps that appear in the data story. See [Weighted_Noncompliance.R](https://github.com/sci4ga/qtmCapstone-2025-wq/tree/main/analysis%20code/EJS_EPD_AnalysisCode) for the full analysis code used to create this dataset.

**Regional analysis**

We performed separate analyses for counties around Atlanta to see if the relationship between water compliance, assessment outcomes, and low income level was different than for the rest of Georgia. We used R to filter for counties in and around Atlanta, then examined the distribution of low income percentile and noncompliance in this subset of data, and compared it to the rest of Georgia. See [ATL_analysis_CZ.R](https://github.com/sci4ga/qtmCapstone-2025-wq/tree/main/analysis%20code/EJS_EPD_AnalysisCode) for the full analysis code.


## Getting Started
1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Download the [data Sets](https://sci4ga.sharepoint.com/sites/ScienceforGeorgiaInc/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FScienceforGeorgiaInc%2FShared%20Documents%2FGeneral%2FPROGRAMS%2FDATA%20FOCUSED%20PROGRAMS%2FDATA%20REPOSITORY%2FQTM%20Spring%202025%2FWaterQuality%2FCleanedDatasets&viewid=3bfa4f5a%2Da38d%2D4219%2Db156%2D622e67e3eb53&p=true&ga=1&LOF=1) from the Science4GA repository.
5. Data processing/transformation scripts are being kept in this folder: [Analysis Code](https://github.com/sci4ga/qtmCapstone-2025-wq/tree/main/analysis%20code)






