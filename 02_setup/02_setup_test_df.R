
#######################################################
# Setup: Test Dataset
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
    # Mustafa
    setwd("C:/Users/..../Dropbox (Personal)/Locust")
}

#######################################################
# Library
#######################################################

# Cleaning Data 
library(data.table)
# Spatial Data 
library(sf)


#######################################################
# 01: Merge Sentiel and Locust data
#######################################################

# Bring in clean WDPA data

# Bring in clean Sentiel data

# Merge the two datasets

#######################################################
# 02: Clean Data
#######################################################

# Create measures of greeniness (for land)



#######################################################
# 03: Save Setup Data
#######################################################

# Save 

