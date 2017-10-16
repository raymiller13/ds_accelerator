# Ray Miller
# DSA Phase 2 Week 3: Chaps 14-15
# 10/15/2017

library(tidyverse)
library(stringr)
library(htmltools)
library(htmlwidgets)
library(forcats)

# 14.2.5 Exercises
# 1.Paste coerces missing values to NA. Paste0 is equivalent to  paste(..., sep = "", collapse) but is slightly more efficient.
#   These are equivalent to str_c() in the stringr package.
?paste
?paste0
?str_c

# 2. Sep adds whatever you want between the strings you're combining. Collapse, if not null, combines factors to a single
#    string. Else, there remain multiple strings for each part of the vector.
str_c("x", "y", sep = ", ")
str_c("x", c("y","z"), collapse = "this")
str_c("x", c("y", "z"), sep = ", ", collapse = "this")
str_c("x", c("y", "z"), collapse = NULL)


# 3. If there are an even number of characters, nothing should be returned.
str_1 <- "This is astring"
str_length(str_1)
str_sub(str_1,start = (str_length(str_1))/2, end = (str_length(str_1))/2)

# 4. str_wrap helps you break up up paragraphs into lines of text based on its input arguments.
#    This could be used to break up a list so that each item is on a new line.
?str_wrap

# 5. str_trim cuts the whitespace from the start and end of a string. Str_pad does the opposite.
?str_trim

# 6. This would not work properly with vectors of lengths other than 3.
the_string <- c("a", "b", "c")
first_sub <- the_string[1:2] %>% 
str_c(collapse = ", ") 
cat(str_trim(first_sub), ", and ", the_string[3], sep = "")


# 14.3.1.1 Exercises
# 1. Because the \ character is defined as an escape character, which prevents the actual character from being matched.
# To get the \ character:
cat("\\", "", sep = "")

# 2. "\"\'\\"
cat("\"\'\\", "", sep = "")

# 3.
str_detect(c("..this..that..", "yamsss", "......", ".........", "a..d..f.."), "\\..\\..\\..")
cat("\\..\\..\\..", "", sep = "")

# 14.3.2.1 Exercises
# 1.
str_2 <- "$^$"
cat("$^$", "", sep = "")
str_detect(str_2, "\\$\\^\\$")

# 2. 
str_view_all(c("yes", "yams", "yesterday", "nope", "Ray"), "^y")
str_view_all(c("yes_X", "yams_x", "xyesterdayx", "nope", "xRay"), "x$")
str_view_all(c("yes", "yam", "yesterday", "nope", "Ray"), "^...$")
str_view_all(c("LosEstadosUnidos", "yam", "yesterday", "nope", "Rayyyyy"), "^.......")



# 14.3.3.1 Exercises
# 1. 
str_view_all(c("yes", "am", "oye", "nope", "eat"),"^[aeiou]")
!str_detect(c("yes", "lsdfm", "thngs", "np", "eat"), "[aeiou]")
str_view_all(c("fireed", "wed", "tireeed"), "([^e]ed$)")
str_view_all(c("firing", "wise", "firingrange"), "(ing$|ise$)")

# 2. Two exceptions
sum(ifelse(str_detect(words, "cie") == TRUE, 1, 0))

# 3.
str_detect(c("quest", "qi"), "qu")

# 4.
str_detect(c("color", "colour", "summarize", "summarise"), "(ise|our)")

# 5.
str_detect(c("7209887175", "3a3b3O1212", "720-988-7175"), "([0123456789]{10}")



# 14.4.2 Exercises
# 1.
str_detect(c("yes_X", "yams_x", "xyesterdayx", "nope", "xRay"), "^x|x$")
str_detect(c("yes_X", "yams_x", "xyesterdayx", "nope", "xRay"), "^x") | str_detect(c("yes_X", "yams_x", "xyesterdayx", "nope", "xRay"), "x$")

str_detect(c("es_X", "yams_x", "xyesterdayx", "ope", "xRa"), "^[aeiou]*[bcdfghjklmnpqrstvxyz]$")

contains_a <- str_detect(words, "a")
contains_e <- str_detect(words, "e")
contains_i <- str_detect(words, "i")
contains_o <- str_detect(words, "o")
contains_u <- str_detect(words, "u")

# No.
sum(ifelse((contains_a&contains_e&contains_i&contains_o&contains_u)== TRUE, 1, 0))

# 2. Most vowels: "appropriate" "associate"   "available"   "colleague"   "encourage"   "experience"  "individual"  "television" 
# Highest proportion: "a" has the highest proportion. "I" was no included in words.
final_out <- words %>%  
  tibble(word = words[], count = str_count(words[], "[aeiou]"), length = str_length(words[])) %>% 
  select(word, count, length) %>% 
  arrange(desc(count))
View(final_out)
head(final_out$word, 8)

final_out <- words %>%  
  tibble(word = words[], count = str_count(words[], "[aeiou]"), length = str_length(words[])) %>% 
  select(word, count, length) %>% 
  mutate(prop = count/length) %>% 
  arrange(desc(prop))
View(final_out)
head(final_out$word, 1)
  


# 14.4.6.1 Exercises
# 1. 
str_split("this, that, and those", pattern = ", and |, ")

# 2. 
str_ex <- "Short answer multiple  spaces"
str_split(str_ex, pattern = " ")
str_split(str_ex, boundary("word"))

# 3. It produces: character(0). This is because it sees the string as a boundary character thus returning nothing.
str_split("", boundary())
str_split("", boundary("word"))
str_split("", "")
?str_split



# 15.4.1 Exercises
# 1.Using jitter, it is clear that the tvhours values are mostly concentrated between 0-6, and the extreme values
#   in the 20s are skewing the mean. Median appears to be more useful in most cases for this dataset.
mean(gss_cat$tvhours, na.rm = TRUE)
median(gss_cat$tvhours, na.rm = TRUE)
gss_cat %>% mutate(age_jit = jitter(x = age, factor = 3)) %>%  
  ggplot() + geom_point(aes(tvhours, age_jit))

# 2. rincome (and arguably relig and partyid -- based on liberal, conservative spectrum) is the only ordered 
#    categorical variable in gss_cat.
gss_cat %>% 
  sapply(levels)

# 3. This is because the fct_relevel function allows you to move any number of levels to any location (last in this case).
rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
 ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

 levels(gss_cat$rincome)
 
 
 
# 15.5.1 Exercises
 # 1.
 newnew <- gss_cat %>%
   group_by(year) %>% 
   mutate(partyid = fct_collapse(partyid,
     other = c("No answer", "Don't know", "Other party"),
     rep = c("Strong republican", "Not str republican"),
     ind = c("Ind,near rep", "Independent", "Ind,near dem"),
     dem = c("Not str democrat", "Strong democrat")
   )) %>%
   count(partyid) 
newnew %>% 
  ggplot() + geom_bar(aes(year, n, fill=factor(partyid, levels=c("dem", "ind", "rep"))), stat="identity")

# 2.
levels(gss_cat$rincome)
final <- gss_cat %>%
  mutate(rincome_condensed = fct_collapse(rincome,
                                low = c("$5000 to 5999", "$4000 to 4999", "$3000 to 3999", "$1000 to 2999", "Lt $1000"),
                                mid = c("$10000 - 14999", "$8000 to 9999", "$7000 to 7999", "$6000 to 6999"),
                                high = c("$25000 or more", "$20000 - 24999", "$15000 - 19999"),
                                na = c("No answer", "Don't know", "Refused", "Not applicable")
  ))
  summary(final$rincome_condensed)
