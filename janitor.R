library(janitor)
library(pacman)
library(tidyverse)
library(here)
library(readxl)

usethis::use_git()
roster_raw <- read_excel(here("dirty_data.xlsx"))  