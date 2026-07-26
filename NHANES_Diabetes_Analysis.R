# 2021-2023 National Health and Nutritional Examination Survey Data (NHANES) 
#=============================================================================
   #  Notes about the dataset and the project i intend to work on
#===============================================================================
#The National Health and Nutrition Examination Survey (NHANES) is a major program by the CDC's National Center for Health Statistics. It assesses the health and nutritional status of adults and children in the United States through a combination of home interviews and physical examinations.

#===============================================================================
#Core Features of NHANES
#=============================================================================
#1.Study Design: Combines interviews (demographics, socioeconomic, dietary, and health questions) with physical and laboratory examinations conducted in Mobile Examination Centers (MECs).
#2.Target Population: Nationally representative, non-institutionalized U.S. population.
#3.Frequency: Conducted on an ongoing, continuous basis with data released in two-year cycles.

#===============================================================================
#Types of Data Collected
#===============================================================================
#1.Demographic Data: Age, race/ethnicity, and income information.
#2.Dietary Data: Individual dietary intake and supplement usage.
#3.Examination Data: Body measurements (BMI, waist circumference), blood pressure, dental health, and vision testing.
#4.Laboratory Data: Blood and urine tests, testing for diabetes, cholesterol, environmental exposures, and infectious diseases.
#5.Questionnaire Data: Medical history, mental health, and lifestyle behaviors.

#===============================================================================
#selected variables for my study.
#===============================================================================
#1. Demographics & Household (Variables 1–22)These variables establish who the participant is, their household environment, their education, and basic status indicators.

# variables
#SEQN: Respondent Sequence Number (Your unique participant ID key).
#RIAGENDR: Gender (1 = Male, 2 = Female).
#RIDAGEYR: Age in years at the time of screening.
#DMDBORN4: Country of Birth (United States, US Territories, or Born Abroad).
#DMDHRMAZ: Marital status of the Household Reference Person.


#2. Survey Weights & Survey Design (Variables 23–27 & 36, 38)NHANES samples specific groups disproportionately. These variables are statistical adjusters used to make your sample calculations accurately mirror the true, entire US population.

# variables
#SDMVSTRA: Masked Variance Pseudo-Stratum (Used for estimating sampling errors).
#SDMVPSU: Masked Variance Pseudo-Primary Sampling Unit.
#WTSAF2YR: Fasting Subsample 2-Year Weight (Crucial: You must use this weight when calculating true US population averages for Fasting Glucose).


# 3. Diabetes Questionnaire Responses (Variables 28–35)Self-reported conditions collected by an interviewer during the home screening phase.

# variables
#DIQ010: Has a doctor ever told you that you have diabetes? (1=Yes, 2=No, 3=Borderline).
#DID040: Age when you were first told by a doctor that you had diabetes.
#DIQ160: Has a doctor ever told you that you have prediabetes or borderline diabetes?
#DIQ050: Are you currently taking insulin?
#DIQ070: Are you currently taking diabetic pills to lower your blood sugar?

#4. Laboratory Blood Biomarkers (Variables 37, 39–40)Objective, machine-measured blood work variables.

# variables
#LBXGH: Glycohemoglobin / HbA1c Percentage (%) (Reflects 3-month average blood sugar levels).
#LBXGLU: Fasting Plasma Glucose in US conventional units (mg/dL).
#LBDGLUSI: Fasting Plasma Glucose converted mathematically into International Standard SI units (mmol/L).

#5. Body Measures & Anthropometrics (Variables 41–61)Measurements taken physically by clinical practitioners. Variables starting with BMX are raw measurements; variables starting with BMI or BMD indicate data flags, measurement comments, or categorical index statuses.

# variables
#BMXWT: Body Weight recorded in kilograms (kg).
#BMXBMI: Body Mass Index (\(kg/m^2\)).

