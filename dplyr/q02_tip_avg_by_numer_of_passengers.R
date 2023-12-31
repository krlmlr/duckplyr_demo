options(conflicts.policy = list(warn = FALSE))
library(tidyverse)

source("dplyr/load_taxi_data.R")

start <- Sys.time()

tips_by_passenger <- taxi_data_2019 |>
  filter(total_amount > 0) |>
  mutate(tip_pct = 100 * tip_amount / total_amount) |>
  summarise(
    avg_tip_pct = median(tip_pct),
    n = n(),
    .by = passenger_count
  ) |>
  arrange(desc(passenger_count))

time <- hms::as_hms(Sys.time() - start)

q2_dplyr <- time
print("Dplyr Q2 collection time")
print(q2_dplyr)
print("tips by passenger count")
tips_by_passenger |>
  head(5) |>
  print()
