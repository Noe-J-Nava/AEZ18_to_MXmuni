## Description of the repository

The problem I solve in this repository is how to identify which Mexican municipalities belong to each Agro-ecological Zone [AEZ](https://www.ifpri.org/publication/agro-ecological-zones-africa). The importance of this problem relies on academic and research spheres for the most part.

You can also refer to our division of the United States [here](https://github.com/noejn2/AEZ18_to_UScntyFIPS).

If using this shapefile, please cite:

**TBD**

The following is a quick description of the codes:

In `assets` you should find three shapefiles for Mexican states (`assets/enti`), Mexican municipalities (`assets/muni`), and however the GTAP framework splits the globe into Agro-Ecological Zones (`assets/GTAPAEZ_v10`)

`code/Mxmap_AEZ18shp_creation.R` crates the final shapefile that can be found [here](output/MXmap_AEZ18/). The files of format [csv](output/AEZ18_to_MXmuni_id.csv) and [rds](output/AEZ18_to_MXmuni_id.rds) can be used as reference as they map the Mexican municipalities into the AEZ divisions in México

Below, I show how the split looks like, which is created using `code/low_figs_maps.R`

![municipalities_into_AEZ](output/low_fig/../low_figs/Mexican%20GTAP.png)