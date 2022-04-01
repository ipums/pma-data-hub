pmaplot <- function(dat, var, row_fac, col_fac){
  var <- rlang::enquo(var)
  row_fac <- rlang::enquo(row_fac)
  col_fac <- rlang::enquo(col_fac)
  
  d <- dat %>%
    mutate(
      var = !!var,
      row_fac = !!row_fac,
      col_fac = !!col_fac,
      var_fct = case_when(
        !is.na(var) ~ paste(zap_labels(var), "-", as_factor(var))
      )
    ) %>% 
    group_by(col_fac) %>%
    count(var_fct, row_fac) %>%
    mutate(pct = prop.table(n)*100) %>%
    ungroup()
  
  d %>% 
    ggplot(aes(x = pct, y = var_fct)) +
    geom_bar(stat = "identity", fill = "#00263A", alpha = 0.8, width = .45) +
    geom_text(
      aes(label = ifelse(pct < 0.01, "< 0.01", round(pct, 2))),
      nudge_x = 5,
      size = 2.5,
      hjust = "left"
    ) +
    facet_grid(
      rows = vars(row_fac),
      cols = vars(col_fac),
      scales = "free_y",
      space = "free"
    ) +
    scale_x_continuous(
      breaks = if(max(d$pct) < 75){c(0, 25, 50, 75)}else{c(0, 25, 50, 75, 100)},
      limits = if(max(d$pct) < 75){c(0, 100)}else{c(0, 130)},
    ) +
    theme_minimal() +
    theme(
      text = element_text(family = "cabrito", size = 10),
      title = element_text(size = 16, color = "#00263A"),,
      plot.subtitle = element_text(size = 12, angle = 0),
      strip.text.y = element_text(size = 12, angle = 0),
      axis.title = element_blank(),
      strip.background = element_blank(),
      panel.spacing.y = unit(2, "lines")
    ) 
}

pmalines <- function(...){paste(..., sep = "\n")}