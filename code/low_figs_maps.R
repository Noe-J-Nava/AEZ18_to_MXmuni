# Noé J Nava
# Noe.Nava@usda.gov
# ERS - MTED - APM

# Note:
# Figure to describe the shapefile

rm(list = ls())

library(rgdal)
library(httpgd)
library(tidyverse)

# AEZ -----
MXmap <- readOGR(dsn = 'output/MXmap_AEZ18',
                 layer = 'MXmap_AEZ18')
MXmap@data$id <- as.character(0:(length(MXmap@data$AEZ_id) - 1))
MXmap_df <- MXmap@data

MXmap_tb <- broom::tidy(MXmap)
MXmap_tb <- left_join(MXmap_tb,
                      MXmap_df,
                      by = "id")

# Entidades ----
MXent <- readOGR(dsn = 'assets/enti',
                 layer = '00ent')
MXent <- spTransform(MXent,
                     CRS(MXmap@proj4string@projargs))
MXent@data$id <- as.character(0:(length(MXent@data$CVEGEO) - 1))
MXent_df <- MXent@data

MXent_tb <- broom::tidy(MXent)
MXent_tb <- left_join(MXent_tb,
                      MXent_df,
                      by = "id")
ggplot() +
  geom_polygon(data = MXent_tb,
               aes(x = long,
                   y = lat,
                   group = group),
               colour = "black", fill = NA)

# Municipalidades
MXmun <- readOGR(dsn = 'assets/muni',
                 layer = '00mun')
MXmun <- spTransform(MXmun,
                     CRS(MXmap@proj4string@projargs))
MXmun@data$id <- as.character(0:(length(MXmun@data$CVE_MUN) - 1))
MXmun_df <- MXmun@data

MXmun_tb <- broom::tidy(MXmun)
MXmun_tb <- left_join(MXmun_tb,
                      MXmun_df,
                      by = "id")
ggplot() +
  geom_polygon(data = MXmun_tb,
               aes(x = long,
                   y = lat,
                   group = group),
               colour = "black", fill = NA)

# Making the figure
hgd()
hgd_browse()

ggplot() + 
  # AEZ
  geom_polygon(data = MXmap_tb,
               aes(x = long,
                   y = lat,
                   group = group,
                   fill = AEZ_id)) +
  scale_fill_manual(values=c("#a6cee3", 
                             "#1f78b4", 
                             "#b2df8a",
                             "#33a02c",
                             "#fb9a99",
                             "#e31a1c",
                             "#fdbf6f",
                             "#ff7f00",
                             "#cab2d6", 
                             "#6a3d9a",
                             "#ffff99",
                             "#b15928")) +  
  # Municipalidades
  geom_polygon(data = MXmun_tb,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "black",
               size = .1) + 
  # Entidades
  geom_polygon(data = MXent_tb,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "black",
               size = 1) +
  theme(panel.background = element_rect(fill = NA, 
                                        color = NA)) +
  coord_equal() +
  theme(legend.direction = "vertical",
        legend.position = "left") +
  guides(fill = guide_legend(title = "AEZ",
                             title.position = "top"))
# End