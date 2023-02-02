
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

# Import Sentiel Data 
library(sen2r)


#######################################################
# 01: Import Sentiel Data
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

