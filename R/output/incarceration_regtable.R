inc_days_lm <- read_csv(here(file.path("data", "nlsy97_clean.csv"))) %>% 
  mutate(days_incarcerated = months_incarcerated*(365/12)) %>% 
  lm(days_incarcerated ~ race + gender, data = .)

se <- inc_days_lm %>% vcovHC %>% diag %>% sqrt

covariate.labels <- names(coef(inc_days_lm))[-1] %>% str_replace("(^race)|(^gender)", "")

stargazer(
  inc_days_lm,
  se = list(se),
  covariate.labels = covariate.labels,
  dep.var.labels = "Per Person Incarceration Time in 2002 (days)",
  out = here("tables/regress_inctime_by_racegender.tex"),
  title = "Regression Output. Omitted category is Black Females.",
  label = "tab:regression"
) %>% 
  write_lines(here(file.path("tables", "inc_regtable.tex")))