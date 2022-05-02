
library(sf)
# library(leaflet)
library(ggspatial)
library(tmap)
library(sysfonts)
library(showtext)

sysfonts::font_add(
  family = "cabrito", 
  regular = "../../fonts/cabritosansnormregular-webfont.ttf"
)
showtext::showtext_auto()
options(tibble.print_min = 20)
subnat <- read_sf(here::here("data_local/shapefiles/subnational"))

test <- subnat %>% 
  filter(!is.na(PMAID)) %>%
  filter(!CNTRY_NAME %in% c("Ethiopia", "Ghana", "Indonesia", "Niger")) %>%
  st_make_valid() %>% 
  mutate(
    POP = case_when(
      CNTRY_NAME == "India" & ADMIN_NAME != "Other India" ~ "Rajasthan",
      CNTRY_NAME == "India" & ADMIN_NAME == "Other India" ~ "Other India",
      CNTRY_NAME == "Congo, DRC" ~ ADMIN_NAME,
      CNTRY_NAME == "Nigeria" & 
        ADMIN_NAME %in% c("Lagos", "Kano") ~ ADMIN_NAME,
      CNTRY_NAME == "Nigeria" & 
        !ADMIN_NAME %in% c("Lagos", "Kano") ~ "Other Nigeria",
      TRUE ~ CNTRY_NAME
    )
  ) %>% 
  count(POP) %>% 
  st_make_valid() %>% 
  st_simplify(dTolerance = 1000) %>% 
  filter(!str_detect(POP, "Other"))


test %>% 
  tm_shape() +
  tm_borders() +
  tm_facets(by = "POP", nrow = 2) + 
  tm_text("POP", size = 2, ymod = 15) + 
  tm_scale_bar(width = 1, text.size = 1) + 
  tm_layout(
    main.title.position = c("center", "top"),
    frame = FALSE,
    panel.label.bg.color = "white",
    panel.label.size = 0,
    between.margin = 5,
    inner.margins = 0.05,
    outer.margins = .05,
    main.title = "New IPUMS PMA Data: February 2022",
    fontfamily = "cabrito"
  )
