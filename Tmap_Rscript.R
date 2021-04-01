# ghsl remote sensing}
library(raster)
library(rdgal)
library(sp)

#Four GHSL raster sets
ras17_8<-raster("raster/GHS_BUILT_17_8.tif")
ras17_7<-raster("raster/GHS_BUILT_17_7.tif")
ras18_8<-raster("raster/GHS_BUILT_18_8.tif")
ras18_7<-raster("raster/GHS_BUILT_18_7.tif")

#GHSL merged rasters
merged<-merge(ras17_8, ras18_8, ras17_7,ras18_7)
#raster::writeRaster(merged,"merged_GHSL_2014",options=c("TFW=YES"))

#Ghana administrative regions
library(sf)
gh_reg=st_read("Ama_GHSL_2014/ghana_boundaries/gha_adm1.shp")

#DHS data with urban_rural column to overlay over GHSL data
dhs=st_read("Ama_GHSL_2014/dhs_data/GHGE81FL.shp")

#rename levels
library(plyr)
dhs$URBAN_RURA=revalue(dhs$URBAN_RURA,c("R"="Rural","U"="Urban"))

library(dplyr) #rename column to URBAN_RURAL
dhs=dhs%>%
  rename(URBAN_RURAL=URBAN_RURA)


library(tmap)
tmap_mode("view")

tr2=tm_shape(merged)+tm_raster(palette = "Greys", breaks = c(0,0.1,20,40,100))
tr3=tm_shape(dhs)+tm_symbols(size = 0.1, col="URBAN_RURAL", alpha = 0.3)
tr4=tm_shape(gh_reg)+tm_polygons(alpha = 0)

#actually plotting map
tr2+tr3+tr4
