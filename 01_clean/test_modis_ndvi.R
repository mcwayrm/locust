##############################################################################
# Mustafa Zahid, May 30th, 2022
# This R script processes raw tiff MODIS NDVI files and merges the data 
# with the FAO swarms dataset
# Input(s): Raw tiff files from MODIS Terra w/NDVI layer
# Output(s): processed dataet at the grid-month level
##############################################################################
remove(list=ls())
sf::sf_use_s2(FALSE)

##############################################################################
############ PART I: Read in the raw data MODIS NDVI + FAO swarms ############
##############################################################################
  ## MODIS
  path <- "/Users/mustafazahid/Desktop/MODIS_2000"
  all_data = list.files(path=path,
                        pattern = "MOD_", 
                        full.names = TRUE,
                        recursive = TRUE,
                        include.dirs = FALSE)
  
  # read all the datasets inside the file
  tic()
  listofdfs <- mclapply(all_data, raster, mc.cores = 7)
  toc()    
  
  #stack the layers 
  stack_ndvi <- stack(listofdfs)
  
  ## FAO locusts
  swarms <- read_csv("/Users/mustafazahid/Desktop/locusts_project/Swarms.csv")

##############################################################################
###################### PART II: Process MODIS NDVI data ######################
##############################################################################  
  # read world polygon
  data("wrld_simpl")
  wrld_simpl <- st_as_sf(wrld_simpl)
  
  #We want to limit the polygon to certain geographies that are of interest to 
  # our purposes
  wrld_simpl$region <- countrycode::countrycode(wrld_simpl$ISO3,
                                                origin = "iso3c",
                                                destination = "un.regionsub.name")
  
  #limiting the polygon
  wrld_simpl_rgn <- subset(wrld_simpl,
                           region == "Sub-Saharan Africa" |
                             region == "Southern Asia" | 
                             region == "Northern Africa Western Asia" | 
                             region == "Western Asia" | 
                             region == "Northern Africa")
  
  # further limiting geographies
  wrld_simpl_rgn$region1 <- countrycode::countrycode(wrld_simpl_rgn$ISO3,
                                                     origin = "iso3c",
                                                     destination = "un.regionintermediate.name")
  
  # getting red of whatever is left
  wrld_simpl_rgn$region1[is.na(wrld_simpl_rgn$region1)] <- "non_afr"
  wrld_simpl_rgn <- subset(wrld_simpl_rgn, 
                           region1 != "Southern Africa") 
  wrld_simpl_rgn <- subset(wrld_simpl_rgn, (ISO3 != "MDG" & ISO3 != "MUS" &
                                            ISO3 !=  "MOZ" & ISO3 != "MWI" & 
                                            ISO3 != "ZWE" & ISO3 != "ZMB" &
                                            ISO3 != "AGO" & ISO3 != "SYC" &
                                            ISO3 != "MYT" & ISO3 != "REU" &
                                            ISO3 != "ATF" & ISO3 != "IOT" &
                                            ISO3 != "SHN"))
  
  # keep only what we need
  wrld_simpl_rgn <- wrld_simpl_rgn %>% dplyr::select(c("ISO3", "geometry"))
  
  #crop the rasters on the selected polygon
  listofcrops <- list()
  for ( i in 1:489){
    tic()
    stack_ndvi_tst <- crop(stack_ndvi[[i]], wrld_simpl_rgn)
    listofcrops[[i]] <- stack_ndvi_tst
    toc()
  }
  
  #stack the croipped layers 
  stack_ndvi_tst <- stack(listofcrops)
  
  # and write them into an .nc file
  writeRaster(stack_ndvi_tst, filename="~/Desktop/cropped_ndvi.nc")

##############################################################################
##################### PART III: Process FAO swarms data ######################
##############################################################################  
  swarms <- swarms %>% dplyr::select(c("X", "Y", "OBJECTID", "STARTDATE"))
  swarms$year <- substr(swarms$STARTDATE, 1, 4)
  
  # for the purpose of this excercise, just focusing on 2020
  swarms <- subset(swarms, year == "2020")
  
  swarms$month <- paste0(swarms$year, ".", 
                         substr(swarms$STARTDATE, 6, 7))
  swarms_sf <- st_as_sf(swarms, coords = c("X", "Y"))
  
  
