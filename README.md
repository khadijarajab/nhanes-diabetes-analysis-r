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
1. Import NHANES SAS Transport (.xpt) files into R
2. Merge multiple datasets
3. Clean and prepare the data
4. Recode treatment categories
5. Handle missing values
6. Perform exploratory data analysis
7. Generate descriptive statistics
8. Assess statistical assumptions
9. Conduct non-parametric statistical analysis
10. Create publication-quality visualizations
11. Interpret findings in a clinical context
12. Produce a reproducible R Markdown report

## Statistical Methods
The following statistical methods were applied:
1. Descriptive statistics
2. Kruskal–Wallis test
3. Dunn's post-hoc multiple comparison test
4. Boxplots using ggplot2
5. Statistical annotation using ggpubr
*The choice of non-parametric methods was informed by the distribution of HbA1c values and the violation of parametric assumptions.*

## Key Findings
The analysis showed statistically significant differences in HbA1c levels across treatment groups.
Participants receiving insulin therapy had the highest HbA1c values and the greatest variability, while individuals managed through lifestyle modification generally exhibited lower HbA1c levels.

*The findings highlight the importance of interpreting observational clinical data within the context of disease severity and treatment allocation rather than assuming causal relationships.*

## Skills Demonstrated
## *Data Management*
1. Importing SAS Transport (.xpt) files
2. Dataset merging
3. Data cleaning
4. Variable transformation
5. Missing data management

## Statistical Analysis
1. Exploratory Data Analysis (EDA)
2. Descriptive statistics
3. Non-parametric hypothesis testing
4. Interpretation of statistical results

## Data Visualization
1. Publication-quality graphics using ggplot2
2. Statistical significance annotation using ggpubr

## Reproducible Research 
1. R scripts
2. R Markdown
3. Knitted PDF reports
4. Structured analytical workflow

## R Packages Used
1. haven
2. dplyr
3. ggplot2
4. ggpubr
5. rstatix
6. knitr

## What I Learned
This project strengthened my understanding of:
1. Working with CDC NHANES data
2. Importing SAS Transport (.xpt) files into R
3. Modern data manipulation using the tidyverse
4. Data merging and cleaning
5. Exploratory data analysis
6. Choosing appropriate statistical methods
7. Clinical interpretation of statistical findings
8. Producing reproducible analytical reports using R Markdown
9. It also reinforced the importance of understanding why a statistical method is appropriate rather than simply applying it.
