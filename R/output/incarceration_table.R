read_csv(here(file.path("data", "nlsy97_clean.csv"))) %>%
  filter(race != "Mixed Race (Non-Hispanic)") %>% 
  group_by(race, gender) %>%
  summarise(mean_days_incarcerated = (sum(months_incarcerated)*(365/12)*(1/n())), n = n()) %>% 
  pivot_wider(names_from = gender, 
              values_from = mean_days_incarcerated, 
              id_cols = race) %>% 
  rename_with(to_title_case) %>%
  
  # create the kable object. Requires booktabs and float LaTeX packages
  kbl(
    caption = "Per Person Incaeration Days",
    booktabs = TRUE,
    format = "latex",
    label = "tab:summarystats"
  ) %>%
  kable_styling(latex_options = c("striped", "HOLD_position")) %>% 
  write_lines(here(file.path("tables", "inc_table.tex")))