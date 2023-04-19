library(raster)
library(sf)
library(rgdal)
# plumber.R
amba <- read_sf("C:/Users/HP/OneDrive/VizApp/git/vizapp/data/amba.geojson")

#* Echo back the input
#* @param p2r path to raster
#* @get /p2r
function(p2r="", anio = 2021) {
  nom = p2r
  
  bp = "C:/Users/HP/OneDrive/VizApp/apiPred/apiPred/output_pred/"
  p2r = paste0(bp,p2r,"_",anio,".tif")
  print(p2r)
  r1 = raster(p2r)
  
  r1[r1 < 10] = NA
  r1[r1 >= 10] = 1
  ar <- aggregate(r1, fact=7)
  poligonized = rasterToPolygons(ar, dissolve = T)
  meuse_sf <- st_as_sf(poligonized)
  barrio = amba[amba$renabap_id==nom,]

  meuse_sf = st_intersection(meuse_sf,barrio) 
  
  pg = paste0(strsplit(p2r,'.tif')[[1]],'.geojson')
  st_write(meuse_sf,pg, append = F)
  list(msg = pg)
}


