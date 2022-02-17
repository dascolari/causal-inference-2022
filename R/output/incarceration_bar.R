read_csv(here(file.path("data", "nlsy97_clean.csv"))) %>%
  filter(race != "Mixed Race (Non-Hispanic)") %>% 
  group_by(race, gender) %>%
  summarise(mean_days_incarcerated = (sum(months_incarcerated)*(365/12)*(1/n())), n = n(), .groups = 'drop') %>% 
  pivot_wider(names_from = gender, 
              values_from = mean_days_incarcerated, 
              id_cols = race) %>% 
  mutate(ratio = Male/Female) %>% 
  ggplot() +
  geom_col(aes(x = race, y = ratio), fill = '#8668FF') +
  labs(x = "Race", y = "Male/Female Ratio", title = "Ratio of Male/Female Incarceration Time per Person")
ggsave(here(file.path("figures", "inc_bar.png")), width=8, height=4.5)
