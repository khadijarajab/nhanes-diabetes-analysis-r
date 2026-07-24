# NHANES Diabetes- Medication Compliance and Treatment Efficacy Analysis Using R
## Project Overview
This repository presents an end-to-end analysis of diabetes management data from the National Health and Nutrition Examination Survey (NHANES), conducted by the U.S. Centers for Disease Control and Prevention (CDC). The project investigates differences in glycated haemoglobin (HbA1c) levels among adults with diabetes according to three treatment strategies: lifestyle modification, oral medication, and insulin therapy.

*The analysis was completed entirely in R using a reproducible workflow, from data import and preparation to statistical analysis, visualization, interpretation, and reporting.*

## Study Objective
To compare HbA1c levels among adults with diabetes receiving different treatment strategies and demonstrate a complete biomedical data analysis workflow using R.

## Dataset
- **Source**:National Health and Nutrition Examination Survey (NHANES)
- **Provider**: U.S. Centers for Disease Control and Prevention (CDC)

The project combines multiple NHANES datasets containing participant demographics, laboratory measurements, and diabetes questionnaire data to create an analysis-ready dataset.

## Analysis Workflow
The analysis followed a structured workflow:
- Import NHANES SAS Transport (.xpt) files into R
-  Merge multiple datasets
- Clean and prepare the data
- Recode treatment categories
- Handle missing values
- Perform exploratory data analysis
- Generate descriptive statistics
- Assess statistical assumptions
- Conduct non-parametric statistical analysis
- Create publication-quality visualizations
- Interpret findings in a clinical context
- Produce a reproducible R Markdown report

## Statistical Methods
The following statistical methods were applied:
- Descriptive statistics
- Kruskal–Wallis test
- Dunn's post-hoc multiple comparison test
- Boxplots using ggplot2
- Statistical annotation using ggpubr
*The choice of non-parametric methods was informed by the distribution of HbA1c values and the violation of parametric assumptions.*

## Key Findings
The analysis showed statistically significant differences in HbA1c levels across treatment groups.
Participants receiving insulin therapy had the highest HbA1c values and the greatest variability, while individuals managed through lifestyle modification generally exhibited lower HbA1c levels.

*The findings highlight the importance of interpreting observational clinical data within the context of disease severity and treatment allocation rather than assuming causal relationships.*

## Skills Demonstrated
## *Data Management*
- Importing SAS Transport (.xpt) files
- Dataset merging
- Data cleaning
- Variable transformation
- Missing data management

## Statistical Analysis
- Exploratory Data Analysis (EDA)
- Descriptive statistics
- Non-parametric hypothesis testing
- Interpretation of statistical results

## Data Visualization
- Publication-quality graphics using ggplot2
- Statistical significance annotation using ggpubr

## Reproducible Research 
- R scripts
- R Markdown
- Knitted PDF reports
- Structured analytical workflow

## R Packages Used
- haven
- dplyr
- ggplot2
- ggpubr
- rstatix
- knitr

## What I Learned
This project strengthened my understanding of:
- Working with CDC NHANES data
- Importing SAS Transport (.xpt) files into R
- Modern data manipulation using the tidyverse
- Data merging and cleaning
- Exploratory data analysis
- Choosing appropriate statistical methods
- Clinical interpretation of statistical findings
8. Producing reproducible analytical reports using R Markdown
9. It also reinforced the importance of understanding why a statistical method is appropriate rather than simply applying it.
