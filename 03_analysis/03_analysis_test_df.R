
#######################################################
# Analysis: Testing Playground
#######################################################

#######################################################
# Preamble
#######################################################

# Clear Variables
remove(list = ls())
# Capture Today's Date
today <- Sys.Date()
today <- format(today, format = "%y%m%d")

# Set Working Directory
if (user == "ryanm") {
    # Ryan 
    setwd("C:/Users/ryanm/Dropbox (Personal)/Locust")
}
if (user == "") {
    # Matt
    setwd("C:/Users/..../Dropbox (Personal)/Locust")
}

#######################################################
# Library
#######################################################

# Cleaning Data 
library(data.table)
# Spatial Data 
library(sf)
# Plotting Maps
library(tmap)
# Making Plots 
library(ggplot2)
# Difference in Differences Estimation
library(did)

#######################################################
# 01: Types of Locust and Effected Areas
#######################################################

# Tabulation of Type of Locust 

# Type by Country 

# Type by Year 

# Country by Year

# Tabulate Size of Locust Swarms

#######################################################
# 02: Visualize Locust over time
#######################################################

# Static Map of locations 

# Static Map of Paths 

# Animated Map of Paths


#######################################################
# 03: Locust Impact Vegetation
#######################################################

# Basic OLS 

# IV Estimate 

# Fixed Effects 

# New DiD Event study


#######################################################
# 04: Locust Impact Night Lights
#######################################################

# Basic OLS 

# IV Estimate 

# Fixed Effects 

# New DiD Event study

#######################################################
# 05: Locust Impact Mortality
#######################################################

# Basic OLS 

# IV Estimate 

# Fixed Effects 

# New DiD Event study

#######################################################
# 06: Locust Impact Migration
#######################################################

# Basic OLS 

# IV Estimate 

# Fixed Effects 

# New DiD Event study
