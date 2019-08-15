# https://jennybc.github.io/purrr-tutorial/index.html

# maybe also? https://www.zevross.com/blog/2019/06/11/the-power-of-three-purrr-poseful-iteration-in-r-with-map-pmap-and-imap/

library(tidyverse)
library(repurrrsive)
library(listviewer)
library(magrittr)
### vecoros and lists - ecessary because purr iterates over vectors & lists

# vectors
v_log <- c(TRUE, FALSE, FALSE, TRUE)
v_log


v_int <- 1:4
glimpse(v_int)

v_doub <- 1:4 * 1.2
glimpse(v_doub)

v_char <- letters[1:4]

is.logical(v_char)
# test also is.numeric, is.integer, is.character

v_int[0]

# hieararchy of the most common atomic vector types: logical < integer < numeric < character
# keep in mind if trying to coerce from one type to another

as.logical(v_char)

## lists - essentially multiple vectors in the same object. can have multiple layers.
# when contructing by hand, each comma separates levels

l_x <- list(1:3, c("four", "five"))

l_y <- list(logical = TRUE, integer = 4L, double = 4 * 1.2, character = "character")

is.logical(l_y)

l_z <- list(letters[26:22], transcendental = c(pi, exp(1)), f = function(x) x^2)

# when indexing a list single brackets return the named element or number range, i.e.

l_y[2:3] # returns layers 2 & 3 of the 4 layer list

l_z["transcendental"] # returns just the layer named "transcendental"

l_z[[2]] # does same as above but using brackets
l_z[c(TRUE, FALSE)]

my_vec <- c(a = 1, b = 2, c = 3)
my_list <- list(a = 3, b = 6, c = 9)
my_list$a
my_list["a"] # this and call above return 1st object by name
my_list[1] # calls 1st object by position


# vectorized operations

n <- 5
seq_len(n) ^ 2 # simple call that goes across vector to square 1 to n
seq_len(n) * 3 # or mulltiples by 3
exp(v_doub) # exponentiation of a vector

# but how to do with list? PURRR!
l_doub <- as.list(v_doub)
l_doub
v_doub
map(l_doub, exp) # function is do action on right of comma to object on left of comma 
                 # or in purrr language, map exp() over list l_doub


#### purrr lessons
## explore example lists

str(wesanderson)
View(wesanderson)

str(got_chars) # shows all list layers
str(got_chars, list.len = 4) # limits to 1st 4
str(got_chars[[1]], list.len = 8) # looks at 1st value, 8 layers

str(got_chars, max.level = 2, list.len = 3) # three elements, 3 layers

# Introduction to map():extract elements

# using map 
  # map(LIST, FUNCTION)

# extract names of 1st 4 GoT characters - each call does same thing
map(got_chars[1:4], "name")
map(got_chars[1:4], 3)

 # gets all names, in pipe
got_chars %>%
  map("name")
got_chars %>%
  map(3)
names(got_chars)

map(got_chars[1:4], "name") # returns postion and value
map_chr(got_chars[1:4], "name") # returns just value

gotnames <- map_chr(got_chars[1:4], "name") # returns just value to a chr vector

# also use map_lgl(), map_int(), map_dbl()

# exercise...pull id
map_int(got_chars[1:5], "id") # can also use 2 instead of "id"

# extract multiple values

 # call gets 3rd value overall, and the elements requested after c()
gotvect1 <- got_chars[[3]][c("name", "culture", "gender", "born")] # extracts to another list
gotvect1

gotvect2 <- map(got_chars, `[`, c("name", "culture", "gender", "born")) # extracts requested elements to list of all characters
str(gotvect2[3]) # selects one of the list
str(gotvect2[14:17]) # selects multiple of the list

gotvect2a  <- map(got_chars, magrittr::extract, c("name", "culture", "gender", "born")) # does same but uses magrittr for extract

# exercise - do above but use number instead of name
gotvect2b  <- map(got_chars, magrittr::extract, c(3, 5, 4, 6)) 

# output to dataframe
gotdf1 <- map_dfr(got_chars, magrittr::extract, c("name", "culture", "gender", "id", "born", "alive"))
glimpse(gotdf1)

# in above case types converted automatically. manual version below
got_chars %>% {tibble(
     name = map_chr(., "name"),
  culture = map_chr(., "culture"),
   gender = map_chr(., "gender"),
       id = map_chr(., "id"),
     born = map_chr(., "born"),
    alive = map_chr(., "alive"),
)}

# exercise do above but with numbers, not names

