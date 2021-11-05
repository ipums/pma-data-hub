library(tidyverse)
sysfonts::font_add(
  family = "cabrito", 
  regular = "../../fonts/cabritosansnormregular-webfont.ttf"
)
showtext::showtext_auto()

theme_pma <- function(
  title = NULL, 
  subtitle = NULL,
  caption = NULL, 
  show_eas = FALSE
){
  components <- list(
    theme_minimal() %+replace% 
      theme(
        text = element_text(family = "cabrito", size = 12), 
        plot.title = element_text(
          hjust = 0,
          size = 24, 
          color = "#00263A", # IPUMS navy
          margin = margin(b = 5)
        ), 
        plot.subtitle = element_text(
          size = 20, 
          hjust = 0,
          margin = margin(b = 10)
        )
      ),
    labs(
      title = title, 
      subtitle = subtitle,
      caption = caption,
      size = NULL,
      x = NULL,
      y = NULL
    ),
    annotation_scale(aes(style = "ticks", location = "br")),
    guides(size = guide_legend(override.aes = list(alpha = 1))),
    if(show_eas){c(
      geom_point(
        mapping = aes(size = URBAN + 1, x = 0, y = 14),
        data = gps_buf,
        alpha = 0, 
        shape = 21, 
        fill = "white"
      ),
      scale_size(
        breaks = c(1, 2), 
        range = c(.75, 3), 
        labels = c("Urban EA (2 km buffer)", "Rural EA (5 km buffer)")
      )
    )}
  )
}
