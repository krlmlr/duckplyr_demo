options(conflicts.policy = list(warn = FALSE))
library(tidyverse)

source("dplyr/load_taxi_data.R")

start <- Sys.time()

popular_manhattan_cab_rides <- taxi_data_2019 |>
  filter(total_amount > 0) |>
  inner_join(zone_map, by = join_by(pickup_location_id == LocationID)) |>
  inner_join(zone_map, by = join_by(dropoff_location_id == LocationID)) |>
  filter(Borough.x == "Manhattan", Borough.y == "Manhattan") |>
  select(start_neighborhood = Zone.x, end_neighborhood = Zone.y) |>
  summarise(
    num_trips = n(),
    .by = c(start_neighborhood, end_neighborhood),
  ) |>
  arrange(desc(num_trips))

time <- hms::as_hms(Sys.time() - start)

q3_dplyr <- time
print("Dplyr Q3 collection time")
print(q3_dplyr)
print("Most popular cab rides within manhattan")
popular_manhattan_cab_rides |>
  head(5) |>
  print()
