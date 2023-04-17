library(raster)
library(sf)
library(rgdal)
# plumber.R
amba <- read_sf("C:/Users/HP/OneDrive/VizApp/app/data/amba.geojson")



#* Echo back the input
#* @param p2r path to raster
#* @get /p2r
function(p2r="") {
  nom = strsplit(p2r,'.tif')[[1]]
  
  bp = "C:/Users/HP/OneDrive/VizApp/app/output_pred/"
  p2r = paste0(bp,p2r)

  r1 = raster(p2r)
  
  r1[r1 < 10] = NA
  r1[r1 >= 10] = 1
  ar <- aggregate(r1, fact=7)
  poligonized = rasterToPolygons(ar, dissolve = T)
  meuse_sf <- st_as_sf(poligonized)
  
  barrio = amba[amba$nombre_barrio==nom,]

  meuse_sf = st_intersection(meuse_sf,barrio) 
  
  pg = paste0(strsplit(p2r,'.tif')[[1]],'.geojson')
  st_write(meuse_sf,pg)
  list(msg = pg)
}