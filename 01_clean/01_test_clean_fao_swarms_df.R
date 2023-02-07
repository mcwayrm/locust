
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
    setwd("C:/Users/ryanm/Dropbox (Personal)/Locust")
}
if (user == "") {
    # Matt
    setwd("C:/Users/..../Dropbox (Personal)/Locust")
}

#######################################################
# Library
#######################################################

# Import Data 
library(rio)
# Cleaning Data 
library(data.table)
# Spatial Data 
library(sf)
# Plot Maps
library(tmap)


#######################################################
# 01: Import FAO Locust Data
#######################################################

# Bring in raw adult locust data
sf_locust <- sf::read_sf("./data/raw/fao_locust_hub/fao_adults_sf/")

# Convert to data.table for cleaning

#######################################################
# 02: Clean Data
#######################################################

# Only keep needed variables 
sf_locust[, c("CAT","") := NULL]

# Rename variable names

# Remove problematic observations

# Create generally useful information (dummies)


#######################################################
# 03: Save Cleaned Data
#######################################################

# Restore as sf objection prior to export. (use default projection from raw data)

# Save 
st_write(sf_locust,"./data/clean/locust/sf_locust.gdb" )
