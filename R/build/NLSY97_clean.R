# Builds the cleaned NLSY97 incarceration dataset on crime for analysis
# vignette("colwise")
# vignette("rowwise")

read_csv(here(file.path("data", "nlsy97_incar_2002.csv"))) %>%
  
  # refused responses or already incarcerated --> NA
  # starts_with("E") are the columns that hold incaerceration status each month of 2002
  mutate(across(starts_with("E"), ~case_when(
    .x < 0   ~ NA_real_,
    .x == 99 ~ NA_real_,
    TRUE     ~ .x
  ))) %>%
  
  # if you had NAs for the entire year, remove you
  filter(if_any(starts_with("E"), ~!is.na(.x)))%>%
  
  # sum across the months using rowwise to get months incarcerated
  rowwise() %>%
  mutate(months_incarcerated = sum(c_across(starts_with("E")), na.rm = TRUE)) %>%
  ungroup() %>%

  # recode the gender variable
  mutate(gender = if_else(R0536300 == 1, "Male", "Female")) %>%
  
  # recode the race variable
  mutate(race = case_when(
    R1482600 == 1 ~ "Black",
    R1482600 == 2 ~ "Hispanic",
    R1482600 == 3 ~ "Mixed Race (Non-Hispanic)",
    R1482600 == 4 ~ "Non-Black / Non-Hispanic",
  )) %>%
  
  # finally, select the variables that will be used in the analysis
  select(race, gender, months_incarcerated) %>%
  
  # write to a csv
  write_csv(here(file.path("data", "nlsy97_clean.csv")))