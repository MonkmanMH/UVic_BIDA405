# dplyr::case_when to find and clean FSA
#
# Notes:
# * FSA = "Forward Sortation Area" in Canadian postal parlance
# * the regex finds British Columbia FSAs (starting with "V")

### ----

library(dplyr)

# Generate all BC FSAs (not all will be legit, since not all letters are permitted)

# declare output as character vector
output <- vector("character", 1)
x <- 1   # initialize counter

for (i in 0:9) {
  for (j in LETTERS) {
    #    for (k in 0:9) {
    output[x] <- (paste("V", i, j, sep = ""))
    x <- x + 1
    #    }
  }
}

df <- as.tibble(output)
df <- df %>% 
  rename(FSA = value)

### ----

# test FSAs

fsa_list <- df %>% 
  mutate(FSA_clean = case_when(
    str_detect(FSA, "^V\\d[A-Z]$") == TRUE ~ FSA,
    TRUE ~ NA_character_
  )) %>% 
  select(FSA_clean)

### ----

# synthetic postal codes: process to add all possible combinations of digit-character-digit to a single FSA

# declare output as character vector
output <- vector("character", 1)

x <- 1   # initialize counter

for (i in 0:9) {
  for (j in LETTERS) {
    for (k in 0:9) {
      output[x] <- (paste(i, j, k, sep = ""))
      x <- x + 1
    }
  }
}

pc_last3 <- as_tibble(output)

head(pc_last3)
tail(pc_last3)


### ----

# do a one-to-many join of every possible last 3 to each possible FSA

bc_pc <- 
  tidyr::crossing(fsa_list, pc_last3) %>% 
  mutate(postalcode = glue::glue('{FSA_clean} {value}'))
  

bc_pc %>% 
  filter(FSA_clean == "V0A") 

# leave single column with just `postalcode`
bc_pc <- bc_pc %>% 
  select(postalcode)


write_rds(bc_pc, here::here("data", "bc_pc.rds"))
write_csv(bc_pc, here::here("data", "bc_pc.csv"))

### ----

# test for legitimacy with regex

# all Canadian postal codes
postalcode <- "(?i)^[ABCEGHJ-NPRSTVXY]\\d[ABCEGHJ-NPRSTV-Z][ -]?\\d[ABCEGHJ-NPRSTV-Z]\\d$(?-i)"
# BC specific (first letter V)
postalcode <- "(?i)^V\\d[ABCEGHJ-NPRSTV-Z][ -]?\\d[ABCEGHJ-NPRSTV-Z]\\d$(?-i)"

#str_detect(bc_pc$postcode, postalcode)


bc_pc_test <- bc_pc %>% 
  mutate(pc_clean =
         str_detect(postcode, postalcode)
  )

bc_pc_test %>% 
  group_by(pc_clean) %>% 
  tally()
