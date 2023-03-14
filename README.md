## Description of the repository

**Note (GTAP version 11)**: GTAP version 11 arrived, Uris Baldos (Purdue's GTAP team) provided us with the newest AEZ shapefile that will be associated with GTAP version 11. The change in the AEZ creation comes with two changes, which is likely what drives the differences that are shown below. The AEZ v3 was updated into the AEZ v4 with (1) changes in methodology that can be observed in the table below (**bolded**), and (2) methodology by shifting the scope of the data from 1961-1990 in the AEZ v3 to 2000-2010 in the AEZ v4. See the references below for a thorough discussion

| GTAP Label | AEZ v3    | AEZ v4    |Label         |
|------------|---------|--------|-------------------|
| LGP1       | 0-59    |0-59    |hyper-arid and arid|
| LGP2       | 60-119  |60-119  |dry semi-arid      |
| LGP3       | 120-179 |120-179 |moist semi-arid    |
| LGP4       |**180-239** |**180-269**|**sub-humid**|
| LGP5       |**240-299** |**270-364**|**humid**    |
| LGP6       |**300+**    |**365**    |**per-humid**|


The problem I solve in this repository is how to identify which Mexican municipalities belong to each Agro-ecological Zone [AEZ](https://www.ifpri.org/publication/agro-ecological-zones-africa). The importance of this problem relies on academic and research spheres for the most part.

You can also refer to our division of the United States [here](https://github.com/noejn2/AEZ18_to_UScntyFIPS).

If using this shapefile, please cite:

**Nava, N J, J Beckman, and M Ivanic. 2023. "Estimating the Market Implications from Climate-induced Corn and Soybean Yield Changes for the U.S." *Forthcoming as Economics Research Report***

The following is a quick description of the codes:

In `assets` you should find three shapefiles for Mexican states (`assets/enti`), Mexican municipalities (`assets/muni`), and however the GTAP framework splits the globe into Agro-Ecological Zones (`assets/GTAPAEZ_v10`)

`code/Mxmap_AEZ18shp_creation.R` crates the final shapefile that can be found [here](output/MXmap_AEZ18/). The files of format [csv](output/AEZ18_to_MXmuni_id.csv) and [rds](output/AEZ18_to_MXmuni_id.rds) can be used as reference as they map the Mexican municipalities into the AEZ divisions in México

Below, I show how the split looks like, which is created using `code/low_figs_maps.R`

![municipalities_into_AEZ](output/low_fig/../low_figs/Mexican%20GTAP_v11.png)

**Changes in AEZs from moving from GTAP v10 to v11 (moving from AEZ v3 to AEZ v4)**

Here, left map is version 10 (AEZ v3) and right map is version 11 (AEZ v4). You can notice that in almost any part of the map, we can see changes in the AEZ that will indeed affect how municipalities are mapped into the AEZ.

![municipalities_into_AEZ_comparison](compare.png)


*References:*
G. Fischer, Global Agro-Ecological Zones v4 – Model documentation (FAO, 2021) https:/doi.org/10.4060/cb4744en (November 22, 2022).

FAO/IIASA, 2011-2012. Global Agro-ecological Zones (GAEZ v3.0)  FAO Rome, Italy and IIASA, Laxenburg, Austria
