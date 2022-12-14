# Noé J Nava
# Noe.Nava@usda.gov
# ERS - MTED - APM

# Note:
# Script creates Mexican Shapefile with the AEZ18 boundaries

rm(list = ls())

library(tidyverse)
library(raster)
library(rgdal)

# Shapefiles
## All of the AEZ around the globe
AEZ_map <- readOGR(dsn = 'assets/GTAPAEZ_v10',
                   layer = 'GTAPv10_aez')
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
MXmap <- raster::intersect(MXmap_AEZ18, MXmap_muni)

# Some final data wrangling
MXmap@data <- MXmap@data %>%
  dplyr::select(aez, CVE_ENT, NOMGEO, muni_id) %>%
  rename(AEZ_id = aez) %>%
  rename(ENT_id = CVE_ENT) %>%
  rename(muni_name = NOMGEO)

# Some checks
## Number of AEZ within Mexico (should be 12)
length(unique(MXmap@data$AEZ_id)) == length(unique(MXmap_AEZ18$aez))
## Check if same ids
all(unique(MXmap@data$AEZ_id) %in% unique(MXmap_AEZ18$aez))
all(unique(MXmap_AEZ18$aez) %in% unique(MXmap@data$AEZ_id))

## Number of municipalities in Mexico (should be 2471)
length(unique(MXmap@data$muni_id)) == length(unique(MXmap_muni$muni_id))
## Check if same ids
all(unique(MXmap@data$muni_id)[-3] %in% unique(MXmap_muni$muni_id))
all(unique(MXmap_muni$muni_id) %in% unique(MXmap@data$muni_id))

# Save shapefile
writeOGR(MXmap, 
         dsn = 'output/MXmap_AEZ18',
         layer = 'MXmap_AEZ18',
         driver = 'ESRI Shapefile')
# Save Excel file with mapping of municipalities into AEZs in Mexico
MXmuni_id <- MXmap@data
write_csv(MXmuni_id, file = 'output/AEZ18_to_MXmuni_id.csv')
saveRDS(MXmuni_id, file = 'output/AEZ18_to_MXmuni_id.rds')
# end