got_chars %>% {tibble(
  name = map_chr(., 3),
  culture = map_chr(., 5),
  gender = map_chr(., 4),
  id = map_chr(., 2),
  born = map_chr(., 6),
  alive = map_chr(., 8),
)}

# Lesson Simplifying data from a list of GitHub users end to end: 
   # inspection, extraction and simplification, more advanced

str(gh_users[[1]])
listviewer::jsonedit(gh_users)

map(gh_users, "login")
names(gh_users[[4]])

map(gh_users, 29)

str(gh_users) # show all
str(gh_users, max.level = 2, list.len = 4) # goes two layers into list, gets 1st four elements, all records
str(gh_users, max.level = 2, list.len = 4) # goes two layers into list, gets 1st four elements, all records
str(gh_users[[2]], max.level = 2, list.len = 4) # goes two layers into list, gets 1st four elements, 2nd records
str(gh_users[2:4], max.level = 2, list.len = 4) # goes two layers into list, gets 1st four elements, 2nd - 4th records



#### from zev ross, much lifted from jenny bryan
# https://www.zevross.com/blog/2019/06/11/the-power-of-three-purrr-poseful-iteration-in-r-with-map-pmap-and-imap/
library(tidygraph)
library(ggraph)

dat <- got_chars
glimpse(dat)

## extract a single element
map(dat, "name") # name is 3rd element
map(dat, 3)

 # or use pluck (from purrr)
map(dat, pluck("name"))

## create a datframe from a list
map_dfr(dat, `[`, c("name", "gender", "culture"))

map_dfr(dat, `[`, c("name", "gender", "culture", "aliases", "allegiances")) 
    # throws error b/c many aliases are lists themselves & have more than 1 inputs
glimpse(map(dat, "aliases"))

# need to do longer method to create df. fields that are themselves lists will be kept that way

dat_m <- dat %>% {
  tibble(
    name = map_chr(., "name"),
    gender = map_chr(., "gender"),
    culture = map_chr(., "culture"),
    aliases = map(., "aliases"),
    allegiances = map(., "allegiances"))
  }
view(dat_m)

## write a function
 # calls on alive field (a logical) and pastes one of two options if TRUE or FALSE
dead_or_alive <- function(x){
  ifelse(x[["alive"]], paste(x[["name"]], "is alive!"),
         paste(x[["name"]], "is dead :("))
}
# function says in x (the object, in this case data set), find "alive" vector. if true print 1st statement
# if false print 2nd statement

map_chr(dat, dead_or_alive)
 # here dat is the x from the function 

  # compact() removes empty vectors from the list
dat2 <- map(dat, compact)
glimpse(dat2)
glimpse(dat)

dat[[19]]$aliases
dat2[[19]]$aliases

# function to pull aliases and array them into table for network graph
aka <- function(x){
  if("aliases" %in% names(x)){
    g <- tibble(
      from = x$name,
      to = x$aliases)
    
    g <- as_tbl_graph(g)
  }
}

dat_nw <- map(dat2, aka)
dat_nw[[2]]
glimpse(dat_nw)

ggraph(dat_nw[[22]], layout = "graphopt") +
  geom_edge_link() +
  geom_node_label(aes(label = name),
                  label.padding = unit(1, "lines"),
                  label.size = 0) +
  theme_graph()

## attempt to write function for graph and apply to list...need to figure out how to do this
alias_ng <- function(x){
  ggraph(.data[[x]], layout = "graphopt") +
    geom_edge_link() +
    geom_node_label(aes(label = name),
                    label.padding = unit(1, "lines"),
                    label.size = 0) +
    theme_graph()
}
imap(dat_nw, alias_ng, .x)
####

## using pmap row-wise using col names

map(dat_m, paste)
pmap(dat_m, paste)

dat_pmap <- mutate(dat_m, starklan = map(allegiances, ~str_extract(.x, "Lannister|Stark")))
glimpse(dat_pmap)

dat_pmap <- mutate(dat_pmap, starklan = map(starklan, ~discard(.x, is.na)))
glimpse(dat_pmap)
dat_pmap$starklan[16:18]

dat_pmap <- filter(dat_pmap, starklan %in% c("Lannister", "Stark")) %>%
  unnest(starklan)
glimpse(dat_pmap)


# uses glue function to create strings using dataset names
 # note var names after function call are same to those in {} brackets
whotrust <- function(name, allegiances, starklan, ...) {
  y <- glue::glue("{name} has an allegiance to the {starklan} family")
  ifelse(length(allegiances) > 1,
  glue::glue("{y} but also has {length(allegiances)-1} other allegiances(s)."),
  glue::glue("{y} and not other allegiances."))
}

dat_pmap %>% pmap_chr(whotrust)





























