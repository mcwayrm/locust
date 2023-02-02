
#######################################################
# Clean: FAO Locust Data
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
user <- Sys.info()["user"]
if (user == "ryanm") {
    # Ryan 
    setwd("C:/Users/ryanm/Dropbox (Personal)/Protected_Areas")
}
if (user == "") {
    # Matt
    setwd("C:/Users/..../Dropbox (Personal)/Protected_Areas")
}

#######################################################
# Library
#######################################################

# Cleaning Data 
library(data.table)
# Spatial Data 
library(sf)


#######################################################
# 01: Import FAO Locust Data
#######################################################

# Bring in raw locust data

#######################################################
# 02: Clean Data
#######################################################

# Only keep needed variables 

# Remove problematic observations

# Create generally useful information (dummies)



#######################################################
# 03: Save Cleaned Data
#######################################################

# Save 

