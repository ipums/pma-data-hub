sysfonts::font_add(
  family = "cabrito", 
  regular = "../../fonts/cabritosansnormregular-webfont.ttf"
)
showtext::showtext_auto()

hhfoodplot <- dat %>% 
  select(
    c(HHWORRIEDYR, HHUNHEALTHYYR, HHFEWKINDSYR, HHSKIPMEALYR, 
      HHATELESSYR, HHRANOUTYR, HHHUNGRYYR, HHWHOLEDAYYR)
  ) %>% 
  summarise(across(everything(), ~100*mean(.x))) %>% 
  pivot_longer(everything()) %>% 
  rowwise() %>% 
  mutate(label = case_when(
    name == "HHWORRIEDYR" ~ paste(
      sep = "\n", 
      "Were worried you would not have enough food to eat because of",
      "a lack of money or other resources?"
    ),
    
    name == "HHUNHEALTHYYR" ~ paste(
      sep = "\n", 
      "Were unable to eat healthy and nutritious food",
      "because of a lack of money or other resources?"
    ),
    
    name == "HHFEWKINDSYR" ~ paste(
      sep = "\n", 
      "Ate only a few kinds of foods because of a lack of money or",
      "other resources?"
    ),
    
    name == "HHSKIPMEALYR" ~ paste(
      sep = "\n", 
      "Had to skip a meal because there was not enough money or",
      "other resources to get food?"
    ),
    
    name == "HHATELESSYR" ~ paste(
      sep = "\n", 
      "Ate less than you thought you should because of a lack ",
      "of money or other resources?"
    ),
    
    name == "HHRANOUTYR" ~ paste(
      sep = "\n", 
      "Ran out of food because of a lack of money or other resources?"
    ),
    
    name == "HHHUNGRYYR" ~ paste(
      sep = "\n", 
      "Were hungry but did not eat because there was not enough",
      "money or other resources for food?"
    ),
    
    name == "HHWHOLEDAYYR" ~ paste(
      sep = "\n", 
      "Went without eating for a whole day because of a lack of ",
      "money or other resources?"
    )
  )) %>% 
  ggplot(aes(y= name, x = value)) + 
  geom_bar(stat = "identity", fill = "#98579B", alpha = .7) + 
  facet_grid(
    rows = vars(label), 
    scales = "free",
    space = "free"
  ) + 
  theme_minimal() + 
  theme(
    text = element_text(family = "cabrito", size = 12),
    title = element_text(size = 20, color = "#00263A"),
    plot.subtitle = element_text(size = 16),
    axis.title.x = element_text(size = 12),
    legend.position = "bottom",
    strip.background = element_blank(),
    strip.text.y = element_text(size = 12, angle = 0),
    panel.spacing = unit(0, "lines")
  ) + 
  labs(
    title = "PMA Household Food Security Questions",
    subtitle = paste(
      "During the past 12 months, was there a time when you or others in", 
      "your household..."
    ),
    x = "Percent surveyed households with an infant aged 6-23 months",
    y = NULL,
    fill = NULL
  ) 