# project that I am working om;
# Medication Compliance & Treatment EfficacyBy selecting medication status (DIQ050 for insulin and DIQ070 for oral pills), you can segment your diagnosed diabetics into treatment types.How to do it: Group your diagnosed participants into three groups: Lifestyle alone (No pills/Insulin), Oral Medication Only, or Insulin Users.The Goal: You can evaluate the clinical efficacy of their treatments by checking their average HbA1c (LBXGH). This allows you to answer: What percentage of people on oral medications are successfully keeping their blood sugar in the safe zone (under 7%)?
# =============================================================================
                     
# =============================================================================
#The actual Analysis;
# ==============================================================================
# PROJECT: REPRODUCIBLE DIABETES MANAGEMENT STUDY (NHANES DATA)
# =============================================================================

# ==============================================================================
# PROJECT TITLE: Medication Compliance & Treatment Efficacy
# ==============================================================================
# DESCRIPTION:
# By selecting medication status (DIQ050 for insulin and DIQ070 for oral pills), 
# this study segments diagnosed diabetic participants into distinct treatment 
# archetypes to evaluate the clinical efficacy of their regimens.
# 
# METHODOLOGY:
# Group diagnosed participants into three distinct cohorts:
#   1. Diet & Lifestyle Alone (No pills / No insulin)
#   2. Oral Medication Only
#   3. Insulin Users

# RESEARCH GOAL:
# Evaluate real-world clinical efficacy by examining average HbA1c (LBXGH). 
# This analysis explicitly answers: What percentage of individuals across 
# these treatment groups are successfully keeping their blood sugar levels 
# within the safe clinical zone (HbA1c under 7%)?
# =============================================================================

# --- STEP 1: LOAD REQUIRED ANALYTICAL TOOLKITS ---
if(!require(haven)) install.packages("haven")     # For reading CDC SAS files (.xpt)
if(!require(tidyverse)) install.packages("tidyverse") # For dplyr pipes & ggplot2
if(!require(rstatix)) install.packages("rstatix")   # For piped tidy statistics
if(!require(ggpubr)) install.packages("ggpubr")
library(ggpubr)
library(haven)
library(dplyr)
library(ggplot2)
library(rstatix)

# --- STEP 2: LOAD RAW MANUALLY DOWNLOADED CDC NHANES FILES ---
# (Ensure your working directory matches where you saved your files)

setwd("C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES")

Demo <- read_xpt("C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/DEMO_L.xpt")  # Demographics

Dia <- read_xpt("C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/DIQ_L.xpt")# Diabetes Questionnaire

Glycohemo <- read_xpt("C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/GHB_L.xpt") # Glycohemoglobin (HbA1c) lab

Plasfasgluc <- read_xpt("C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/GLU_L.xpt") # Plasma Fasting Glucose lab

BMX<- read_xpt("C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/P_BMX.xpt")# Body Measures exam


# --- STEP 3: THE PIPED DATA CLEANING ---

Diabetes_data<- merge(Demo,Dia, by = "SEQN", all = TRUE) %>%
  # 1. Sequential outer joins to link all files together
  merge(Dia, by = "SEQN", all = TRUE) %>%
  merge(Glycohemo, by = "SEQN", all = TRUE) %>%
  merge(Plasfasgluc, by = "SEQN", all = TRUE) %>%
  merge(BMX, by = "SEQN", all = TRUE) 

#Verify my final Diabetes_data- dataframe structure and variable names.
str(Diabetes_data) # the dataframe has 26233 observations and 69 variables
names(Diabetes_data)
 
Diabetes_data$DID040.x

