# BAD PENGUINS

library(tidyverse)
library(palmerpenguins)

penguins

pcols <- colnames(penguins)

badpenguins <- tibble(colnames = pcols,
                      c("Penguin", "Gotham", NA, NA, NA, 90, "male", 1966))

badpenguins <-
  pivot_wider(badpenguins, names_from = `colnames`, 
            values_from = `c("Penguin", "Gotham", NA, NA, NA, 90000, "male", 1966)`)

badpenguins

badpenguins <- rbind(badpenguins,
      c("Pingu", "Antarctica", NA, NA, NA, NA, "male", 1986),
      c("Pinga", "Antarctica", NA, NA, NA, NA, "female", 1986),
      c("Opus", "Bloom County", NA, NA, NA, NA, "male", 1981),
      c("Gunter", "Ice Kingdom", NA, NA, NA, NA, "unknown", 2012)
      )

reallybadpenguins <- rbind(penguins, badpenguins)

write_rds(reallybadpenguins, 
          here::here("data", "reallybadpenguins.rds"))



