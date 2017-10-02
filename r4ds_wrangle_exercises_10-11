# Ray Miller
# DSA Phase 2 Week 1 Work
# 10/01/2017

library(tibble)
library(tidyverse)
library(hms)
library(lubridate)

# 10.5 Exercises
# 1. If the object is a tibble, it says: "A tibble" when printed
mtcars
tibble_mtcars <- as.tibble(mtcars)
tibble_mtcars

# 2. The benefits of using tibble are that it gives you warnings (Unknown or uninitialised column: 'x') and additional
#    info such as displaying variable types. Data frames can cause you frustration by letting you do things you
#    shouldn't have and not providing info when weird things are going on. 
df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

tb_df <- as.tibble(df)
tb_df$x
tb_df[, "xyz"]
tb_df[, c("abc", "xyz")]

# 3.Using the steps below, you can extract the reference var from a tibble.
var <- "cty"
mpg[[var]]

# 4.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying

# 1)
annoying[[1]]

# 2)
annoying %>% ggplot() + geom_point(mapping = aes(annoying[[2]], annoying[[1]]))

# 3)
annoying %>% mutate("3" = annoying[[2]]/annoying[[1]]) -> annoying

# 4)
annoying %>% transmute(one = annoying[[1]], two = annoying[[2]], three = annoying[[3]])

# 5. I see the many uses for enframe, but combining disparate lists as below is one time when it could be useful.
?enframe
df <- enframe(c("one", "three", "five", "nine"))
df2 <- enframe(c("two", "four", "six", "eight"))
bind_rows(df, df2) %>% select(-name) %>% print

# 6. tibble.max_extra_cols controls how many col names are printed at the footer of a tibble.
?options
options(tibble.max_extra_cols = 100)
who
options(tibble.max_extra_cols = 5)
who



# 11.2.2 Exercises
# 1.
read_table(pipe(), sep = "|")

# 2. col_names, col_types, locale, na, quoted_na, quote, trim_ws, n_max, guess_max, progress 
?read_csv
?read_tsv

# 3. col_positions using fwf_widths() or fwf_positions is the most important argument to read_fwf
?read_fwf

# 4. 
?read_delim
# var <- gsub('1', '', x = "x,y\n1,'a,b'") 
read_delim("x,y\n1,'a,b'", delim = ",", quote = "'")

# 5.
# Three variables per obervation but only two column names
read_csv("a,b\n1,2,3\n4,5,6")
# Uneven number of values in each row and in header 
read_csv("a,b,c\n1,2\n1,2,3,4")
# No second value given for b variable 
read_csv("a,b\n\"1")
# Column headers repeated 
read_csv("a,b\n1,2\na,b")
# ; delim not separated correctly
read_csv("a;b\n1;3")



# 11.3.5 Exercises
# 1.I'd say the most important arguments to locale depend on what you're using it for, but decimal_mark and 
# grouping_mark will both likely be universally important.
?locale

# 2. 
# "Error: `decimal_mark` and `grouping_mark` must be different"
locale(decimal_mark = ",", grouping_mark = ",")
# If grouping_mark isn't specified, the default will be changed to "."
locale(decimal_mark = ",")
# If decimal_mark isn't specified, the default will be changed to ","
locale(grouping_mark = ".")

# 3. They define the default date and time formats for parsing datetime data. 
parse_datetime("2017-12-12 12:12", locale = locale(tz = "US/Pacific"))

# 4. I live in the U.S.

# 5. read_csv: comma delimited files; read_csv2: semicolon delimited files

# 6. Europe: ISO Latin 1 (aka ISO 8859-1); Asia: Much more challenging and less known

# 7. 
d1 <- "January 1, 2010"
mdy(d1)

d2 <- "2015-Mar-07"
ymd(d2)

d3 <- "06-Jun-2017"
dmy(d3)

d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)

d5 <- "12/30/14" # Dec 30, 2014
mdy(d5)

t1 <- "1705"
parse_time(t1, "%H%M")

t2 <- "11:15:10.12 PM"
parse_time(t2, "%H:%M:%OS %p")
