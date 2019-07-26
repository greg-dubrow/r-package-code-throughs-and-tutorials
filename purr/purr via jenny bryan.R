# https://jennybc.github.io/purrr-tutorial/index.html

# vecotrs and lists - ecessary because purr iterates over vectors & lists

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