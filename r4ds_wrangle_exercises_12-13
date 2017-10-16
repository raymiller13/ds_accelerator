# Ray Miller
# 10/08/2017
# DSA Phase 2 Week 2 Exercises

library(tidyverse)
library(nycflights13)
library(tibble)
library(babynames)
library(nasaweather)
library(fueleconomy)


# 12.2.1 Exercises
# 1.
# Table 1: Each column has a variable and each row has an obervation -- the data set is tidy
# Table 2: The type column contains two variables (cases, population) and the count variable contains the values for
# both variables. This means you would need two rows to get a full observation for a given country for a given year.
# Tables 3: While rate may actually be what is most important and thus make this form a useful data set, the rate
# column contains two variables in one column, which is untidy.
# Table 4a-b: Here we have cases and population spread across multiple tables.Additionally, each table has a single
# variable spread across multiple columns (by year).

# 2. 
table2
glimpse(table2)
temp1 <- table2 %>% filter(type == "cases") %>%  transmute(country, year, cases = count)
temp2 <- table2 %>% filter(type == "population") %>%  transmute(country, year, population = count)
combined <- left_join(temp1, temp2, by = c('country', 'year'))
combined_rate <- combined %>% mutate(rate = (cases/population)*10000) %>% glimpse

table4a
table4b
temp3 <- table4a %>% gather(year, cases, '1999', '2000')
temp4 <- table4b %>% gather(year, population, '1999', '2000')
combined1 <- left_join(temp3, temp4, by = c('country', 'year')) %>% mutate(rate = (cases/population)*10000) %>% glimpse

# 3. A couple ways to do this, but by using this version of table 2, it is easy to isolate the values of cases.
combined_rate %>% 
ggplot(aes(year, cases)) + geom_point(aes(color = country)) + geom_line(mapping = aes(group = country), color = 'blue')
  



# 12.3.3 Exercises
# 1. Other than column order, the main difference is that the variable year's type is not kept after the spread/ gather.
#   Convert will convert the type of the key column if set to TRUE.
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)

# 2. This code fails because 1999 and 2000 look like numerics not variables to R.
table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

# 3. Phil has two age observations. Add another column that can separate these two observations to spread the tibble.
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

people2 <- tribble(
  ~name,             ~key,    ~value, ~valNum,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45, "x",
  "Phillip Woods",   "height",   186, "x",
  "Phillip Woods",   "age",       50, "y",
  "Jessica Cordero", "age",       37, "x",
  "Jessica Cordero", "height",   156, "x"
)

spread(people2, key, value)

# 4.Vars: pregnant, sex, count
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

# tidy
preg2 <- preg %>% gather(sex, count, male, female)




# 12.4.3 Exercises
# 1. Extra helps deal with if there is an extra value in a matrix, fill can add extra missing values to get the dimensions of the matrix to be correct.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "drop")

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "right", remove = FALSE)

# 2. The remove argument removes an input column from the final output. Setting remove to false see give you a unique key from the three columns as one use case.

# 3. Separate: single char column into multiple cols, extract: creates new columns by group of obs.
#    There is only one unite since, in contrast to separate/extract, there's one way to group many columns into a single one.



# 12.5.1 Exercises
# 1.Spread fill: missing vals replaced with explicitly named val; Complete fill: named list replaces missing vals.

# 2. Direction: the direction/order to fill in missing vals (up, down)



# 12.6.1 Exercises
# 1. I would say it depends on what the missing values mean as to whether it's okay to exclude them and still expect
#    reasonable results. Since there are both NAs and 0s in the data, there seem to be multiple versions of missing
#    values or where the data seems incomplete.

