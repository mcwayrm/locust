
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
library(leaflet)


#######################################################
# 01: Import FAO Locust Data
#######################################################

# Bring in raw adult locust data
sf_locust <- sf::read_sf("./data/raw/fao_locust_hub/fao_swarms_sf/")
    # Check CRS
    st_crs(sf_locust) # "EPSG",4326
    # Exploring Height Dimension 
    st_z_range(sf_locust) 
        # NOTE: Seems to be a reading in issue. 
    # Remove Z deminsion
    sf_locust <- st_zm(sf_locust, drop = T)
    # CHECK: Visualize information
    tmap_mode("view")
    tm_shape(sf_locust) + tm_basemap(leaflet::providers$OpenStreetMap) + tm_dots()
    
# TODO: Consider if any of the other FAO information is useful or needed. Or if we should only be focusing on the swarms (or adult population). 
# TODO: Perhaps hoppers (which are not swarms) could be used as an IV. And the ecological data needs to be processed as a potential IV measure as well. 

# List of countries that need to be covered from GDAM data (given there is reliable data)
sort(table(subset(sf_locust$COUNTRYID, sf_locust$REPRELIAB == 1)), decreasing = T)
    # NOTE: Only 277 observations were unreliable (0.6% of sample)

# Convert to data.table for cleaning
df_locust <- setDT(sf_locust)

#######################################################
# 02: Clean Data
#######################################################

# Only keep needed variables 
    # TODO: Drop all but bare minimum. Then add things back in as they become useful. 
df_locust <- df_locust[, c("OBJECTID", "STARTDATE", "FINISHDATE", "EXACTDATE", "LOCNAME", 
                           "COUNTRYID", "LOCUSTID", "REPORTID", "REPRELIAB", "LOCPRESENT", 
                           "AREAHA", "CONFIRMATN", "GADFLYFROM", "GADFLYTO", "geometry")]

# Rename variable names

# Remove problematic observations
    # Drop unreliable observations 
    df_locust <- df_locust[REPRELIAB == 1,]

# Create generally useful information (dummies)

    # Create variable for Year, Month, Date
    df_locust[, year := year(FINISHDATE)]
    df_locust[, month := month(FINISHDATE)]
    # df_locust[, day := day(FINISHDATE)] 
        # TODO: Figure out the day variable

# TODO: For now, only keep Kenya to work on 
df_locust <- df_locust[COUNTRYID == "KE"]

#######################################################
# 03: Save Cleaned Data
#######################################################

# Restore as sf objection prior to export. (use default projection from raw data)
sf_locust <- st_as_sf(df_locust)
st_crs(sf_locust) <- 4326
    # TODO: Need to clip the extent to only include the remaining points + 5 KM buffer
    # st_bbox(c(xmin = 10, xmax = 60, ymax = 10, ymin = -4.254))
sf_locust 
# Save Tabular Data 
write.csv(df_locust,
          file = "./data/clean/locust/df_locust.csv")

# Save Geometries
sf_locust <- sf_locust[, c("OBJECTID")]
st_write(sf_locust,"./data/clean/locust/sf_locust.shp")
