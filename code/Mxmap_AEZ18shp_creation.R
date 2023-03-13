# Noé J Nava
# Noe.Nava@usda.gov
# ERS - MTED - APM

# Note:
# Script creates Mexican Shapefile with the AEZ18 boundaries
# Now focusing on Version 11 (based on 2017 data).

rm(list = ls())

library(tidyverse)
library(raster)
library(rgdal)
library(rgeos)
library(sp)

# Shapefiles
## All of the AEZ around the globe
AEZ_map <- readOGR(dsn = 'assets/GTAPAEZ_v11',
                   layer = 'GTAPv11_aez')
AEZ_map <- AEZ_map[AEZ_map$REG == "mex",]

## GTAP regions (focus is in Mexico)
AEZ_map_reg <- readOGR(dsn = 'assets/GTAPAEZ_v10',
                       layer = 'GTAPv10_reg')
AEZ_map_reg <- AEZ_map_reg[AEZ_map_reg$GTAP == "MEX",]

## Mexico divided by municipalities
MXmap_muni <- readOGR(dsn = 'assets/muni',
                      layer = '00mun')

# Intersecting both shapefiles to have Mexico divided by AEZ
MXmap_AEZ18 <- raster::intersect(AEZ_map_reg, AEZ_map)

# Changing projection of municipalities plus intersecting 
MXmap_muni <- spTransform(MXmap_muni,
                          CRS(MXmap_AEZ18@proj4string@projargs))
MXmap_muni$muni_id <- paste0(MXmap_muni$CVE_ENT, MXmap_muni$CVE_MUN)
MXmap_sp <- raster::intersect(MXmap_AEZ18, MXmap_muni)

# Some final data wrangling
MXmap_sp@data <- MXmap_sp@data %>%
  dplyr::select(AEZ, CVE_ENT, NOMGEO, muni_id) %>%
  rename(AEZ_id = AEZ) %>%
  rename(ENT_id = CVE_ENT) %>%
  rename(muni_name = NOMGEO)

# Creating output data frame
MXmap <- MXmap_muni@data
MXmap <- MXmap %>%
  dplyr::select(CVE_ENT, NOMGEO, muni_id) %>%
  #rename(AEZ_id = aez) %>%
  rename(ENT_id = CVE_ENT) %>%
  rename(muni_name = NOMGEO)
MXmap$id <- as.character(0:(length(MXmap$ENT_id)-1))

# Creating and identifying points
MXpnts_muni <- gCentroid(MXmap_muni, byid = TRUE)
#plot(USpnts_cnty)
MXpnts_muni <- sp::over(MXpnts_muni, MXmap_AEZ18)
MXpnts_muni$id <- as.character(0:(length(MXpnts_muni$AEZ)-1))
MXpnts_muni <- MXpnts_muni %>%
  dplyr::select(AEZ, id)

# Merging
MXmap <- left_join(MXmap, MXpnts_muni, by = "id")
MXmap <- MXmap %>% dplyr::select(!id) %>% rename(AEZ_id = AEZ)

# Some checks
## Number of AEZ within Mexico (should be 12 + 1 for NAs)
### Notice threee municipalities were not assigned a AEZ.
length(unique(MXmap$AEZ_id)) == length(unique(MXmap_AEZ18$AEZ)) + 1
## Check if same ids
all(c(unique(MXmap$AEZ_id), NA) %in% c(unique(MXmap_AEZ18$AEZ), NA))
all(c(unique(MXmap_AEZ18$AEZ), NA) %in% c(unique(MXmap$AEZ_id), NA))

## Number of municipalities in Mexico (should be 2471)
length(unique(MXmap$muni_id)) == length(unique(MXmap_muni$muni_id))
## Check if same ids
all(unique(MXmap$muni_id) %in% unique(MXmap_muni$muni_id))
all(unique(MXmap_muni$muni_id) %in% unique(MXmap$muni_id))

# Save shapefile
writeOGR(MXmap_sp, 
         dsn = 'output/MXmap_AEZ18_V11',
         layer = 'MXmap_AEZ18_V11',
         driver = 'ESRI Shapefile')
# Save Excel file with mapping of municipalities into AEZs in Mexico
write_csv(MXmap, file = 'output/AEZ18_to_MXmuni_id.csv')
saveRDS(MXmap, file = 'output/AEZ18_to_MXmuni_id.rds')
# end