# 1. Keep only the core variables that I want to analyse
Clean_Diabetes_data <- Diabetes_data %>%
  # 1. Keep only my exact list of 18 target variables
  select(
    SEQN, RIAGENDR, RIDAGEYR, DMDBORN4, DMDHRMAZ,        # Demographics
    SDMVSTRA, SDMVPSU, WTSAF2YR,                         # Survey Design/Weights
    DIQ010, DID040, DIQ160, DIQ050, DIQ070,              # Questionnaire
    LBXGH, LBXGLU, LBDGLUSI,                             # Laboratory
    BMXWT, BMXBMI                                        # Body Measures
  ) %>%
  
  # 2. Rename the variables to clean, human-readable titles
  rename(
    ID                 = SEQN,
    Gender             = RIAGENDR,
    Age                = RIDAGEYR,
    Birth_Country      = DMDBORN4,
    Household_Marital  = DMDHRMAZ,
    Pseudo_Stratum     = SDMVSTRA,
    Pseudo_PSU         = SDMVPSU,
    Fasting_Weight     = WTSAF2YR,
    Self_Diabetes      = DIQ010,
    Age_At_Diagnosis   = DID040,
    Self_Prediabetes   = DIQ160,
    Takes_Insulin      = DIQ050,
    Takes_Diabetes_Pills = DIQ070,
    HbA1c_Percent      = LBXGH,
    Glucose_mg_dL      = LBXGLU,
    Glucose_mmol_L     = LBDGLUSI,
    Weight_kg          = BMXWT,
    BMI                = BMXBMI) %>% 
  
  # 3. Filter out non-fasting participants (crucial for valid glucose lab values)
  filter(!is.na(Fasting_Weight)) 


# Verify my final data frame columns and clean structure
str(Clean_Diabetes_data) # The dataframe has 3996 observations and 18 variables
names(Clean_Diabetes_data)

#==============================================================================
# Step 4: The Mutate & Summary Pipeline
# =============================================================================

# 1. I will now isolate diagnosed diabetics, and categorize treatments from my cleaned diabetes data.
Efficacy_Study_Data <- Clean_Diabetes_data %>%
  # Focus only on individuals self-reporting a diabetes diagnosis
  filter(Self_Diabetes == 1) %>%
  
  # Remove individuals missing HbA1c lab values so efficacy can be measured
  filter(!is.na(HbA1c_Percent)) %>%
  
  # The Mutate Section: Create the custom Treatment Strategy column
  mutate(Treatment_Strategy = case_when(
    Takes_Insulin == 1 ~ "Insulin Users",
    Takes_Diabetes_Pills == 1 & (Takes_Insulin == 2 | is.na(Takes_Insulin)) ~ "Oral Pills Only",
    Takes_Insulin == 2 & Takes_Diabetes_Pills == 2 ~ "Diet & Lifestyle Only",
    TRUE ~ "Other/Unknown")) %>%
  
  # Keep only my core clinical comparison groups
  filter(Treatment_Strategy != "Other/Unknown") %>%
  
  # Create a column tracking who is successfully keeping HbA1c under the clinical 7% target
  mutate(Clinical_Control = ifelse(HbA1c_Percent < 7.0, "Controlled (<7%)", "Uncontrolled (>=7%)"))

#Verify the structure of my new dataframe of 20 variables
str(Efficacy_Study_Data) # the dataframe has 460 observations
head(Efficacy_Study_Data)

# =============================================================================
# 2. Generate your descriptive summary statistics table
# =============================================================================

Efficacy_Summary_Table <- Efficacy_Study_Data %>%
  group_by(Treatment_Strategy) %>%
  summarise(
    Sample_Size      = n(),
    Mean_Age         = mean(Age, na.rm = TRUE),
    Mean_BMI         = mean(BMI, na.rm = TRUE),
    Mean_HbA1c       = mean(HbA1c_Percent, na.rm = TRUE),
    Percent_Success  = mean(Clinical_Control == "Controlled (<7%)") * 100
  )

# Print the numerical summary table 
print(Efficacy_Summary_Table)

#Verify my final Efficacy_Study_Data columns and structure.
head(Efficacy_Study_Data)
str(Efficacy_Study_Data)

#Step 2: The Visualization Pipeline
library(ggplot2)
library(tidyverse)

