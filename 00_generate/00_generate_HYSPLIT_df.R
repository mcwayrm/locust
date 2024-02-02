
#######################################################
# Generate: HYSPLIT Trajectories
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
# Hysplit 
library(splitr)
# Working with Dates
library(lubridate)


#######################################################
# 01: Estimate Trajectories
#######################################################

# Temp folder for saved trajectories
setwd("C:/Users/ryanm/Desktop/trajectories/")

# Test 
trajectory <-
    hysplit_trajectory(
        lat = 50.108,
        lon = -122.942,
        height = 100,
        duration = 48,
        days = seq(
            lubridate::ymd("2012-02-22"),
            lubridate::ymd("2012-02-27"),
            by = "1 day"
        ),
        daily_hours = c(0, 6, 12, 18)
    )

# Removes NAs
trajectory_complete <- trajectory[complete.cases(trajectory),]

# Plot
trajectory_plot(trajectory_complete)
    # Issue with Mapping trajectories

