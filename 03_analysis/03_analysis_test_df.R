
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
# Summary stats
library(vtable)

#######################################################
# 01: Types of Locust and Effected Areas
#######################################################

df_locust <- rio::import("./data/clean/locust/df_locust.csv")

# Basic summary stats
sumtable(df_locust)

# Tabulation of Type of Locust 
    # TODO: Don't know which variable captures this. 

# Count by Country 
sort(table(df_locust$LOCNAME), decreasing = T)

# Count by Year 
table(df_locust$year)

# Count Country by Year
table(df_locust$LOCNAME, df_locust$year)

ggplot(data = df_locust) + 
    geom_histogram(aes(x = year))

ggplot(data = df_locust) + 
    geom_bin2d(aes(y = LOCPRESENT, x = year))
    # NOTE: Goes through cylces. 

# Count Country by Month
table(df_locust$month)
table(df_locust$LOCNAME, df_locust$month)


ggplot(data = df_locust) + 
    geom_freqpoly(aes(x = year, color = LOCNAME))

# Tabulate Size of Locust Swarms
ggplot(data = df_locust) + 
    geom_freqpoly(aes(x = LOCPRESENT))
    # NOTE: Lots of zeros >> this is a rare 
    # Some outbreaks are near plague proportions.

#######################################################
# 02: Visualize Locust over time
#######################################################

tmap_mode("view")

# sf_borders <- sf::read_sf("./data/raw/borders/gadm_global_borders.gpkg")
data("World")


# Static Map of locations 
tm_shape(World, bbox = sf_locust) + 
    tm_borders() +
    tm_shape(sf_locust) +
    tm_dots(alpha = 0.9, col = "maroon") 

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