# =============================================================================
# --- STEP 5: PLOT DISTRIBUTIONS WITH GGPLOT2 ---
# (Piping data objects natively directly into plot functions)
# =============================================================================
par(mfrow=c(2,2))
# --- CHECK 1:Check for visual normality/symmetry for each individual treatment group
Efficacy_Study_Data %>%
  ggplot(aes(x = HbA1c_Percent, fill = Treatment_Strategy)) +
  geom_histogram(binwidth = 0.5, alpha = 0.6, color = "black", position = "identity") +
  facet_wrap(~Treatment_Strategy, scales = "free_y") +  # Splits into 3 side-by-side plots
  labs(
    title = "Assessing Normality: HbA1c Distribution by Treatment Group",
    x = "Glycohemoglobin / HbA1c (%)",
    y = "Frequency / Count"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none", # Legend hidden because x-axis is already labeled
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(size = 11))
dev.off()
# --- CHECK 2: Check whether the data is skwed using a density plot.
Efficacy_Study_Data %>%
  ggplot(aes(x = HbA1c_Percent, fill = Treatment_Strategy)) +
  geom_density(alpha = 0.6, color = "black") +
  facet_wrap(~Treatment_Strategy, scales = "free_y") +  # Splits into 3 side-by-side plots
  labs(
    title = "Assessing Normality: HbA1c Distribution by Treatment Group",
    x = "Glycohemoglobin / HbA1c (%)",
    y = "Density"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none", # Legend hidden because x-axis is already labeled
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(size = 11))

# --- CHECK 3: THE REPRODUCIBLE Q-Q PLOT ---
# Quantile-Quantile plot. If data is normal, points must lie straight on the diagonal line.
Efficacy_Study_Data %>%
  ggplot(aes(sample = HbA1c_Percent, color = Treatment_Strategy)) +
  geom_qq() +
  geom_qq_line(color = "darkgrey", linewidth = 1) +
  facet_wrap(~Treatment_Strategy) +
  labs(
    title = "Assessing Normality: Q-Q Plots by Treatment Profile",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none", # Legend hidden because x-axis is already labeled
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(size = 11))


# --- CHECK 4: PIPED SHAPIRO-WILK TEST ---
# Objective mathematical test for normality. 
# H0: The data is perfectly normally distributed.
Normality_Audit_Table <- Efficacy_Study_Data %>%
  group_by(Treatment_Strategy) %>%
  shapiro_test(HbA1c_Percent)  # Elegant, piped rstatix normality test

print("--- SHAPIRO-WILK NORMALITY TEST SUMMARY ---")
print(Normality_Audit_Table)


# --- CHECK 5: PIPED HOMOGENEITY OF VARIANCE (LEVENES TEST) ---
# Checks if the spread/variance is equal across your three groups. 
# H0: Group variances are completely equal (Homoscedasticity).
Variance_Audit_Table <- Efficacy_Study_Data %>%
  levene_test(HbA1c_Percent ~ Treatment_Strategy) # Elegant, piped rstatix variance test

print("--- LEVENE'S HOMOGENEITY OF VARIANCE SUMMARY ---")
print(Variance_Audit_Table)


# --- CHECK 6: Create the boxplot graph with ggplot2
ggplot(data = Efficacy_Study_Data, aes(x = Treatment_Strategy, y = HbA1c_Percent, fill = Treatment_Strategy)) +
  # Draw boxplot with slightly transparent fills
  geom_boxplot(alpha = 0.7, outlier.shape = 1, outlier.alpha = 0.4) +
  
  # Add the critical clinical threshold line at 7% HbA1c
  geom_hline(yintercept = 7.0, linetype = "dashed", color = "darkred", linewidth = 1) +
  
  # Label the threshold line directly on the plot space
  annotate("text", x = 0.7, y = 7.4, label = "Clinical Target (7.0%)", color = "darkred", fontface = "bold") +
  
  # Apply formatting, text labels, and clean layout styles
  labs(
    title = "Real-World Glycemic Control Across Diabetes Treatment Profiles",
    subtitle = "Data Source: CDC NHANES Dataset",
    x = "Assigned Treatment Strategy",
    y = "Glycohemoglobin / HbA1c (%)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none", # Legend hidden because x-axis is already labeled
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(size = 11)
  )

