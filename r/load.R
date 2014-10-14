library(raster)

data.path <- '/Users/denis/Dropbox/data/chl_seawifs_daily'
filenames <- list.files(data.path, full.names=TRUE, pattern='*.h5')

for (f in filenames) {
  world.chl_r <- raster(f)
  projection <- "+proj=utm +zone=48 +datum=WGS84"
  extent(world.chl_r) <-  c(-180, 180, -90, 90)
  red.sea.chl_r <- crop(world.chl_r, c(31, 45, 12, 30))
  
  brick(red)
}

mybrick <- brick(red_sea_r, red_sea_r2)
