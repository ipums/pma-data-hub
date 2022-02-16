library(sysfonts)
library(showtext)

sysfonts::font_add(
  family = "cabrito", 
  regular = "../../fonts/cabritosansnormregular-webfont.ttf"
)
showtext::showtext_auto()
options(tibble.print_min = 20)

theme_pma <- theme_pma <- function(
  title, 
  subtitle = NULL
){
  components <- list(
    theme_minimal() %+replace% 
      theme(
        text = element_text(family = "cabrito", size = 13),
        plot.title = element_text(
          size = 22, color = "#00263A", hjust = 0, margin = margin(b = 5)
        ),
        plot.subtitle = element_text(
          size = 16, hjust = 0, margin = margin(b = 10)
        ),
        legend.position = "bottom",
        legend.title = element_blank(),
        strip.background = element_blank(),
        strip.text.y = element_text(size = 16, angle = 0),
        panel.spacing = unit(1, "lines"),
        panel.grid.minor = element_blank()
      ),
    scale_y_continuous(breaks = c(1,2,3)), 
    scale_x_continuous(breaks = seq(15, 50, by = 5)), 
    labs(
      title = title,
      subtitle = subtitle,
      x = NULL,
      y = NULL,
      fill = NULL
    )
  )
}