# =============================================================================
# ---Interpretation
# ==============================================================================#"By implementing a complete diagnostic pipeline, we explicitly evaluated the standard parametric assumptions required for a One-Way ANOVA. Because both the visual metrics (Histograms/Q-Q plots/ Density graph/ boxplot) and the objective mathematical frameworks (Shapiro-Wilk and Levene's tests) significantly violated the assumptions of normality (\(p < 0.05\)) and homogeneity of variance (\(p < 0.05\)), the parametric ANOVA was firmly rejected. This thoroughly justifies our choice of the non-parametric Kruskal-Wallis framework as the mathematically robust approach
# =============================================================================
# PIPED STATISTICAL TESTING PIPELINE 
# =============================================================================

# 2. Run the Piped Kruskal-Wallis Test (Global Test)
# This pipes your data straight into the model and prints a clean summary table
ESD_kw_results <- Efficacy_Study_Data %>% 
  kruskal_test(HbA1c_Percent ~ Treatment_Strategy)

#print("--- TIDY PIPED KRUSKAL-WALLIS RESULTS ---")
print(ESD_kw_results)


# 3. Run the Piped Dunn Test (Head-to-Head Pairwise Comparisons)
# This compares your three groups and applies Benjamini-Hochberg adjustment
ESD_dunn_results <- Efficacy_Study_Data %>% 
  dunn_test(HbA1c_Percent ~ Treatment_Strategy, p.adjust.method = "BH")

#print("--- TIDY PIPED PAIRWISE DUNN RESULTS ---")
print(ESD_dunn_results)

# =============================================================================
#Kruskal-Wallis test interpretation;
# ============================================================================
#There is a highly significant statistical difference in HbA1c percentages across my treatment groups.

#----step-by-step breakdown of my results.

#Kruskal-Wallis Test (Overall Group Comparison)
#•	What it means: This non-parametric test checks if at least one treatment group has a different distribution of HbA1c levels compared to the others.
#•	The Verdict: The result is highly significant.
#•	The Evidence: My p-value is 5.61e-20. Because this value is far below the standard threshold of 0.05, I reject the null hypothesis. The differences among the 460 participants across the three groups did not happen by chance.

# ============================================================================
#Dunn's Test (Pairwise Comparisons)
# ============================================================================
#Because the overall test was significant, I ran Dunn's test to see exactly which groups differ from each other. Every single head-to-head comparison is highly statistically significant (p.adj \(<0.05\), marked with ****).
#•	Diet vs. Insulin (p.adj = 3.53e-19): There is a massive, statistically significant difference in HbA1c levels between patients on Diet alone versus those on Insulin.
#•	Diet vs. Oral Medication (p.adj = 4.20e-7): There is a highly significant difference between patients on Diet alone versus those on Oral Medication.
#•	Insulin vs. Oral Medication (p.adj = 3.52e-10): There is a highly significant difference between patients on Insulin versus those on Oral Medication. The negative statistic (-6.34) indicates the direction of the rank shift between these two specific groups.

#----Summary Conclusion
#My data shows that all three treatment strategies result in significantly different HbA1c profiles. I cannot therefore assume that any two treatments perform the same.


# ==============================================================================
# PIPED DESCRIPTIVE AUDIT: MEDIANS AND INTERQUARTILE RANGES (IQR)
# ==============================================================================

# Calculating median and IQR for HbA1c across my three treatment cohorts
HbA1c_Descriptive_Table <- Efficacy_Study_Data %>%
  group_by(Treatment_Strategy) %>%
  summarise(
    Total_n     = n(),
    Median_HbA1c = median(HbA1c_Percent, na.rm = TRUE),
    IQR_HbA1c    = IQR(HbA1c_Percent, na.rm = TRUE) # Piped rstatix/dplyr IQR function
  )