##############################################################################
####### PART IV: Write out grid level monthly aggregated ndvi data ###########
##############################################################################  
  raster_sf <- st_as_sf(as.data.frame(as.matrix(rasterToPoints(stack_ndvi_tst[[1]]))), 
                        coords = c("x", "y"), crs = st_crs(stack_ndvi_tst[[1]]))
  ndvi_coords <- st_join(raster_sf, wrld_simpl_rgn)
  ndvi_coords <- ndvi_coords %>%  dplyr::select(c("ISO3", "geometry"))
  ndvi_coords <- st_as_sf(ndvi_coords)
  ndvi_coords[, c("x", "y")] <- st_coordinates(ndvi_coords)
  st_geometry(ndvi_coords) <- NULL
  
  # now let us create a grid-level dataframe that stores the ndvi values
  mother_list <- list()
  for (i in 1:489){
    tic()
    ndvi_df <- as.data.frame(as.matrix(rasterToPoints(stack_ndvi_tst[[i]])))
  
    ndvi_df$date <- paste0(substr(colnames(ndvi_df)[3], 13,22))
    
    colnames(ndvi_df)[3] <- "ndvi"
  
    ndvi_main <- left_join(ndvi_coords,
                           ndvi_df, 
                           by = c("x" ,"y"))
  
    ndvi_main <- subset(ndvi_main, !is.na(ISO3))
  
    mother_list[[i]] <- ndvi_main
  
    toc()
  }
  
  rm(listofdfs)
  rm(df1)
  
  # now let us bring all dfs together into one big one
  mother_df <- bind_rows(mother_list)
  mother_df$month <- substr(mother_df$date, 1, 7)
  mother_df$year <- as.numeric(substr(mother_df$date, 1, 4))
  unique(mother_df$year)
  
  # and then we loop through years and aggregate to month level 
  submother_list <- list()
  for (i in 2000:2020){
    tic()
    mother_df1 <- subset(mother_df, year == i)
    mother_df1 <- mother_df1 %>% dplyr::group_by(ISO3, x, y, month) %>% 
      dplyr::summarise(ndvi = mean(ndvi, na.rm = T),
                       .groups= "keep")
    submother_list[[i]] <- mother_df1
    toc()
  }
  
  # now write the processed data 
  for (i in 2000:2020) {
    tic()
    submother_df <- submother_list[[i]]
    write_rds(submother_df, paste("~/Desktop/modis_ndvi/modis_ndvi_monthly_", i, ".rds"))
    toc()
  }

  

##############################################################################
####### PART IV: Write out grid level monthly aggregated ndvi data ###########
############################################################################## 
  swarms_sf$val <- 1
  swarms_sf$month_num <- as.numeric(substr(swarms_sf$month, 6, 7))
  
  # rasterize swarms data by using MODIS data so that we can join back in
  listoffasts <- list()
  for (i in 1:12) {
    tic()
    swarms_sf1 <- subset(swarms_sf, month_num == i)
    testfasterize <- raster::rasterize(swarms_sf1, 
                                       stack_ndvi_tst[[1]],
                                       field = "val")
    listoffasts[[i]] <- testfasterize
    toc()
  }
  
  #stack them
  swarms_raster <- stack(listoffasts)
  
  # convert rasters into dataframes and join them with NDVI 
  listsfdfs <- list()
  for (i in 1:12) {
    tic()
    names(swarms_raster[[i]]) <- "swarm_inc"
    swarms_raster[[i]]$swarm_inc[is.na(swarms_raster[[i]]$swarm_inc)] <- 0
    plot(swarms_raster[[i]])
    sfdf <- as.data.frame(as.matrix(rasterToPoints(swarms_raster[[i]])))
    sfdf$month <- i
    listsfdfs[[i]] <- sfdf
    toc()
  }
  
  #bring them together
  sfdfmain <- bind_rows(listsfdfs)
  
  

# end of script
