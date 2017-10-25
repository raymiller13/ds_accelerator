# Ray Miller
# DSA Phase Two Week 4 Exercises
# 10/22/2018
library(tidyverse)
library(lubridate)
library(nycflights13)


# Chap 16 Reading
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute)) %>% glimpse()


make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

with_tz(now(), tzone = "Australia/Lord_Howe")


# 16.2.4 Exercises
# 1. If the string contains invalid dates, it will fail to be parsed and return an NA value.
ymd(c("2010-10-10", "bananas"))

# 2. It changes the date to the timezone specified. It's important to use timezones to ensure you're correctly 
#    understanding DoW/ToD performance results. For example, this would matter in the Apple Music context when
#    determining which days/hours to bid up for specific audience groups. Since our Facebook account is in the
#    "America/New York" timezone and other data is in UTC, without careful analysis we can mislead ourselves.
today()
today(tzone = "Pacific/Auckland")

# 3.
d1 <- "January 1, 2010"
mdy(d1)
d2 <- "2015-Mar-07"
ymd(d2)
d3 <- "06-Jun-2017"
dmy(d3)
d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)
d5 <- "12/30/14" 
mdy(d5)



# 16.3.4 Exercises
# 1.
flights_dt %>% 
  mutate(hour_min = hour(dep_time) * 100 + minute(dep_time), month_num = as.factor(month(dep_time))) %>% 
ggplot(aes(x = hour_min, group = month_num, color = month_num)) +
  geom_freqpoly(binwidth = 100)
  
# 2.Not entirely, 1205 observations have a dep_delay that is not equal to the difference between their scheduled delay and dep_time
flights_dt %>% 
  mutate(diff = (dep_time - sched_dep_time)/60) %>% 
  filter(dep_delay != (dep_time - sched_dep_time)/60) %>% glimpse

# 3. Air_time almost always varies from arr_time - dep_time
nrow(flights_dt)

flights_dt %>% 
  mutate(diff = (arr_time - dep_time)) %>% 
  filter(air_time != (arr_time - dep_time)) %>% glimpse

# 4. Use sched_dep_time since this will tell us most about how one should book flights to avoid delays.
flights_dt %>% 
  group_by(hour_sched_dep_time = hour(sched_dep_time)) %>%
  summarise(hourly_delay_mean = mean(dep_delay)) %>% 
  ggplot(aes(x = hour_sched_dep_time, y = hourly_delay_mean)) +
  geom_point() + geom_smooth()

# 5.There are multiple ways to interpret this question, but the below shows that Saturday in fact has the lowest 
#   percentage of delayed flights (dep_delay > 0).
flights_dt %>% 
  mutate(delayed_num = ifelse(dep_delay>0, 1, 0)) %>%
  group_by(dow = weekdays(flights_dt$sched_dep_time)) %>% 
  summarise(sum(delayed_num)/n())

# 6.Both suffer from recording or scheduling bias at intervals that people like (rounded values).
ggplot(diamonds, aes(x = carat)) + geom_density()

flights_dt %>% 
  mutate(hour_min = hour(dep_time) * 100 + minute(dep_time)) %>% 
  ggplot(aes(x = hour_min)) + geom_density()

# 7. The highest proportion of early flights leaving early do appear in those intervals.
flights_dt %>% 
  mutate(is_delayed = ifelse(dep_delay<0, 1, 0), min_interval = minute(sched_dep_time) %% 10) %>% 
  group_by(min_interval) %>% 
  summarise(sum(is_delayed)/n(), n())



# 16.4.5 Exercises
# 1.Months simply extracts the month from a date/datetime. There is no dmonths() because the number of days/hours 
#   varies by month and year. However, it seems that you should still be able to account for this since dyears exists.
#   An alternative hypothesis may be, that the authors of the lubridate package felt a dmonths() function would make
#   code more ambiguous and instead wanted people to be more explicit with the interval they wanted (ie using ddays() instead).

# 2. Pseudocode: If it is an overnight flight (arrival time before departure time), then add a day, else do nothing.

# 3.
dates <- ymd('2015-01-01') + months(0:11)
dates_2017 <- ymd('2017-01-01') + months(0:11)

# 4.
diff <- now()- as.POSIXct('1994-04-13')
as.duration(diff) %/% as.duration(years(1))

# 5.Seems to work the same way
(today() %--% (today() + years(1)) / months(1))
((as.POSIXct('1994-04-13') %--% today()) %/% years(1))