print("--- COHORT DESCRIPTIVE SNAPSHOT (MEDIAN & IQR) ---")
print(HbA1c_Descriptive_Table)

# =============================================================================
#Descriptive Cohort ProfilesEvaluation of the median and interquartile ranges
# =============================================================================

#(IQR) across the three clinical management pathways demonstrated a distinct gradient in real-world glycemic control. Participants managing their condition via Diet & Lifestyle Only (n = 63) demonstrated the highest therapeutic stability, presenting with a median HbA1c of 6.1% (IQR = 1.05%). Conversely, individuals utilizing Oral Medications Only (n = 258) occupied a middle tier, tracking near the boundary of clinical control with a median HbA1c of 6.8% (IQR = 1.47%). The Insulin Users cohort (n = 139) exhibited both the poorest overall control and the highest metabolic volatility, presenting with an elevated median HbA1c of 7.8% and a widely distributed IQR of 2.20%. This pronounced increase in the interquartile spread among the insulin cohort mathematically mirrors the intensive real-world difficulty and behavioral complexity associated with manual hormone titration: balancing insulin injections with daily life is highly volatile, resulting in some patients achieving tight control while others remain extremely uncontrolled.

# =============================================================================
#Adiing the plotting bracket coordinates to my ggplot2
# =============================================================================
#-----STEP 1
# Taking my existing Dunn results and adding the calculation layer for brackets
ESD_dunn_results_with_coordinates <- ESD_dunn_results %>%
  add_y_position(fun = "max", step.increase = 0.08) # Space out brackets above the highest points

# verify my [ESD_dunn_results_with_coordinates]
ESD_dunn_results_with_coordinates


#-----STEP 2
# Generate the publication-ready plot with automated brackets
Efficacy_Study_Data %>%
  ggplot(aes(x = Treatment_Strategy, y = HbA1c_Percent, fill = Treatment_Strategy)) +
  
  # 1. Base Boxplot layer
  geom_boxplot(alpha = 0.7, outlier.shape = 1, outlier.alpha = 0.4) +
  
  # 2. Add the automated clinical significance brackets from the Dunn Test table
  stat_pvalue_manual(
    ESD_dunn_results_with_coordinates, 
    label = "p.adj.signif",           # Displays asterisks (****) instead of cold decimals
    tip.length = 0.02,                # Size of the little tick marks down at the edges of brackets
    hide.ns = TRUE                    # Safely hides brackets if a comparison isn't significant
  ) +
  
  # 3. Add the clinical target baseline indicator at 7.0%
  geom_hline(yintercept = 7.0, linetype = "dashed", color = "darkred", linewidth = 0.8) +
  annotate("text", x = 0.68, y = 7.4, label = "Clinical Target (7.0%)", color = "darkred", fontface = "bold", size = 3.5) +
  
  # 4. Professional presentation formatting and labels
  labs(
    title = "Real-World Glycemic Control Across Diabetes Treatment Profiles",
    subtitle = "Pairwise Comparison via Piped Dunn Test (Benjamini-Hochberg Adjusted)",
    x = "Assigned Treatment Strategy",
    y = "Glycohemoglobin / HbA1c (%)"
  ) +
  scale_fill_brewer(palette = "Pastel1") + # Elegant, soft academic color scheme
  theme_minimal() +
  theme(
    legend.position = "none", # Legend hidden because the X-axis is fully descriptive
    plot.title = element_text(face = "bold", size = 13),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(size = 10)
  )
# =============================================================================
#----Interpretation
# =============================================================================

#---1. The Brackets Prove Complete Statistical Separation.Every single horizontal bar at the top displays four asterisks (****). This visually reinforces your Dunn test findings (p.adj < 0.001), confirming that every treatment group has a unique and distinctly different blood sugar distribution. There is no guesswork; the differences between all three strategies are mathematically real.

