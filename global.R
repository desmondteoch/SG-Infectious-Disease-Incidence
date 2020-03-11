# Preparation of dataset for shiny app

library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(plotly)
library(xts)
library(zoo)

# load data and filter out dengue cases only
#setwd("C:/Users/desmo/OneDrive/HSA/Coursera/R/datasci_spec/mod9/wk4/SG_ID_Incidence")
dt <- read.csv("weekly-infectious-disease-bulletin-cases-cleaned.csv")
# dt.deng <- dt[dt$disease==c("Dengue Fever","Dengue Haemorrhagic Fever"),]

# change weeks to quarters
q1 <- c(1:13)
q2 <- c(14:26)
q3 <- c(27:39)
q4 <- c(40:53)
# dengue only
# dt.deng$epi_qtr <- ifelse(dt.deng$epi_week %in% q1, "1",
#                     ifelse(dt.deng$epi_week %in% q2, "2",
#                     ifelse(dt.deng$epi_week %in% q3, "3",
#                     ifelse(dt.deng$epi_week %in% q4, "4",
#                     NA)))) #all other values map to NA
# all diseases
dt$epi_qtr <- ifelse(dt$epi_week %in% q1, "1",
                ifelse(dt$epi_week %in% q2, "2",
                ifelse(dt$epi_week %in% q3, "3",
                ifelse(dt$epi_week %in% q4, "4",
                NA)))) #all other values map to NA


# merge year and quarter
# dengue only
# dt.deng$epi_time <- paste(dt.deng$epi_year, dt.deng$epi_qtr, sep = "-")
# dt.deng$epi_time <- as.yearqtr(dt.deng$epi_time, format = "%Y-%q")
# all diseases
dt$epi_time <- paste(dt$epi_year, dt$epi_qtr, sep = "-")
#dt$epi_time <- as.yearqtr(dt$epi_time, format = "%Y-%q")

# aggregate number of cases
# dengue only
# dt.deng.all <- dt.deng %>%
#     group_by(epi_time) %>%
#     mutate(no._of_cases, total = cumsum(no._of_cases)) %>%
#     top_n(1)
# 
# dt.deng.uniq <- unique(dt.deng.all[,6:7]) 

# all diseases
dt.all <- dt %>%
    group_by(disease, epi_time) %>%
    summarise(total = sum(no._of_cases))

dt.all <- dt.all[,c(2,1,3)]

# transform data into time series
# dengue only
# dt.deng.ts <- ts(dt.deng.uniq, frequency = 4)
# all diseases
# dt.ts <- ts(dt.all, frequency = 4)

# check time series for seasonality
# decompose(dt.deng.ts)
# decompose(dt.ts)

# save as csv
# write.csv(dt.deng.uniq, file = "data.csv", row.names = FALSE)
# write.csv(dt.all, file = "data.csv", row.names = FALSE)
saveRDS(dt.all, "./data/data.RDS")

data <- readRDS("data/data.RDS")  
data$epi_time <- as.yearqtr(data$epi_time, format = "%Y-%q")
