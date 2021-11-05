library(ipumsPMA)
dat <- ipumsPMA::datgz_get("bf2017a_nh")

# Create MOMID 
moms <- dat %>% 
  filter(ELIGTYPE <= 20) %>%
  select(ELIGTYPE, PERSONID, FCQINSTID, CHILDID = BF2017A_NH_1176) %>% 
  mutate(
    CHILDID = str_remove(CHILDID, "/.*"),
    FCQINSTID = ifelse(is.na(FCQINSTID), CHILDID, FCQINSTID)
  ) %>%
  group_by(FCQINSTID) %>% 
  mutate(MOMID = cur_data() %>% filter(ELIGTYPE == 20) %>% pull(PERSONID)) %>% 
  ungroup()

dat <- moms %>% 
  select(PERSONID, MOMID) %>% 
  right_join(dat, by = "PERSONID")

# Match Mom's MUAC by MOMID 
# Match interview date by MOMID 
dat <- dat %>% 
  group_by(MOMID) %>% 
  mutate(MUACMOM = case_when(any(WNARMCIRCVAL < 90) ~ min(WNARMCIRCVAL))) %>% 
  ungroup()

# Calculate Child's age in months 
births <- dat %>% 
  arrange(MOMID) %>% 
  select(
    MOMID, 
    PERSONID,
    ELIGTYPE,
    FQENDSIF_YEAR = BF2017A_NH_1046,
    FQENDSIF_MONTH = BF2017A_NH_1047,
    FQENDSIF_DAY = BF2017A_NH_1048,
    BIRTH_YEAR = BF2017A_NH_1054,
    BIRTH_MONTH = BF2017A_NH_1055,
    BIRTH_DAY = BF2017A_NH_1056
  ) %>% 
  group_by(MOMID) %>% 
  mutate(
    FQENDSIF_YEAR = max(FQENDSIF_YEAR),
    FQENDSIF_MONTH = max(FQENDSIF_MONTH),
    FQENDSIF_DAY = max(FQENDSIF_DAY)
  ) %>% 
  ungroup() %>% 
  mutate(
    DOI = lubridate::make_date(
      year = FQENDSIF_YEAR, 
      month = FQENDSIF_MONTH, 
      day = FQENDSIF_DAY
    ), 
    BIRTHDATE = lubridate::make_date(
      year = BIRTH_YEAR,
      month = BIRTH_MONTH,
      day = BIRTH_DAY
    ),
    KIDAGEMO = lubridate::interval(start = BIRTHDATE, end = DOI) %/% months(1)
  ) %>% 
  select(PERSONID, KIDAGEMO)

dat <- births %>% 
  select(PERSONID, KIDAGEMO) %>% 
  right_join(dat, by = "PERSONID")

# Harmonize food security variables
foodsec <- dat %>% 
  select(
    PERSONID,
    fs_worried_12mo = BF2017A_NH_0132,
    fs_not_healthy_enough_12mo = BF2017A_NH_0133,
    fs_few_kinds_12mo = BF2017A_NH_0134,
    fs_skipped_meal_12mo = BF2017A_NH_0135,
    fs_ate_less_12mo = BF2017A_NH_0136,
    fs_ran_out_12mo = BF2017A_NH_0137,
    fs_hungry_12mo = BF2017A_NH_0138,
    fs_whole_day_12mo = BF2017A_NH_0139
  ) %>%
  mutate(
    hhworriedyr	= fs_worried_12mo,
    hhunhealthyyr	= fs_not_healthy_enough_12mo,
    hhfewkindsyr	= fs_few_kinds_12mo,
    hhskipmealyr = fs_skipped_meal_12mo,
    hhatelessyr	= fs_ate_less_12mo,
    hhranoutyr	= fs_ran_out_12mo,
    hhhungryyr	= fs_hungry_12mo,
    hhwholedayyr	= fs_whole_day_12mo
  ) %>% 
  rename_with(toupper, everything()) %>% 
  select(PERSONID, starts_with("HH"))

dat <- foodsec %>% 
  mutate(across(!PERSONID, ~case_when(
    .x == 0 ~ 0,
    .x == 1 ~ 1,
    .x == -6 ~ 96,
    .x == -88 ~ 97,
    .x == -99 ~ 98,
    .x == -9 ~ 99
  ))) %>% 
  right_join(dat %>% select(-HHSKIPMEALYR), by = "PERSONID")

# Count total number of kids in the HH
dat <- dat %>% 
  mutate(KID = AGEHQ < 5) %>% 
  group_by(HHID) %>% 
  summarise(HHKIDS_NUM = sum(KID, na.rm = TRUE)) %>% 
  right_join(dat, by = "HHID")

# Select variables and export 
out <- dat %>% 
  filter(ELIGTYPE <= 20) %>% 
  select(c(
    PERSONID, MOMID, KIDAGEMO, MUACMOM, HHKIDS_NUM,
    HHWORRIEDYR, HHUNHEALTHYYR, HHFEWKINDSYR, HHSKIPMEALYR, 
    HHATELESSYR, HHRANOUTYR, HHHUNGRYYR, HHWHOLEDAYYR
  )) 

write_rds(out, "data/svars.gz", compress = "gz")
