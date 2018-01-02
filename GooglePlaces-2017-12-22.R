# Google Places - R Script
# Michelle Plunkett - December 22, 2017
# Note: This script may need to be run multiple times in order to maximize the number of businesses pulled per site. 
# This means you need to get an API key that allows for 250,000 API retrievals per day. 
# This requires you to put a credit card onto your account, which will be charged in case you go over this free limit.

# ABOUT THIS SCRIPT: 
# This is a data scraping script written by Michelle Plunkett in December 2017. 
# Michelle is a Graduate Student Worker at the Texas A&M Transportation Institute.
# She is also a Master of Public Affairs candidate (Class of 2018) at UT Austin's LBJ School of Public Affairs.
# Contact Information: mplunkett@utexas.edu

# Load required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(googleway, openxlsx, installr, httr)

# For the "openxlsx" page to work on Windows, you need to install Rtools and then set your PC's path to point to Rtools' "zip" executable (usually found in the location below). 
# To install Rtools, run: installr:install.Rtools()  -- this will take you through the download process. 
# Use "Sys.getenv('PATH')" to return what is currently in your PC's path.  
Sys.setenv("R_ZIPCMD" = "C:\\Rtools\\bin\\zip.exe")

# Set working directory (file location where you want to save the output files)
wd <- "C:\\Users\\m-plunkett\\Documents\\Projects\\Raised Median Maps\\"
setwd(wd)

# Add Google Places API key here
# Get an API key at this link: https://developers.google.com/places/web-service/get-api-key 
# NOTE: You may need to add credit card information in order to increase the free daily limit to 250,000 API retrievals, 
# depending on the number of locations and radii values. Otherwise, this script will fail if you exceed the basic 2,000 limit. 
key <- "[API KEY HERE]"

# Desired locations (coordinates) 
# Note: The google places API cannot retrieve all businesses within the specific location and radius. The maximum number of places retrieved at a location is 60, but they may not be unique. In order to fully capture the businesses in a certain area, multiple locations (coordinates) need to be specified and retrieved from the API before a final dataset is collected. Then, you can de-duplicate the dataset to reveal almost all of the unique businesses within a certain geographic area. 
# Process: Find the coordinates of 4 points relatively evenly spaced in the area of interest on maps.google.com. Then, record the points below.

# South Sites
  # Koenig Ln (1st site)
    ## Keyword
    keyword.1 <- "Koenig"
    ## 1st location (add numbers/floats)
    radius.1.1 <- 110
    lat.1.1 <- 30.321035
    lng.1.1 <- -97.716715
    ## 2nd location (add numbers/floats)
    radius.1.2 <- 110
    lat.1.2 <- 30.330085
    lng.1.2 <- -97.730025
    ## 3rd location (add numbers/floats)
    radius.1.3 <- 110
    lat.1.3 <- 30.325751
    lng.1.3 <- -97.725943
    ## 4th location (add numbers/floats)
    radius.1.4 <- 110
    lat.1.4 <- 30.322405 
    lng.1.4 <- -97.719812
    
  # FM 973 (2nd site)
    ## Keyword
    keyword.2 <- "973"
    ## 1st location (add numbers/floats)
    radius.2.1 <- 110
    lat.2.1 <- 30.216411
    lng.2.1 <- -97.637974
    ## 2nd location (add numbers/floats)
    radius.2.2 <- 110
    lat.2.2 <- 30.208978
    lng.2.2 <- -97.638129
    ## 3rd location (add numbers/floats)
    radius.2.3 <- 110
    lat.2.3 <- 30.200355
    lng.2.3 <- -97.640253
    ## 4th location (add numbers/floats)
    radius.2.4 <- 110
    lat.2.4 <- 30.194077
    lng.2.4 <- -97.646859
      
  # Aquarena Springs Dr (3rd site)
    ## Keyword
    keyword.3 <- "Aquarena"
    ## 1st location (add numbers/floats)
    radius.3.1 <- 110
    lat.3.1 <- 29.892824
    lng.3.1 <- -97.917336
    ## 2nd location (add numbers/floats)
    radius.3.2 <- 110
    lat.3.2 <- 29.893009
    lng.3.2 <- -97.915848
    ## 3rd location (add numbers/floats)
    radius.3.3 <- 110
    lat.3.3 <- 29.893114
    lng.3.3 <- -97.913417
    ## 4th location (add numbers/floats)
    radius.3.4 <- 110
    lat.3.4 <- 29.893243
    lng.3.4 <- -97.911320
      
  # TX-80 (4th site)
    ## Keyword
    keyword.4 <- "80"
    ## 1st location (add numbers/floats)
    radius.4.1 <- 110
    lat.4.1 <- 29.884534
    lng.4.1 <- -97.924023
    ## 2nd location (add numbers/floats)
    radius.4.2 <- 110
    lat.4.2 <- 29.883516
    lng.4.2 <- -97.923047
    ## 3rd location (add numbers/floats)
    radius.4.3 <- 110
    lat.4.3 <- 29.881972
    lng.4.3 <- -97.920848
    ## 4th location (add numbers/floats)
    radius.4.4 <- 110
    lat.4.4 <- 29.881867
    lng.4.4 <- -97.919088
      
