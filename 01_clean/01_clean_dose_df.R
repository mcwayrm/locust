#######################################################
# Clean: DOSE Dataset
#######################################################

#######################################################
# Preamble
#######################################################

# Clear Variables
remove(list = ls())
# Capture Today's Date
today <- Sys.Date()
today <- format(today, format = "%y%m%d")
# Capture User's name 
user <- Sys.info()[["user"]]

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
# Summary Stats
library(vtable)


#######################################################
# Section: Check for Errors
#######################################################

# TODO: Consider only doing this for one country to start. Drop all other countries in locust and GDP data.
    # Egypt

# Dose dataset
df_dose <- rio::import("./data/raw/dose/DOSE_V2.csv")
    # TODO: Temp only keep Egypt
    df_dose <- df_dose[df_dose$country %in% c("Egypt"),]

# Variable description
vtable(df_dose)

# Summary Stats
sumtable(df_dose)
    
sf_gadm <- sf::st_read("./data/raw/borders/gadm_global_borders.gpkg")
    # TODO: Need to download for subnational level
    
    # TODO: Temp only keep Egypt 
    sf_gadm <- sf_gadm[sf_gadm$NAME_0 == "Egypt",]
    # Keep only necessary variables 
    sf_gadm <- sf_gadm[, c("UID", "GID_0", "NAME_0", "GID_1", "NAME_1", "geom")]


#######################################################
# Section: Merge Locust and spatial data
#######################################################

# Locust Data 
sf_locust <- sf::st_read("./data/raw/fao_locust_hub/fao_swarms_sf")
    # TODO: Temp only keep Egypt 
    sf_locust <- sf_locust[sf_locust$COUNTRYID == "EG",] 
    sf_locust <- sf_locust[!is.na(sf_locust$COUNTRYID),]
    # Create Year Variable
    sf_locust["STARTDATE"] <- as.Date(sf_locust$STARTDATE)
    sf_locust["year"] <-  data.table::year(sf_locust$STARTDATE)

    # Keep Bare minimum Info
    sf_locust <- sf_locust[, c("geometry", "OBJECTID", "COUNTRYID", "LOCNAME", "LOCUSTID", "year")]

    # NOTE: Quick check to see how many of the locust appear more than once in swarm dataset (e.g., can we track them over time.) This could be useful as a validation for the HYSPLIT model trajectories.
    nrow(sf_locust[duplicated(sf_locust$LOCUSTID), ])
    # Proportion
    nrow(sf_locust[duplicated(sf_locust$LOCUSTID), ]) / dim(sf_locust)[1]
        # NOTE: Only 4%... So FAO is not very sure about tracking locust swarms. 

# Create cross-section of DOSE shapefiles with locust sightings
sf_gadm_locust <- sf::st_intersection(sf_locust, sf_gadm)
    # TODO: Note that I can drop countries I know will not intersect
    # CHECK Passed: Check coordinate systems match before intersection.
    st_crs(sf_locust) # WGS 84
    st_crs(sf_gadm) # WGS 84
    # NOTE: Many of the locust obs are dropped because they are actually in Sudan...


df_gdam_locust <- setDT(sf_gadm_locust)
    
# Need to collapse locust to a count for each region and year 
df_gdam_locust[, locust := 1]
df_gdam_locust <- df_gdam_locust[, .(locust = sum(locust)) ,by = c("GID_1", "year")]


# Then can merge locust indicator with dose area by place and year. 
df_dose_locust <- merge(df_dose, df_gdam_locust, by = c("GID_1", "year"), all.x = TRUE)
    

# Save this merged sub-national dataset 
rio::export(x = df_dose_locust, 
            file = "./data/setup/df_merge_gdp.csv", 
            type = "csv")


# Indicator for locust exposure 
df_dose_locust <- setDT(df_dose_locust)
df_dose_locust[, locust := ifelse(is.na(df_dose_locust$locust), 0, df_dose_locust$locust)]

# Basic summary statistics
sumtable(df_dose_locust)

# Simple trendline of avg. gdp and avg. agr. gdp by time and aggregate locust sightings
    # Collapse data to year. 
    # Avg. GDP
    # Sum locust sighting
    # Plot

# Run OLS
reg_gdp_ols <- lm(grp_pc_lcu ~ locust, data = df_dose_locust)
reg_gdp_agr_ols <- lm(ag_grp_pc_lcu ~ locust, data = df_dose_locust)

# Fixed Effects 
library(fixest)
reg_gdp_fe <- feols(fml = grp_pc_lcu ~ locust,
                    data = df_dose_locust,
                    panel.id = c("GID_1", "year"), 
                    fixef = c("country", "year"))
reg_gdp_agr_fe <- feols(fml = ag_grp_pc_lcu ~ locust,
                        data = df_dose_locust,
                        panel.id = c("GID_1", "year"), 
                        fixef = c("country", "year"))

# New way to handle fixest models that is flexible 
library(modelsummary)
# Report Results
models <- list(
    "GDPpc - OLS" = reg_gdp_ols,
    "Agr. GDPpc - OLS" = reg_gdp_agr_ols,
    "GDPpc - FE" = reg_gdp_fe, 
    "Agr. GDPpc - FE" = reg_gdp_agr_fe 
)
modelsummary(models, 
             stars = TRUE, 
             gof_map = c("nobs","adj.r.squared", "vcov.type"),
             coef_map = c('locust' = "Count Locust Sightings"))


# Plotting locust ontop of sub-national boundaries
library(tmap)
library(ggplot2)

p <- ggplot() +  
    geom_sf(data = sf_gadm_EG) + 
    geom_sf(data = sf_locust)
p
