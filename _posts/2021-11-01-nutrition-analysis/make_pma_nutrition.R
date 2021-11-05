library(tidyverse)
ipums <- read_rds("data/ipums.gz")

# Join source variables (made with make_svars.R)
dat <- right_join(
  read_rds("data/svars.gz"),
  ipums %>% select(-HHSKIPMEALYR)
)

# Initial variable selection 
dat <- dat %>%
  filter(ELIGTYPE == 11 & KIDAGEMO >= 6) %>%
  select(c(
    PERSONID, HHID, EAID, CQWEIGHT,
    HHWORRIEDYR, HHUNHEALTHYYR, HHFEWKINDSYR, HHSKIPMEALYR, HHATELESSYR,
    HHRANOUTYR, HHHUNGRYYR, HHWHOLEDAYYR,
    KIDAGEMO,
    INFDIAR,
    HHKIDS_NUM,
    AGEMOM, MUACMOM, EDUCATTGENMOM,
    URBAN,
    INFMILKNUM, INFYOGNUM, INFFORMNUM, INFFOODNUM, INFBFNOW, INFFOODYEST,
    starts_with("INFYEST"),
    INFARMCIRCVAL
  )) 

# Recode nutrition variables 
dat <- dat %>% 
  mutate(
    URBAN = URBAN == 1,
    MOMAGE_4 = case_when(
      AGEMOM < 20 ~ "<20",
      AGEMOM < 25 ~ "20-24",
      AGEMOM < 35 ~ "25-34",
      AGEMOM >= 35 ~ "35+"
    ),
    MOMEDUC = case_when(
      EDUCATTGENMOM == 1 ~ FALSE,
      EDUCATTGENMOM < 90 ~ TRUE
    ),
    MOMMUAC_3 = case_when(
      MUACMOM <= 22 ~ "Acute (22 cm or less)",
      MUACMOM <= 25 ~ "Risk (22.1-25 cm)",
      MUACMOM < 90 ~ "Normal (>25 cm)"
    ),
    HHKIDS_4 = case_when(
      HHKIDS_NUM > 3 ~ "4+",
      T ~ as.character(HHKIDS_NUM)
    ), 
    INFAGE_3 = case_when(
      KIDAGEMO %in% 6:11 ~ "6-11",
      KIDAGEMO < 18 ~ "12-17",
      T ~ "18-23"
    ),
    INFDIAR = INFDIAR == 1
  ) 

# MDD  
dat <- dat %>% 
  mutate(
    GRP_BF = INFBFNOW == 1,
    GRP_NUT = INFYESTBEAN == 1,
    GRP_EGG = INFYESTEGG == 1,
    GRP_OTH = INFYESTOTHFRTVEG == 1,
    GRP_GRAIN = if_any(
      c(INFYESTFORM, INFYESTPORR, INFYESTGRAIN, INFYESTWHTVEG, INFYESTFORT),
      ~.x == 1
    ),
    GRP_DAIRY = if_any(
      c(INFYESTMILK, INFYESTYOG, INFYESTFORMP, INFYESTDAIRY),
      ~.x == 1
    ),
    GRP_FLESH = if_any(
      c(INFYESTFISH, INFYESTMEAT, INFYESTORG),
      ~.x == 1
    ),
    GRP_VITA = if_any(
      c(INFYESTYLWVEG, INFYESTGRNVEG, INFYESTYLWFRT),
      ~.x == 1
    )
  ) %>% 
  rowwise() %>% 
  mutate(MDD = sum(c_across(starts_with("GRP"))) >= 5) %>% 
  ungroup()

# MMF 
dat <- dat %>% 
  mutate(
    across(
      c(INFMILKNUM, INFYOGNUM, INFFORMNUM, INFFOODNUM), 
      ~case_when(.x < 90 ~ as.integer(.x))
    ),
    INFMILKNUM = ifelse(INFYESTMILK == 0, 0, INFMILKNUM),
    INFYOGNUM = ifelse(INFYESTYOG == 0, 0, INFYOGNUM),
    INFFORMNUM = ifelse(INFYESTFORMP == 0, 0, INFFORMNUM), 
    INFFOODNUM = ifelse(INFFOODYEST == 0, 0, INFFOODNUM),
  ) %>% 
  rowwise() %>% 
  mutate(MILKFEEDS = case_when(
    !if_all(c(INFMILKNUM, INFYOGNUM, INFFORMNUM), is.na) ~ 
      sum(c_across(c(INFMILKNUM, INFYOGNUM, INFFORMNUM)), na.rm = TRUE)
  )) %>% 
  ungroup() %>% 
  mutate(MMF = case_when(
    KIDAGEMO < 9 & GRP_BF ~ INFFOODNUM >= 2,
    KIDAGEMO >= 9 & GRP_BF ~ INFFOODNUM >= 3,
    !GRP_BF ~ INFFOODNUM + MILKFEEDS >= 4 & INFFOODNUM >= 1
  ))
  
