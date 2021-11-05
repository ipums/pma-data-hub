library(tidyverse)
library(terra)

# Get a raster for every day June-Oct in 1981-2017
years <- map(1981:2017, ~{
  yr <- .x
  unlist(map(6:9, ~{
      list.files(
        "../../data_local/chirps/nutrition/bf",
        full.names = TRUE,
        pattern = paste0(yr, "0", .x, ".*tif")
      ) 
    })) 
})
years <- set_names(years, 1981:2017) %>% map(~{rast(.x)})

# Calculate yearly summary stats as needed below
tictoc::tic()
rainy_30 <- list(
  chirps_sums = map(years, ~{sum(.x)}) %>% rast(),
  chirps_means = map(years, ~{mean(.x)}) %>% rast()
  # rain_meds = map(years, ~{median(.x)}) %>% rast(),
  # rain_min = map(years, ~{min(.x)}) %>% rast(),
  # rain_max = map(years, ~{max(.x)}) %>% rast()
)
tictoc::toc()

# Write yearly summary stats to `data` folder 
imap(rainy_30, ~{
  writeRaster(.x, paste0("data/", .y, ".tif"), overwrite = TRUE)
})