# 2. It appears that the missing underscore was an input error. Without the mutate, multiple variables are contained in a single colum.
who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>% 
  separate(code, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

who1 <- who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  separate(code, c("new", "var", "sexage")) %>% 


filter(who1, new == "newrel") %>% head()

# 3. According to documentation, iso2, iso3 are country codes, which means all three variables are the same, simply represented differently syntactically.
?who

# 4.
who_final <- who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>% 
  separate(code, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

who_final %>% 
  group_by(country, sex, year) %>% 
  summarise(numCases = sum(value)) %>%
  unite(country_sex, country, sex) %>% 
  filter(year >= 1995) %>% 
  ggplot() + geom_line(mapping = aes(year, numCases, group = country_sex))
  


# 13.2.1 Exercises
# 1. Lat, long of the origin and destination airports. Flights and airports would have to be combined.

# 2. Weather connects to airports via a single variable in each table, origin in weather to faa in airports.

# 3. Dest would have to be matched as well, with the dest year, day, month, hour values added in as well.

# 4. You could add a `holiday` table with year, month, and day values forming a date key.



# 13.3.1 Exercises
# 1. 
flights1 <- flights %>%  mutate(key = row_number())
flights1 %>% count(key) %>% filter(n > 1)

# 2.
# The unique key is playerID + yearID + stint
Lahman::Batting %>% count(playerID, yearID, stint) %>% filter(n > 1)

# Key: Year, sex, name
babynames::babynames

# Key: year, month, lat, long
nasaweather::atmos

# Key:id
fueleconomy::vehicles %>% count(id) %>% filter(n>1)

# No unique key with current vars in table
ggplot2::diamonds %>% count(carat, cut, color, depth, table, price, x, y, z) %>% filter(n>1)

# 3.
# Batting <-> Master matched on playerID
# Batting <-> Salaries matched on year, playerID, teamID
# Salaries <-> Master matched on playerID

# Managers <-> Master on playerID, teamID
# Managers <-> AwardsManagers on yearID
# AwardsManagers <-> Master on yearID



# 13.4.6 Exercises
# 1.

airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

avg_delay <-
  flights %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c(dest = "faa"))

avg_delay %>%
  ggplot(aes(lon, lat, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 2.
flights %>% left_join(airports, by = c(dest = "faa"))
flights %>%  left_join(airports, by = c(origin = "faa"))

# 3. Slight affect of age on delay
age_of_plane <- planes %>%
  mutate(age = 2017 - year) %>%
  select(tailnum, age)

flights1 <- flights %>%
  inner_join(age_of_plane, by = "tailnum") %>%
  group_by(age) %>%
  filter(!is.na(dep_delay)) %>%
  summarise(delay = mean(dep_delay))

lm1 <- lm(delay ~ age, data = flights1)
summary(lm1)

# 4.Greater precipitation increases delays
flights_weather <- flights %>%
  inner_join(weather, by = c("origin" = "origin", "year" = "year", "month" = "month", "day" = "day",
    "hour" = "hour"))

fw1 <- flights_weather %>%
  group_by(precip) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE))

lm2 <- lm(delay ~ precip, data = fw1)
summary(lm2)

# 5.derecho series
avg_delay2 <-
  flights %>%
  filter(year == 2013, month == 6, day == 13) %>% 
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c(dest = "faa"))

avg_delay2 %>%
  ggplot(aes(lon, lat, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()



# 13.5.1 Exercises
# 1. MQ and AA have many missing tailnums. It is likely they do not report this field in the normal way.
flights %>% anti_join(planes, by = "tailnum") %>% count(carrier, sort = TRUE)

# 2.
planes_sub <- flights %>%
  group_by(tailnum) %>%
  count() %>%
  filter(n > 100)

# 3.
vehicles %>% semi_join(common, by = c("make", "model"))

# 4.
delay_flights <- flights %>% 
  group_by(year, month, day, hour) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% 
  arrange(desc(delay)) %>% 
  head(48)

weather_sub <-
  delay_flights %>%
  inner_join(weather, by = c("year" = "year", "month" = "month", "day" = "day"))


# 5.
# Flights that don't have an faa dest
anti_join(flights, airports, by = c("dest" = "faa"))
# Dest airports w/o flight data
anti_join(airports, flights, by = c("faa" = "dest"))

# 6. Indeed, tailnum + carrier is a unique key
flights %>% 
  group_by(tailnum, carrier) %>%
  count() %>%
  filter(n() > 1)
