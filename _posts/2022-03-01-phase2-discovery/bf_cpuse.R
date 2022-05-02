widef <- read_ipums_micro(
  ddi = "data/pma_00001.xml",
  data = "data/pma_00001.dat.gz"
)

# Burkina Faso
# n = 5491 (checked with flowchart)
dat <- widef %>% 
  filter(SAMPLE_1 == 85409) %>% 
  filter(RESULTFQ_1 %in% c(1,5)) %>%
  filter(AGEHQ_1 < 49) %>% 
  filter(SURVEYWILLING_1 == 1) %>%  # 6532 women aged and agreed
  filter(RESULTHQ_2 %in% 1) %>%  # completed HQ
  filter(RESULTFQ_2 %in% 1) # completed FQ

# drop du jure (usual member, slept away last night), n = 5212
dat <- dat %>% 
  filter(RESIDENT_1 != 21) %>% 
  filter(RESIDENT_2 != 21 & RESIDENT_2 != 31)

# Final Report Page 1: n=5207 
# drop NIU in CP, n = 5207
dat %>% 
  filter(CP_1 != 99, CP_2 != 99) %>% 
  mutate(
    TEST_1 = factor(case_when(
      PREGNANT_1 == 1 ~ "pregnant",
      CP_1 == 1 ~ "using fp",
      CP_1 == 0 ~ "not using fp"
    )),
    TEST_2 = factor(case_when(
      PREGNANT_2 == 1 ~ "pregnant",
      CP_2 == 1 ~ "using fp",
      CP_2 == 0 ~ "not using fp"
    )),
    TEST_3 = paste(TEST_1, TEST_2)
  ) %>%
  as_survey_design(
    weight = PANELWEIGHT
  ) %>%
  group_by(TEST_3) %>%
  summarize(survey_mean()) %>% 
  mutate(freq = coef * 5207) %>% 
  mutate(tot = sum(freq))