# North Sites
  # US-79/Palm Valley Blvd (5th site)
    ## Keyword
    keyword.5 <- "Palm+Valley"
    ## 1st location (add numbers/floats)
    radius.5.1 <- 135
    lat.5.1 <- 30.516899
    lng.5.1 <- -97.688981
    ## 2nd location (add numbers/floats)
    radius.5.2 <- 135
    lat.5.2 <- 30.518144
    lng.5.2 <- -97.668757
    ## 3rd location (add numbers/floats)
    radius.5.3 <- 135
    lat.5.3 <- 30.517398
    lng.5.3 <- -97.661646
    ## 4th location (add numbers/floats)
    radius.5.4 <- 135
    lat.5.4 <- 30.518650
    lng.5.4 <- -97.651589
      
  # FM 620 (6th site)
    ## Keyword
    keyword.6 <- "620"
    ## 1st location (add numbers/floats)
    radius.6.1 <- 110
    lat.6.1 <- 30.487756
    lng.6.1 <- -97.730562
    ## 2nd location (add numbers/floats)
    radius.6.2 <- 110
    lat.6.2 <- 30.495980
    lng.6.2 <- -97.724076
    ## 3rd location (add numbers/floats)
    radius.6.3 <- 110
    lat.6.3 <- 30.502986
    lng.6.3 <- -97.7212067
    ## 4th location (add numbers/floats)
    radius.6.4 <- 110
    lat.6.4 <- 30.507420
    lng.6.4 <- -97.715717
      
  # TX-29/University Ave (7th site)
    ## Keyword
    keyword.7 <- "University"
    ## 1st location (add numbers/floats)
    radius.7.1 <- 110
    lat.7.1 <- 30.632823
    lng.7.1 <- -97.706826
    ## 2nd location (add numbers/floats)
    radius.7.2 <- 110
    lat.7.2 <- 30.632954
    lng.7.2 <- -97.700853
    ## 3rd location (add numbers/floats)
    radius.7.3 <- 110
    lat.7.3 <- 30.633035
    lng.7.3 <- -97.696280
    ## 4th location (add numbers/floats)
    radius.7.4 <- 110
    lat.7.4 <- 30.633074
    lng.7.4 <- -97.692130
      
  # FM1460/A.W. Grimes Blvd (8th site)
    ## Keyword
    keyword.8 <- "Grimes"
    ## 1st location (add numbers/floats)
    radius.8.1 <- 110
    lat.8.1 <- 30.572615
    lng.8.1 <- -97.650398
    ## 2nd location (add numbers/floats)
    radius.8.2 <- 110
    lat.8.2 <- 30.565504
    lng.8.2 <- -97.647833
    ## 3rd location (add numbers/floats)
    radius.8.3 <- 110
    lat.8.3 <- 30.554835
    lng.8.3 <- -97.646182
    ## 4th location (add numbers/floats)
    radius.8.4 <- 110
    lat.8.4 <- 30.543275
    lng.8.4 <- -97.650240
      
  # FM 1431/Whitestone - Cottonwood Creek to US 183A (9th site)
    ## Keyword
    keyword.9 <- "Whitestone"
    ## 1st location (add numbers/floats)
    radius.9.1 <- 110
    lat.9.1 <- 30.525265
    lng.9.1 <- -97.816190
    ## 2nd location (add numbers/floats)
    radius.9.2 <- 110
    lat.9.2 <- 30.526429
    lng.9.2 <- -97.812596
    ## 3rd location (add numbers/floats)
    radius.9.3 <- 110
    lat.9.3 <- 30.527473
    lng.9.3 <- -97.809006
    ## 4th location (add numbers/floats)
    radius.9.4 <- 110
    lat.9.4 <- 30.528299
    lng.9.4 <- -97.805724
    
  # FM 1431/Whitestone - US 183A to US 183 (10th site)
    ## Keyword
    keyword.10 <- "Whitestone"
    ## 1st location (add numbers/floats)
    radius.10.1 <- 100
    lat.10.1 <- 30.521143
    lng.10.1 <- -97.828512
    ## 2nd location (add numbers/floats)
    radius.10.2 <- 100
    lat.10.2 <- 30.523023 
    lng.10.2 <- -97.823972
    ## 3rd location (add numbers/floats)
    radius.10.3 <- 100
    lat.10.3 <- 30.523966
    lng.10.3 <- -97.820528
    ## 4th location (add numbers/floats)
    radius.10.4 <- 100
    lat.10.4 <- 30.524790
    lng.10.4 <- -97.817823
    ## 5th location (add numbers/floats)
    radius.10.5 <- 100
    lat.10.5 <- 30.522296
    lng.10.5 <- -97.825811
    
  # FM 1431/Whitestone - US 183 to Bagdad Rd (11th site)
    ## Keyword
    keyword.11 <- "Whitestone"
    ## 1st location (add numbers/floats)
    radius.11.1 <- 125
    lat.11.1 <- 30.517709
    lng.11.1 <- -97.840022
    ## 2nd location (add numbers/floats)
    radius.11.2 <- 125
    lat.11.2 <- 30.518824
    lng.11.2 <- -97.836735
    ## 3rd location (add numbers/floats)
    radius.11.3 <- 125
    lat.11.3 <- 30.519822
    lng.11.3 <- -97.833652
    ## 4th location (add numbers/floats)
    radius.11.4 <- 125
    lat.11.4 <- 30.521032
    lng.11.4 <- -97.829205
    
  # FM 685 (12th site)
    ## Keyword
    keyword.12 <- "685"
    ## 1st location (add numbers/floats)
    radius.12.1 <- 125
    lat.12.1 <- 30.436998
    lng.12.1 <- -97.613643
    ## 2nd location (add numbers/floats)
    radius.12.2 <- 125
    lat.12.2 <- 30.446706
    lng.12.2 <- -97.607384
    ## 3rd location (add numbers/floats)
    radius.12.3 <- 125
    lat.12.3 <- 30.457469
    lng.12.3 <- -97.601044
    ## 4th location (add numbers/floats)
    radius.12.4 <- 125
    lat.12.4 <- 30.4652876
    lng.12.4 <- -97.5976856
    
  # FM 685/Chris Kelley Blvd (13th Site)
    ## Keyword
    keyword.13 <- "685"
    ## 1st location (add numbers/floats)
    radius.13.1 <- 110
    lat.13.1 <- 30.520547
    lng.13.1 <- -97.570485
    ## 2nd location (add numbers/floats)
    radius.13.2 <- 110
    lat.13.2 <- 30.527390
    lng.13.2 <- -97.566362
    ## 3rd location (add numbers/floats)
    radius.13.3 <- 110
    lat.13.3 <- 30.530014
    lng.13.3 <- -97.564938
    ## 4th location (add numbers/floats)
    radius.13.4 <- 110
    lat.13.4 <- 30.532926
    lng.13.4 <- -97.564108

