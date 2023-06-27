options(conflicts.policy = list(warn = FALSE))
library(duckplyr)
library(tidyverse)

duckplyr_from_parquet <- function(path, options=list()) {
   out <- duckdb:::rel_from_table_function(duckplyr:::get_default_duckdb_connection(), "read_parquet", list(path), options)
   duckplyr:::meta_rel_register_csv(out, path)
   duckplyr:::as_duckplyr_df(duckdb:::rel_to_altrep(out))
}

taxi_data_2019 <- duckplyr_from_parquet('/Users/tomebergen/taxi-data-2019/*/*.parquet', list(hive_partitioning=TRUE))
zone_map <- duckplyr_from_parquet("/Users/tomebergen/duckplyr_demo/zone_lookups.parquet")


# maybe vector memory limit is exhausted depending on your memory?
# there are 168 groups
tips_by_day_hour <- taxi_data_2019 |> 
  filter(total_amount > 0) |> 
  mutate(tip_pct = 100 * tip_amount / total_amount, dn = wday(pickup_datetime), hr=hour(pickup_datetime)) |>
  summarise(
    avg_tip_pct = mean(tip_pct),
    n = n(),
    .by = c(dn, hr)
  ) |>
  arrange(desc(avg_tip_pct))

time <- system.time(collect(tips_by_day_hour))