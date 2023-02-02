
#######################################################
# Generate: MODIS Data
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


# Data wrangling 
library(data.table)


#######################################################
# 01: Import MODIS Data
#######################################################

# Import

#######################################################
# 02: Clean Data
#######################################################

# Only keep needed variables 

# Remove problematic observations



#######################################################
# 03: Save Data
#######################################################

# Save 