# MAD 
dat <- dat %>% 
  mutate(MAD = case_when(
    GRP_BF ~ MMF & MDD,
    !GRP_BF ~ MMF & MDD & MILKFEEDS >= 2
  )) 

# MUAC_LOW 
dat <- dat %>% 
  mutate(MUAC_LOW = case_when(
    INFARMCIRCVAL > 5 & INFARMCIRCVAL < 90 ~ INFARMCIRCVAL <= 13.5
  ))

# HHFOODINSEC
dat <- dat %>% 
  select(PERSONID, HHWORRIEDYR, HHUNHEALTHYYR, HHFEWKINDSYR, HHSKIPMEALYR, 
         HHATELESSYR, HHRANOUTYR, HHHUNGRYYR, HHWHOLEDAYYR) %>% 
  mutate(across(!PERSONID, ~case_when(.x < 90 ~ .x == 1))) %>% 
  rowwise() %>% 
  mutate(
    HHFOODINSEC = sum(c_across(!PERSONID), na.rm = TRUE),
    HHFOODINSEC = case_when(
      HHFOODINSEC < 4 ~ "Low/None",
      HHFOODINSEC < 6 ~ "Moderate",
      HHFOODINSEC >= 6 ~ "Severe"
    )
  ) %>% 
  ungroup() %>% 
  select(PERSONID, HHFOODINSEC) %>% 
  right_join(dat, by = "PERSONID")

# lhz 
dat <- haven::read_dta("data/LHZdata.dta") %>% 
  select(EAID = EA_ID, lzcode) %>% 
  mutate(LIVZ_3 = case_when(
    lzcode == "BF06" ~ "Ouaga/Urban",
    lzcode %in% c("BF07", "BF08", "BF09") ~ "Pastoral", 
    T ~ "Agricultural"
  )) %>% 
  select(EAID, LIVZ_3) %>% 
  right_join(dat, by = "EAID")

# WRSI 
dat <- haven::read_dta("data/WRSI.dta") %>%
  select(EAID = EA_ID, WRSI_17 = eos_wrsi_anomaly_2017) %>%
  right_join(dat, by = "EAID")

# drop unused vars and cases 
infs <- dat %>% 
  select(
    PERSONID,
    EAID, LIVZ_3, URBAN, WRSI_17,
    MOMAGE_4, MOMEDUC, MOMMUAC_3, 
    HHKIDS_4, HHFOODINSEC, 
    INFAGE_3, INFDIAR, 
    MAD, MDD, MMF, MUAC_LOW
  ) %>% 
  filter(!if_any(everything(), is.na)) 

dat <- dat %>% 
  select(PERSONID, HHWORRIEDYR, HHUNHEALTHYYR, HHFEWKINDSYR, HHSKIPMEALYR, 
         HHATELESSYR, HHRANOUTYR, HHHUNGRYYR, HHWHOLEDAYYR) %>% 
  right_join(infs, by = "PERSONID") %>% 
  relocate(starts_with("HH"), .after = MUAC_LOW)

# Set factors 
dat <- dat %>% 
  mutate(
    LIVZ_3 = LIVZ_3 %>% fct_relevel("Agricultural", "Pastoral"),
    MOMAGE_4 = MOMAGE_4 %>% fct_relevel("35+", "25-34", "20-24"),
    MOMMUAC_3 = MOMMUAC_3 %>% fct_relevel("Normal (>25 cm)", "Risk (22.1-25 cm)"),
    INFAGE_3 = INFAGE_3 %>% fct_relevel("6-11", "12-17"),
    HHKIDS_4 = HHKIDS_4 %>% fct_relevel("1", "2", "3"),
    HHFOODINSEC = HHFOODINSEC %>% fct_relevel("Low/None", "Moderate")
  ) 

# Set Labels 
labelled::var_label(dat) <- list(
  INFAGE_3 = "Infant's age",
  INFDIAR = "Infant diarrhea last 2 wks",
  MOMAGE_4 = "Mother's age",
  MOMEDUC = "Mother ever attended school",
  MOMMUAC_3 = "Mother's MUAC (cm)",
  HHKIDS_4 = "Household total kids under 5",	
  HHFOODINSEC = "Household food insecurity",	
  MAD = "Minimum Acceptable Diet (MAD)",	
  MDD = "Minimum Dietary Diversity (MDD)",	
  MMF = "Minimum Meal Frequency (MFF)",	
  MUAC_LOW = "MUAC 13.5 cm or less",
  LIVZ_3 = "Livelihood zone",
  WRSI_17 = "WRSI anomaly 2017"
)

write_rds(dat, "data/pma_nutrition.rds.gz", compress = "gz")
