# https://jennybc.github.io/purrr-tutorial/index.html

library(tidyverse)
library(repurrrsive)
library(listviewer)
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


## purrr lessons
# explore example lists

str(wesanderson)
View(wesanderson)

str(got_chars) # shows all list layers
str(got_chars, list.len = 4) # limits to 1st 4
str(got_chars[[1]], list.len = 8) # looks at 1st value, 8 layers

str(got_chars, max.level = 2, list.len = 3) # three elements, 3 layers

# extract elements

# using map map(LIST, FUNCTION)

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