#---2. The Clinical Target Baseline (7.0%) Tells the StoryYour red dashed line serves as the perfect visual anchor for the clinical interpretation:Diet & Lifestyle Only (Pink): The entire box (the middle 50% of your patients) sits safely below the 7.0% clinical danger zone.Oral Pills Only (Green): The horizontal median line rests almost perfectly on the 7.0% line. This visually underscores your descriptive data—roughly half of pill users succeed, and half fail.Insulin Users (Blue): The bottom edge of the blue box rests directly on the 7.0% red line, and the median sits significantly higher at 7.8%. This proves visually that 75% of the insulin-dependent population is uncontrolled in the real world.

#---3. Outlier Trails Highlight Right-SkewnessNotice the individual circles trailing upward past 12.5% and 14.0% HbA1c, particularly in the Insulin and Oral Pills groups. These dense trails pull the data distributions upward, creating severe right-skewness. This graph is visual proof to your mentor that your assumption audit was correct and a standard parametric ANOVA would have failed.

# =============================================================================
#---- Audit tables
# =============================================================================

# Run the Piped Normality Check
Normality_Audit_Table <- Efficacy_Study_Data %>%
  group_by(Treatment_Strategy) %>%
  shapiro_test(HbA1c_Percent)

print("--- SHAPIRO-WILK NORMALITY RESULTS ---")
print(Normality_Audit_Table)

# Run the Piped Variance Spread Check
Variance_Audit_Table <- Efficacy_Study_Data %>%
  levene_test(HbA1c_Percent ~ Treatment_Strategy)

print("--- LEVENE'S HOMOGENEITY OF VARIANCE RESULTS ---")
print(Variance_Audit_Table)

#---- Interpretation; Translating the Diagnostic Math 

#1.The Shapiro-Wilk Normality Test (Normality_Audit_Table)
#--The null hypothesis for a Shapiro-Wilk test assumes that my data is perfectly normal (a clean bell curve). If the p-value drops below 0.05, I must reject that assumption.

#Diet & Lifestyle Only: p = 2.07 × 10⁻⁹ (effectively 0)
#Insulin Users: p = 1.71 × 10⁻⁶ (effectively 0)
#Oral Pills Only: p = 1.01 × 10⁻¹³ (effectively 0)

#--The Verdict: Because every single group's p-value is close to zero, the assumption of normality is completely violated across all three cohorts. This matches what you saw on your boxplot: the extreme outliers and stretched boxes drag the data upward, creating heavy positive skewness.

#2. Levene's Homogeneity of Variance Test (Variance_Audit_Table)

#--The null hypothesis for Levene’s test assumes that the spread (variance) is identical across all three groups.

#--The Result: p = 0.00146

#--The Verdict: Because this p-value is well below 0.05, I must reject the assumption of equal variances. This proves there is significant heteroscedasticity (unequal spread), which perfectly mirrors what we found earlier: the insulin group's IQR is more than double the size of the diet group's IQR.


# =============================================================================
# FINAL EXPORT STEP: SAVE YOUR WORK TO CSV
# ==============================================================================

# 1. Saving my final cleaned analysis dataset

write.csv(Clean_Diabetes_data, 
          file = "C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/Merged Dataset.csv", 
          row.names = FALSE)


write.csv(Efficacy_Study_Data, 
          file = "C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/Cleaned_Diabetes_Efficacy_Data.csv", 
          row.names = FALSE)

# 2. Saving my pairwise Dunn test results table
write.csv(ESD_dunn_results, 
          file = "C:/Users/ADMIN/Desktop/R Self Taught  Data Analysis/NHANES/Dunn_Test_Results.csv", 
          row.names = FALSE)

#3. Saving my HbA1c_Descriptive_Table
write.csv(HbA1c_Descriptive_Table, "Treatment_Efficacy_Summary.csv", row.names = FALSE)

print("All files successfully saved to your project folder!")