# Set Google Places API criteria
## Notes: See the googleway package documentation for information about the below criteria. 
rankby <- "distance"

# Get data for loop (1:13 represents all 13 sites)
sites <- 1:13

# Loop to get data from Google Places API
for (i in 10:length(sites)) {
  
  keyword <- get(paste0("keyword.",i))
  
  print(paste0("Site ",i,": Getting information for keyword: ",keyword))
  
  # Special case where Site 10 has 5 coordinates
  if (i==10) {
    coords <- 1:5 # 5 coordinates for site 10
  } else {
    coords <- 1:4 # 4 coordinates for all other sites
  }
  
  for (n in 1:length(coords)) {
    print(paste0("Site ",i,": Getting location # ",n))
    # String coordinates
    lat <- get(paste0("lat.",i,".",n))
    lng <- get(paste0("lng.",i,".",n))
    
    # String radius
    radius <- get(paste0("radius.",i,".",n))
    
    # Get the data from Google Places API
    # Note: API calls have to be broken up into 3 pages in order to retrieve all 60 results from an area. 
    ## 1st page
    df_places <- try(google_places(key=key, rankby=rankby, radius=radius, keyword=keyword, location = c(lat, lng)), silent=TRUE)
    Sys.sleep(1.75)
    ## 2nd page
    df_places_next <- try(google_places(page_token= df_places$next_page_token, key=key, rankby=rankby, radius=radius, keyword=keyword, location = c(lat, lng)), silent=TRUE)
    Sys.sleep(1.75)
    ## 3rd page
    df_places_next_next <- try(google_places(page_token= df_places_next$next_page_token, key=key, rankby=rankby, radius=radius, keyword=keyword, location = c(lat, lng)), silent=TRUE)
    Sys.sleep(1.75)
    
    print(paste0("Site ",i,": Creating new objects for location # ",n))
    assign(paste0("df_places",n), df_places)
    assign(paste0("df_places",n,"_next"), df_places_next)
    assign(paste0("df_places",n,"_next_next"), df_places_next_next)
  }
  
  print(paste0("Site ",i,": Creating new directories"))
  # Save retrieved API data to new folder for future use (there is a limit on # of free API calls per day)
  ## Create new directories
  subdir <- paste0("Site ",i," - ",keyword)
  dir.create(paste0(wd,subdir))
  dir.create(paste0(wd,subdir,"\\Location_1"))
  dir.create(paste0(wd,subdir,"\\Location_2"))
  dir.create(paste0(wd,subdir,"\\Location_3"))
  dir.create(paste0(wd,subdir,"\\Location_4"))
  if (i==10) {
    dir.create(paste0(wd,subdir,"\\Location_5"))
  }
  
  print(paste0("Site ",i,": Saving the location data"))
  ## Save 1st location data
  save(df_places1, file = paste0(wd,"\\",subdir,"\\Location_1\\1st_page.RData"))
  save(df_places1_next, file = paste0(wd,"\\",subdir,"\\Location_1\\2nd_page.RData"))
  save(df_places1_next_next, file = paste0(wd,"\\",subdir,"\\Location_1\\3rd_page.RData"))
  
  ## Save 2nd location data
  save(df_places2, file = paste0(wd,"\\",subdir,"\\Location_2\\1st_page.RData"))
  save(df_places2_next, file = paste0(wd,"\\",subdir,"\\Location_2\\2nd_page.RData"))
  save(df_places2_next_next, file = paste0(wd,"\\",subdir,"\\Location_2\\3rd_page.RData"))
  
  ## Save 3rd location data
  save(df_places3, file = paste0(wd,"\\",subdir,"\\Location_3\\1st_page.RData"))
  save(df_places3_next, file = paste0(wd,"\\",subdir,"\\Location_3\\2nd_page.RData"))
  save(df_places3_next_next, file = paste0(wd,"\\",subdir,"\\Location_3\\3rd_page.RData"))
  
  ## Save 4th location data
  save(df_places4, file = paste0(wd,"\\",subdir,"\\Location_4\\1st_page.RData"))
  save(df_places4_next, file = paste0(wd,"\\",subdir,"\\Location_4\\2nd_page.RData"))
  save(df_places4_next_next, file = paste0(wd,"\\",subdir,"\\Location_4\\3rd_page.RData"))
  
  ## Save 5th location data (if site 10)
  if (i==10) {
    save(df_places5, file = paste0(wd,"\\",subdir,"\\Location_5\\1st_page.RData"))
    save(df_places5_next, file = paste0(wd,"\\",subdir,"\\Location_5\\2nd_page.RData"))
    save(df_places5_next_next, file = paste0(wd,"\\",subdir,"\\Location_5\\3rd_page.RData"))
  }

  print(paste0("Site ",i,": Cleaning the places data"))
  # 1st page data - 1st location
  if (df_places1$status=="OK") {
  places <- NULL
  places$Name <- df_places1$results$name
  places <- as.data.frame(places, stringsAsFactors = F)
  places$Address <- df_places1$results$vicinity
  places$State <- "Texas"
  places$Latitude <- df_places1$results$geometry$location$lat
  places$Longitude <- df_places1$results$geometry$location$lng
  places_types <- df_places1$results$types
  places_types <- do.call(rbind,places_types)
  places$Main_Type <- places_types[,1]
  places$PlaceID <- df_places1$results$place_id
  }
  
  # 2nd page data - 1st location
  if (df_places1_next$status=="OK") {
  places_next <- NULL
  places_next$Name <- df_places1_next$results$name
  places_next <- as.data.frame(places_next, stringsAsFactors = F)
  places_next$Address <- df_places1_next$results$vicinity
  places_next$State <- "Texas"
  places_next$Latitude <- df_places1_next$results$geometry$location$lat
  places_next$Longitude <- df_places1_next$results$geometry$location$lng
  places_next_types <- df_places1_next$results$types
  places_next_types <- do.call(rbind,places_next_types)
  places_next$Main_Type <- places_next_types[,1]
  places_next$PlaceID <- df_places1_next$results$place_id
  }
  
  # 3rd page data - 1st location
  if (df_places1_next_next$status=="OK") {
  places_next_next <- NULL
  places_next_next$Name <- df_places1_next_next$results$name
  places_next_next <- as.data.frame(places_next_next, stringsAsFactors = F)
  places_next_next$Address <- df_places1_next_next$results$vicinity
  places_next_next$State <- "Texas"
  places_next_next$Latitude <- df_places1_next_next$results$geometry$location$lat
  places_next_next$Longitude <- df_places1_next_next$results$geometry$location$lng
  places_next_next_types <- df_places1_next_next$results$types
  places_next_next_types <- do.call(rbind,places_next_next_types)
  places_next_next$Main_Type <- places_next_next_types[,1]
  places_next_next$PlaceID <- df_places1_next_next$results$place_id
  }
  
  # 1st page data - 2nd location
  if (df_places2$status=="OK") {
  places2 <- NULL
  places2$Name <- df_places2$results$name
  places2 <- as.data.frame(places2, stringsAsFactors = F)
  places2$Address <- df_places2$results$vicinity
  places2$State <- "Texas"
  places2$Latitude <- df_places2$results$geometry$location$lat
  places2$Longitude <- df_places2$results$geometry$location$lng
  places2_types <- df_places2$results$types
  places2_types <- do.call(rbind,places2_types)
  places2$Main_Type <- places2_types[,1]
  places2$PlaceID <- df_places2$results$place_id
  }
  
  # 2nd page data - 2nd location
  if (df_places2_next$status=="OK") {
  places2_next <- NULL
  places2_next$Name <- df_places2_next$results$name
  places2_next <- as.data.frame(places2_next, stringsAsFactors = F)
  places2_next$Address <- df_places2_next$results$vicinity
  places2_next$State <- "Texas"
  places2_next$Latitude <- df_places2_next$results$geometry$location$lat
  places2_next$Longitude <- df_places2_next$results$geometry$location$lng
  places2_next_types <- df_places2_next$results$types
  places2_next_types <- do.call(rbind,places2_next_types)
  places2_next$Main_Type <- places2_next_types[,1]
  places2_next$PlaceID <- df_places2_next$results$place_id
  }
  
  # 3rd page data - 2nd location
  if (df_places2_next_next$status=="OK") {
  places2_next_next <- NULL
  places2_next_next$Name <- df_places2_next_next$results$name
  places2_next_next <- as.data.frame(places2_next_next, stringsAsFactors = F)
  places2_next_next$Address <- df_places2_next_next$results$vicinity
  places2_next_next$State <- "Texas"
  places2_next_next$Latitude <- df_places2_next_next$results$geometry$location$lat
  places2_next_next$Longitude <- df_places2_next_next$results$geometry$location$lng
  places2_next_next_types <- df_places2_next_next$results$types
  places2_next_next_types <- do.call(rbind,places2_next_next_types)
  places2_next_next$Main_Type <- places2_next_next_types[,1]
  places2_next_next$PlaceID <- df_places2_next_next$results$place_id
  }
  
  # 1st page data - 3rd location
  if (df_places3$status=="OK") {
  places3 <- NULL
  places3$Name <- df_places3$results$name
  places3 <- as.data.frame(places3, stringsAsFactors = F)
  places3$Address <- df_places3$results$vicinity
  places3$State <- "Texas"
  places3$Latitude <- df_places3$results$geometry$location$lat
  places3$Longitude <- df_places3$results$geometry$location$lng
  places3_types <- df_places3$results$types
  places3_types <- do.call(rbind,places3_types)
  places3$Main_Type <- places3_types[,1]
  places3$PlaceID <- df_places3$results$place_id
  }
  
  # 2nd page data - 3rd location
  if (df_places3_next$status=="OK") {
  places3_next <- NULL
  places3_next$Name <- df_places3_next$results$name
  places3_next <- as.data.frame(places3_next, stringsAsFactors = F)
  places3_next$Address <- df_places3_next$results$vicinity
  places3_next$State <- "Texas"
  places3_next$Latitude <- df_places3_next$results$geometry$location$lat
  places3_next$Longitude <- df_places3_next$results$geometry$location$lng
  places3_next_types <- df_places3_next$results$types
  places3_next_types <- do.call(rbind,places3_next_types)
  places3_next$Main_Type <- places3_next_types[,1]
  places3_next$PlaceID <- df_places3_next$results$place_id
  }
  
  # 3rd page data - 3rd location
  if (df_places3_next_next$status=="OK") {
  places3_next_next <- NULL
  places3_next_next$Name <- df_places3_next_next$results$name
  places3_next_next <- as.data.frame(places3_next_next, stringsAsFactors = F)
  places3_next_next$Address <- df_places3_next_next$results$vicinity
  places3_next_next$State <- "Texas"
  places3_next_next$Latitude <- df_places3_next_next$results$geometry$location$lat
  places3_next_next$Longitude <- df_places3_next_next$results$geometry$location$lng
  places3_next_next_types <- df_places3_next_next$results$types
  places3_next_next_types <- do.call(rbind,places3_next_next_types)
  places3_next_next$Main_Type <- places3_next_next_types[,1]
  places3_next_next$PlaceID <- df_places3_next_next$results$place_id
  }
  
  # 1st page data - 4th location
  if (df_places4$status=="OK") {
  places4 <- NULL
  places4$Name <- df_places4$results$name
  places4 <- as.data.frame(places4, stringsAsFactors = F)
  places4$Address <- df_places4$results$vicinity
  places4$State <- "Texas"
  places4$Latitude <- df_places4$results$geometry$location$lat
  places4$Longitude <- df_places4$results$geometry$location$lng
  places4_types <- df_places4$results$types
  places4_types <- do.call(rbind,places4_types)
  places4$Main_Type <- places4_types[,1]
  places4$PlaceID <- df_places4$results$place_id
  }
  
  # 2nd page data - 4th location
  if (df_places4_next$status=="OK") {
  places4_next <- NULL
  places4_next$Name <- df_places4_next$results$name
  places4_next <- as.data.frame(places4_next, stringsAsFactors = F)
  places4_next$Address <- df_places4_next$results$vicinity
  places4_next$State <- "Texas"
  places4_next$Latitude <- df_places4_next$results$geometry$location$lat
  places4_next$Longitude <- df_places4_next$results$geometry$location$lng
  places4_next_types <- df_places4_next$results$types
  places4_next_types <- do.call(rbind,places4_next_types)
  places4_next$Main_Type <- places4_next_types[,1]
  places4_next$PlaceID <- df_places4_next$results$place_id
  }
  
  # 3rd page data - 4th location
  if (df_places4_next_next$status=="OK") {
  places4_next_next <- NULL
  places4_next_next$Name <- df_places4_next_next$results$name
  places4_next_next <- as.data.frame(places4_next_next, stringsAsFactors = F)
  places4_next_next$Address <- df_places4_next_next$results$vicinity
  places4_next_next$State <- "Texas"
  places4_next_next$Latitude <- df_places4_next_next$results$geometry$location$lat
  places4_next_next$Longitude <- df_places4_next_next$results$geometry$location$lng
  places4_next_next_types <- df_places4_next_next$results$types
  places4_next_next_types <- do.call(rbind,places4_next_next_types)
  places4_next_next$Main_Type <- places4_next_next_types[,1]
  places4_next_next$PlaceID <- df_places4_next_next$results$place_id
  }
  
  if (i==10) {
    # 1st page data - 4th location
    if (df_places5$status=="OK") {
      places5 <- NULL
      places5$Name <- df_places5$results$name
      places5 <- as.data.frame(places5, stringsAsFactors = F)
      places5$Address <- df_places5$results$vicinity
      places5$State <- "Texas"
      places5$Latitude <- df_places5$results$geometry$location$lat
      places5$Longitude <- df_places5$results$geometry$location$lng
      places5_types <- df_places5$results$types
      places5_types <- do.call(rbind,places5_types)
      places5$Main_Type <- places5_types[,1]
      places5$PlaceID <- df_places5$results$place_id
    }
    
    # 2nd page data - 4th location
    if (df_places5_next$status=="OK") {
      places5_next <- NULL
      places5_next$Name <- df_places5_next$results$name
      places5_next <- as.data.frame(places5_next, stringsAsFactors = F)
      places5_next$Address <- df_places5_next$results$vicinity
      places5_next$State <- "Texas"
      places5_next$Latitude <- df_places5_next$results$geometry$location$lat
      places5_next$Longitude <- df_places5_next$results$geometry$location$lng
      places5_next_types <- df_places5_next$results$types
      places5_next_types <- do.call(rbind,places5_next_types)
      places5_next$Main_Type <- places5_next_types[,1]
      places5_next$PlaceID <- df_places5_next$results$place_id
    }
    
    # 3rd page data - 4th location
    if (df_places5_next_next$status=="OK") {
      places5_next_next <- NULL
      places5_next_next$Name <- df_places5_next_next$results$name
      places5_next_next <- as.data.frame(places5_next_next, stringsAsFactors = F)
      places5_next_next$Address <- df_places5_next_next$results$vicinity
      places5_next_next$State <- "Texas"
      places5_next_next$Latitude <- df_places5_next_next$results$geometry$location$lat
      places5_next_next$Longitude <- df_places5_next_next$results$geometry$location$lng
      places5_next_next_types <- df_places5_next_next$results$types
      places5_next_next_types <- do.call(rbind,places5_next_next_types)
      places5_next_next$Main_Type <- places5_next_next_types[,1]
      places5_next_next$PlaceID <- df_places5_next_next$results$place_id
    }
  }
  
  print(paste0("Site ",i,": Combining all of the data into one object"))
  # Combine all places into one object
  all_places <- rbind(if(exists("places")) places, if(exists("places_next")) places_next, if(exists("places_next_next")) places_next_next, if(exists("places2")) places2, if(exists("places2_next")) places2_next, if(exists("places2_next_next")) places2_next_next, if(exists("places3")) places3, if(exists("places3_next")) places3_next, if(exists("places3_next_next")) places3_next_next, if(exists("places4")) places4, if(exists("places4_next")) places4_next, if(exists("places4_next_next")) places4_next_next, if(exists("places5")) places5, if(exists("places5_next")) places5_next, if(exists("places5_next_next")) places5_next_next)
  all_places <- unique(all_places)
  
  # Remove created objects - 1st location
  rm(places, places_next, places_next_next, places_next_next_types, places_next_types, places_types)
  
  # Remove created objects - 2nd location
  rm(places2, places2_next, places2_next_next, places2_next_next_types, places2_next_types, places2_types)
  
  # Remove created objects - 3rd location
  rm(places3, places3_next, places3_next_next, places3_next_next_types, places3_next_types, places3_types)
  
  # Remove created objects - 4th location
  rm(places4, places4_next, places4_next_next, places4_next_next_types, places4_next_types, places4_types)
  
  # Remove created objects - 5th location
  if (i==10) {
    rm(places5, places5_next, places5_next_next, places5_next_next_types, places5_next_types, places5_types)
  }
  
  # Get new row numbers
  rownames(all_places) <- 1:nrow(all_places)
  
  # Remove all "df" objects from environment
  rm(list=ls(pattern="df"))
  
  # Keep only first instance if PlaceID is duplicated 
  all_places <- all_places[!duplicated(all_places$PlaceID),]
  
  print(paste0("Site ",i,": Enriching the data with google_place_details()"))
  # Enrich the data with google_place_details()
  place_details <- data.frame(Name=as.character(),
                              PlaceID=as.character(),
                              Rating=as.character(),
                              Full_Address=as.character(),
                              Phone=as.character(),
                              Website=as.character(),
                              Google_Maps_URL=as.character(),
                              Hours=as.character(),
                              Icon=as.character(),
                              All_Types=as.character())
  
  for (l in 1:nrow(all_places)) {
    details <- google_place_details(place_id = all_places$PlaceID[l],key=key)
    Name <- details$result$name
    Full_Address <- ifelse(is.null(details$result$formatted_address),"",details$result$formatted_address)
    PlaceID <- details$result$place_id
    Rating <- ifelse(is.null(details$result$rating),"",details$result$rating)
    Phone <- ifelse(is.null(details$result$formatted_phone_number),"",details$result$formatted_phone_number)
    Website <- ifelse(is.null(details$result$website),"",details$result$website)
    Hours <- ifelse(is.null(details$result$opening_hours$weekday_text),"",paste(details$result$opening_hours$weekday_text, collapse=", "))
    All_Types <- paste(details$result$types, collapse=", ")
    Icon <- details$result$icon
    Google_Maps_URL <- details$result$url
    place <- cbind(Name,PlaceID,Full_Address,Rating,Phone,Website,Google_Maps_URL,Hours,Icon,All_Types)
    place <- as.data.frame(place, stringsAsFactors = F)
    place_details <- rbind(place_details, place)
  }
  
  # Remove the values not needed
  rm(Hours, Name, All_Types, PlaceID, Rating, Phone, Website, place, details, Icon, Google_Maps_URL, Full_Address)
  
  # Add the data to the all_places object
  all_places$Full_Address <- place_details$Full_Address
  all_places$Rating <- place_details$Rating
  all_places$Phone <- place_details$Phone
  all_places$Website <- place_details$Website
  all_places$Google_Maps_URL <- place_details$Google_Maps_URL
  all_places$Hours <- place_details$Hours
  all_places$Icon <- place_details$Icon
  all_places$All_Types <- place_details$All_Types
  
  # Remove bus stations
  all_places <- all_places[!(all_places$Main_Type=="bus_station"),]
  
  print(paste0("Site ",i,": Exporting the data to Excel spreadsheet"))
  # Export gathered data to Excel spreadsheet & CSV
  date <- Sys.Date()
  date <- as.character(date,stringsAsFactors=F)
  file <- paste0(wd,subdir,"\\","Site ",i," - ",keyword,"_ALL-Businesses-",date)
  write.xlsx(all_places, paste0(file,".xlsx"), colNames = TRUE, overwrite = TRUE)
  write.csv(all_places, paste0(file,".csv"), row.names = F, col.names = T)
  
  print(paste0("Site ",i,": Saving the R objects"))
  # Save the R data objects
  save(all_places, file = paste0(wd,subdir,"\\","Site ",i," - ",keyword,"_ALL-Places-",date,".Rdata"))
  save(place_details, file = paste0(wd,subdir,"\\","Site ",i," - ",keyword,"_ALL-Place-Details-",date,".Rdata"))
  
  # Remove other values that are not needed
  rm(file)
  
  print(paste0("Site ",i,": Narrowing the data to addresses with keyword and saving"))
  # Narrow the data to just those with addresses containing the keyword
  places <- all_places[grepl(gsub("[[:punct:]]", " ", keyword), all_places$Address)==TRUE,]
  
  # Export gathered data to Excel spreadsheet & CSV
  file <- paste0(wd,subdir,"\\","Site ",i," - ",keyword,"-Businesses-",date)
  write.xlsx(places, paste0(file,".xlsx"), colNames = TRUE, overwrite = TRUE)
  write.csv(places, paste0(file,".csv"), row.names = F, col.names = T)
  
  # Assign a new name
  nam <- paste0("Site_",i)
  assign(nam,places)
  save(list=nam, file=paste0(nam,".Rdata"))
  
  Sys.sleep(5)
}
