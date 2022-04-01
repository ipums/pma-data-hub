# define consort function 
consort <- function(dat){
  dat <- dat %>%
    ungroup() %>%
    arrange(pop, step, keep) %>%
    mutate(
      across(c(pop, label), ~as_factor(.x)),
      label = fct_rev(label),
      x = as.double(pop) %>% ifelse(keep, ., . + 0.19),
      y = as.double(label),
      x_line1 = ifelse(keep, x, x - 0.19), # start horiz line at origin
      x_line2 = ifelse(keep, x, x - 0.05),  # end horiz line 0.05 before label
      y_line1 = ifelse(keep, y - 0.3, y),
      y_line2 = ifelse(keep, y - 1.7, y),
      across(
        starts_with("x"),
        ~case_when(
          step <= 6 & (is.na(samedw) | !keep) ~ .x, # leave as-is
          step == 9 ~ .x,
          keep & samedw ~ .x + 0.19,                 # right-side dwelling
          keep & !samedw ~ .x - 0.19,                # left-side dwelling
          !keep ~ .x + .19,                          # dwelling discard 
        )
      ),
      across(
        starts_with("x"), # flip dwelling discard 
        ~case_when(!keep & !samedw ~ .x - 2*(.x - floor(.x)), T ~.x)
      ),
      x_line2 = case_when(
        step == 8 & keep & samedw ~ x_line2 - 0.13,  # back to origin  at step 8
        step == 8 & keep & !samedw ~ x_line2 + 0.13, 
        TRUE ~ x_line2
      ),
      across(
        matches("line"), 
        ~ifelse(keep & step == max(step), NA, .x) %>%   # no lines at final step
          as.double()
      ),
      y = case_when(step == 9 ~ y - 1, TRUE ~ as.double(y)),
      y_line1 = ifelse(step == 6 & keep, y_line1 - 0.5, y_line1),
      hjust = case_when(
        keep ~ "center",
        !keep & !samedw ~ "right",
        TRUE ~ "left"
      )
    )
  
  dat %>% 
    ggplot(aes(x = x, y = y)) + 
    geom_text(
      aes(label = n, hjust = hjust),
      size = 3,
      family = "cabrito"
    ) + 
    geom_segment(
      arrow = arrow(length = unit(0.008, "npc")),
      aes(x = x_line1, xend = x_line2, y = y_line1, yend = y_line2),
      size = .3
    )  +
    scale_x_continuous(
      position = "top", 
      breaks = 1:6, 
      labels = levels(dat$pop)
    ) +
    scale_y_continuous(
      breaks = if(max(dat$step) == 9){
        seq(0, 2*max(dat$step)-1, by = 2)
      } else if(max(dat$step) == 1){
        1
      } else {
        seq(0, 2*max(dat$step)-1, by = 2) + 1
      },
      labels = dat %>% filter(keep) %>%
        count(label) %>% pull(label) %>% str_wrap(20),
      sec.axis = sec_axis(
        trans = ~.,
        breaks = if(max(dat$step) == 9){
          seq(3, 2*max(dat$step)-2, by = 2)
        } else if(max(dat$step) == 1){
          NULL
        } else {
          seq(2, 2*max(dat$step)-1, by = 2)
        },
        labels = if(max(dat$step) > 1){
          dat %>% filter(!keep) %>% count(label) %>% 
            pull(label) %>% str_wrap(20)
        } else {
          NULL
        }
      ),
      expand = if(max(dat$step) > 4){
        expansion(mult = 0.05)
      } else {
        expansion(mult = 0.3)
      }
    ) +
    theme_minimal() + 
    theme(
      text = element_text(family = "cabrito"),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      axis.text.x = element_text(size = 12),
      panel.grid = element_blank(),
      panel.border = element_blank(),
      plot.margin = margin(20, 100, 20, 100)
    )
}