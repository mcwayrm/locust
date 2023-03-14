
#######################################################
# Generate: Sentiel 2 Data
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
    # Mustafa
    setwd("C:/Users/..../Dropbox (Personal)/Locust")
}

#######################################################
# Library
#######################################################

# Use Google Earth Engine
library(rgee)
    # Needs to be run once to establish on local R directory 
    # ee_install(py_env = "rgee")
    # Will need to install Google Cloud CLI as well 
    # https://cloud.google.com/sdk/docs/install
library(googleAuthR)
library(googleCloudStorageR)

# Spatial Objects 
library(sf)


#######################################################
# 01: Import Sentiel Data
#######################################################

# Determine bounding box 
sf_locust <- read_sf("./data/clean/locust/sf_locust.shp")

# Set up Google Earth Engine 
ee_Initialize(user = "mcway005@umn.edu",  drive = T, gcs = T)

# API Code 
gee_code <- readLines("./access_codes/")
ee_Authenticate(authorization_code = gee_code)



# Import

    # Only need 2020 and 2021 

    # Only pull tiles for Kenya

#######################################################
# 02: Clean Data
#######################################################

# Only keep needed variables 

# Remove problematic observations



#######################################################
# 03: Save Data
#######################################################

# Save 

