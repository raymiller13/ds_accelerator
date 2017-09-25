# 2017 DS Accelerator Phase One Work
# Ray Miller
# 09/17/2017

library(tidyverse)
library(nycflights13)
library(ggstance)
library(lvplot)
library(hexbin)

# Chapter 3 Reading
# ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

# Alpha aesthetic scales by transparency, shape, size -- dangerous is var is unranked
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Facet wrapping/grid
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ class, nrow = 3)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)

#Different ggplot2 geoms and multiple geoms, aesthetics in a single plot
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point(mapping = aes(color = class)) + geom_smooth()

#Bar plots
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + geom_col(mapping = aes(x = cut, y=price))
ggplot(data = diamonds) + stat_summary(mapping = aes(x = cut, y = depth), fun.ymin = min, fun.ymax = max, 
  fun.y = median)

# Flip the axes to make the labels easier to read
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + geom_boxplot() + coord_flip()

# ggplot2 template
# ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(
#    mapping = aes(<MAPPINGS>),
#    stat = <STAT>, 
#   position = <POSITION>
#  ) +
#  <COORDINATE_FUNCTION> +
#  <FACET_FUNCTION>




























# 3.2.4 Questions
# 1. I see a blank gray screen because we haven't plotted any points.
ggplot(data = mpg)

# 2. There are 234 rows in mpg. There are 11 columns in mpg.
nrow(mpg)
ncol(mpg)
View(mpg)

# 3. The drv variable refers to the wheel drive type of each vehicle, where:
#    "f = front-wheel drive, r = rear wheel drive, 4 = 4wd"
?mpg

# 4. hwy vs cyl plot
ggplot(data = mpg) + geom_point(mapping = aes(x = cyl, y = hwy))

# 5. class vs drv: This plot is not useful because both variables are qualitative, there's no true scatter.
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = class))



# 3.3.1 Questions
# 1. You need to "set the aesthetic by name as an argument of your geom function"
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 2. There are 8 categorical variables: manufacturer, model, year, cyl, trans, drv, fl, class
#    There are 3 continuous variables: displ, cty, hwy (assuming that while only integers exist in this data set
#    gas mileage is a continuously measureable variable). 
#    This information can be seen using the functions below or through scatterplots.
?mpg
View(mpg)
sapply(mpg, class)

# 3. Color and size aesthetics can both be used with continuous variables, but shapes cannot (not enough shapes).
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, color = displ))
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, shape = displ))
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, size = displ))

# 4. All the aesthetics are applied simultaneously
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, color = class, size = class, shape = class))

# 5. "Use the stroke aesthetic to modify the width of the border" of a shape.
#    This can be used with continuous and categorical variables and all shapes in the shape aesthetic.
?geom_point
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, color = class, stroke = 1))
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, color = displ, stroke = 5))
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, shape = class, stroke = 2))

# 6. Using an aesthetic other than a variable name can create a boolean condition to categorize 
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy, color = c(displ < 3)))



# 3.5.1 Questions
# 1. It creates a chart for each different value contained in the facet function
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy)) + facet_wrap(~ displ, nrow = 3)

# 2. The empty cells represent where there are no combinations of the two variables
#    i.e. there are no cars in the data set with rear wheel drive and 4 or 5 cylinders 
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl)) + facet_grid(drv ~ cyl)

# 3. The period plots a chart for each different level of the variable defined in the facet function.
#    Where the period appears whether the variable in the facet function appears vertically or horizontally.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ .)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)

# 4. The advantage of faceting over the color aesthetic is that it is less crowded and allows you to view subsets
#    of the data more easily.It is more difficult to compare where the data is plotted relative to each other
#    when it is subsetted in this way. When there is a lot of data, faceting would be more useful because the plot
#    would likely get overcrowded and thus be uninterpretable. 
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ class, nrow = 2)


# 5.nrow: number of rows in the plot
#   ncol: number of columns
#   Scales, switch, strip.position, and shrink affect the axes of each panel. 
#   as.table and dir afect the position of the panels.
#   facet_grid doesn't have ncol or nrow because it automatically defines the dimensions of the grid
?facet_wrap

# 6. The dimensions of the computer screen tend to be wider horizontally, thus giving more space for each column.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(cyl ~ .)



# 3.6.1 Questions
# 1. Line chart: geom_smooth(); Boxplot: geom_boxplot; Histogram: geom_histogram(); Area: geom_area()
ggplot(data = mpg) + geom_smooth(mapping = aes(x = cty, y = hwy))
ggplot(data = mpg) + geom_boxplot(mapping = aes(x = class, y = hwy))
ggplot(data = mpg, aes(x = cty)) + geom_histogram()
ggplot(data = mpg, aes(x=hwy, fill=fl)) + geom_area(stat ="bin")

# 2. 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + geom_point() + geom_smooth(se = FALSE)

# 3. show.legend = FALSE hides the legend. Removing it adds the legend. This argument was used earlier in
#    the chapter where only one data series/group was used, so no clarification on bin was needed.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + geom_point(show.legend = FALSE) + geom_smooth(se = FALSE, show.legend = FALSE)

# 4. The se argument adds the confidence interval around the smoothed line(s)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + geom_point() + geom_smooth(se = TRUE)

# 5. No, the arguments for geom_point() and geom_smooth() end up being the same in both cases
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + geom_smooth()
ggplot() + geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 6. In order
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + geom_smooth(se = FALSE) #Top left
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, class=drv)) + geom_point() + geom_smooth(se = FALSE) #Top right
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color=drv)) + geom_point() + geom_smooth(se = FALSE) #Middle left
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color=drv)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy) ,se = FALSE) #Middle right
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color=drv, linetype = drv)) + geom_point() + 
  geom_smooth(se = FALSE) #Bottom left
ggplot(data = mpg, show.legend = TRUE) + geom_point(mapping = aes(x = displ, y = hwy, fill=drv, stroke = 2), 
  pch=21, color="white") #Bottom right



# 3.7.1 Questions
# 1. pointrange is the default geom associated with stat_summary()
ggplot(data = diamonds) + geom_pointrange(mapping = aes(x = cut, y = depth), stat = "summary",
  fun.ymin = min,fun.ymax = max,fun.y = median)

# 2. geom_bar is proportional to the frequency in the data set, geom_col is the sum
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + geom_col(mapping = aes(x = cut, y=price))

# 3. Each geom has a default stat and vice versa
# geom_area(), geom_histrogram() -- stat_bin()
# geom_bar() -- stat_count()
# geom_polygon() -- stat_density2d()
# geom_boxplot() -- stat_boxplot()
# geom_density() -- stat_density()
# geom_quantile() -- stat_quantile()

# 4.geom_smooth() computed variables: y = predict value; ymin = lower CI; ymax = upper CI; se = standard error
#   Arguments: mapping, data, position, method, formula, na.rm, geom, n

# 5. geom = 1/2/n 
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop.., group = "n"))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 2))



# 3.8.1 Questions

# 1. Because only integer values exist in the dataset for cty there are many overlapping values. Adding jitter can
#    help improve the plot.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_jitter()

# 2.The width parameter controls the amount of jitter present
?geom_jitter
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_jitter(width = .5)
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_jitter(width = 5)
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_jitter(width = 50) #most interesting but bad

# 3.geom_count() highlights overlapping values by having the size of the point correspond to the count of values
#   at that point. geom_jitter() adds randomness, so fewer points overlap.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_count()

# 4. Dodge is the default position adjustment for geom_boxplot()
?geom_boxplot
ggplot(data=mpg) + geom_boxplot(mapping = aes(x = fl, y = hwy), position = "dodge")
ggplot(data=mpg) + geom_boxplot(mapping = aes(x = fl, y = hwy))
# Not the same if you use another position argument
ggplot(data=mpg) + geom_boxplot(mapping = aes(x = fl, y = hwy), position = "fill")



# 3.9.1 Questions
# 1. Stacked pie chart using polar coordinates
ggplot(data=mpg) +geom_bar(mapping = aes(x=fl, y =..prop.., fill=class))
ggplot(data=mpg) +geom_bar(mapping = aes(x=fl, y =..prop.., fill=class)) + coord_polar()

# 2. Helps make figures more readable by adding axis labels, titles, etc
?labs()
ggplot(data=mpg) +geom_bar(mapping = aes(x=fl, y =..prop.., fill=class)) + labs(title = "Boom, it's a title!")

# 3. coord_map() takes into account the spherical surface of the earth in its 2d projection. 
#    coord_quickmap() is a quicker approximation that will not and only work best near the equator.
?coord_map
?coord_quickmap

# 4.As cty increases, hwy tends to increase -- positive correlation
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_abline() + coord_fixed()
# Without coord_fixed() the plot aspect ratio can be distorted, which may be an issue depending on what you want.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_abline()
# ?geom_abline() adds a diagonal line to the plot -- often used with linear regression for line of best fit
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + coord_fixed()



# 4.4 Questions
# 1. The variable names are different.

# 2. 
install.packages("tidyverse")
library(tidyverse)

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)

filter(diamonds, carat > 3)

# 3. Shows you all keyboard shortcuts; Help -> Keyboard shortcuts



# 5.2.4 Questions
# 1. Had an arrival delay of two or more hours
filter(flights, arr_delay >= 2)

# 2. Flew to Houston (IAH or HOU)
filter(flights, dest == "IAH" | dest == "HOU")

# 3. Were operated by United, American, or Delta
filter(flights, carrier %in% c("United", "American", "Delta"))

# 4. Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))

# 5. Arrived more than two hours late, but didn't leave late
filter(flights, arr_delay > 2 & dep_delay == 0)

# 6. Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 1 & abs(arr_time - sched_arr_time - dep_delay)> 30) 

# 7. Departed between midnight and 6am (inclusive)
filter(flights, (dep_time >= 0 & dep_time <= 360) | dep_time = 2400)

# 2. between(): shortcut for x >= left & x <= right
filter(flights, between(dep_time, 0, 360))

# 3. 8245 have a missing dep_time, arr_time, sched_dep_time, sched_arr_time, arr_delay, and dep_delay.
#    These are likely canceled flights.
filter(flights, (is.na(dep_time)) == 1)

# 4. NA evaluates to FALSE
NA ^ 0
NA | TRUE
FALSE & NA
TRUE & NA
NA

# 5.3.1 Questions
# 1. Sorting NAs to top
arrange(flights, desc(is.na(dep_time)))

# 2. Most delayed flights then sorted by which left earliest
arrange(flights, desc(dep_delay), dep_time)

# 3. Finding fastest flights
arrange(flights, abs(arr_time - dep_time))

# 4. Longest and shortest distances travelled
flights <- arrange(flights, desc(distance)) #longest
flights <- arrange(flights, distance) #shortest



# 5.4.1 Questions
# 1. select dep_time, dep_delay, arr_time, and arr_delay
select(flights, dep_time, dep_delay, arr_time, arr_delay) #and any other order
select(flights, c(arr_delay, dep_time, dep_delay, arr_time))
select(flights, matches("^dep|^arr"))

# 2. Repeated column name in select statement: the repeated column is ignored
select(flights, dep_time, dep_time, arr_time, arr_delay)

# 3. one_of() selects "variables in character vector", used here to select subset of columns defined in var variable.
?one_of()
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

# 4. Yes, it's somewhat surprising but shows that r is case-insensitive
select(flights, contains("TIME"))
select(flights, contains("time"))



# 5.5.2 Questions
# 1. 
flights_1<- mutate(flights, hour = dep_time %/% 100, minute = dep_time %% 100)
flights_1<- mutate(flights_1, dep_time_min = (60*hour + minute))

# 2. air_time is often different from arr_time - dep_time
flights_1 <- mutate(flights, atm = ((arr_time %/% 100)*60 + arr_time %% 100))
flights_2 <- mutate(flights_1, dtm = ((dep_time %/% 100)*60 + dep_time %% 100))
transmute(flights_2, air_time, thetime = (atm - dtm) %% (60*24) - air_time)

# 3. dep_delay = sched_dep_time - dep_time, however since both are in clock format, when the delay spans multiple
#    hours this can make the calculation incorrect.
thefirst <- head(select(flights, dep_time, sched_dep_time, dep_delay), 50)

# 4. In this instance, I was fine with the breaking ties using the default method equivalent to rank(ties.method = "min")
arrange(flights, desc(dep_delay))
?min_rank

# 5. Returns: "2  4  6  5  7  9  8 10 12 11" and a warning message because the vectors are of different lengths.
#    What's actually happening: (1+1) + (2+2) + (3+3) + (1+4) + (2+5) + ... + (1+10)
1:3 + 1:10

# 6.Trig fcns in R: cos(x), sin(x), tan(x), acos(x), asin(x), atan(x), atan2(y, x), cospi(x)
# , sinpi(x), tanpi(x)
??trig



# 5.6.7 Questions
# 1. Arrival delay is more meaningful -- people mainly care how late they are to their destination.
# Delay characteristics of a group of flights:
# 1) (dep_delay > 0)/# flights by carrier --> impact: likely to hurt image of carrier
# 2) (dep_delay > 0)/# flights by origin/dest --> impact: carriers may be less likely to airports that often have delays
# 3) (dep_delay > 120)/# flights --> impact: delays >2hrs are likely to havenegative business and connection implications
# 4) (dep_delay > 0)/# flights average vs holidays --> impact: could help airlines prepare and staff better for holidays
# 5) (dep_delay > 0)/# flights YoY comparison --> impact: shows whether airlines are getting better/worse at preventing delays

# 2.
not_cancelled %>% count(dest, na.rm = TRUE)
not_cancelled <- filter(flights, !is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% group_by(dest)  %>% tally()
not_cancelled %>% group_by(tailnum) %>% summarise(n = sum(distance))

# 3. Just using is.na(arr_delay) | is.na(dep_delay) is slightly suboptimal because an airline agent may not fill
#    this out sometimes, and we can still tell if the flight occured if arr_time is not null.
filter(flights,  (is.na(dep_delay) | is.na(arr_delay) ) & !is.na(arr_time))

# 4. Longer delays lead to more cancellations on average for a given day (positive correlation)
daily <- group_by(flights, year, month, day)
per_day   <- summarise(daily, flights = n(), avg_delay = mean(dep_delay, na.rm = TRUE), cancelled = sum(is.na(dep_delay)))
View(per_day)
ggplot(data = per_day) + geom_point(mapping = aes(x=avg_delay, y=cancelled))

# 5. F9 has the worst delays by dep_delay. It would be hard to separate bad airlines from bad airports given that
#    the type and number of flights by carrier through a given airport is nonrandom and thus difficult to compare.
flights %>% group_by(carrier) %>% summarise(mean(dep_delay, na.rm = TRUE), n())

# 6.sort: outputs in descending order of n. Could be used to quickly see the biggest marketing channel by order, etc.
?count



# 5.7.1 Questions
# 1. When combined with grouping, each function is acting on the grouped data instead of the original data

# 2.Flights that are delayed on the greatest percentage of their flights (0,1) range
flights_1 <- filter(flights, !is.na(dep_delay))
flights_1 %>% group_by(tailnum) %>% mutate(prop_delay = sum(ifelse(dep_delay > 0, 1, 0))/n()) %>% arrange(desc(prop_delay)) %>% select(tailnum, prop_delay)


# 3. Fly in the early morning to avoid delays.
hourly <- group_by(flights, hour)
summarise(hourly, mean(dep_delay, na.rm = TRUE))

# 4. 
destination <- group_by(flights, dest)
summarise(destination, sum(dep_delay, na.rm = TRUE))

theflights <- group_by(flights, flight)
theflights <- mutate(theflights, prop_delay = dep_delay/air_time)
View(theflights)

# 5. There is a positive correlation supporting the claim that the previous flight being delayed increases the 
#    expected delay of the next flight.
lm1 <- lm(lag(dep_delay) ~ dep_delay,  data = flights)
ggplot(data = flights, aes(dep_delay, lag(dep_delay))) + geom_point() + geom_smooth(method = "lm", se = FALSE)

# 6. Fastest flights that could represent data entry error
flights_1 <- mutate(flights, speed = (distance/air_time))
fast <- filter(flights_1, speed > 10)
View(fast)

# Most delayed flights in the air
flights_1 <- mutate(flights, change = arr_delay - dep_delay)
flights_1 <- select(flights_1, arr_delay, dep_delay, change)
arrange(flights_1, desc(change))

# 7. Carriers ranked by destinations flown to
flights %>% group_by(dest) %>% filter(n_distinct(carrier) > 1) %>% group_by(carrier) %>%
  summarise(dest_count = n_distinct(dest)) %>% arrange(desc(dest_count))

# 8. Plane 15 has the greatest number of flights without an hour delay or more
flights %>% group_by(flight) %>% filter(dep_delay < 60) %>% summarise(little_delay = n()) %>% arrange(desc(little_delay))



# 6.3 Questions -- resources looked at (#1, #2)



# 7.3.4 Questions
# 1. There is more variation in the y (max of 31.8) and z (max of 58.9) dimensions of the ring as compared to 
#    the x dimension.
?diamonds
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=x))
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=y))
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=z))

# 2. The histogram is not strictly downward sloping (like spike around $4k)
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=price), binwidth = 50)

# 3. Only 23 rings have .99 carats while 1558 have 1 carat. Since there is almost certainly no functional or
#    aesthetic difference, it is likely a marketing and consumer preference.
count(filter(diamonds, carat == .99))
count(filter(diamonds, carat == 1))

# 4. If binwidth is not set it defaults to 30. 
#    Warning when using xlim/ylim: "Warning: Ignoring unknown parameters: xlim"
#    When only part of the bin would be included, R extends the x-axis to include the entire bin
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=price))
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=price)) + coord_cartesian(ylim = c(0, 50))
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=price), xlim = c(0, 50))
ggplot(data = diamonds) + geom_histogram(mapping = aes(x=price)) + coord_cartesian(xlim = c(0, 15001))



# 7.4.1 Questions
# 1. Missing value in both a bar chart and histogram are omitted.
#    The difference stems from geom_histogram using stat_bin vs geom_bar using stat_count
ggplot(data = flights) + geom_histogram(mapping = aes(x=dep_delay))
ggplot(data = flights) + geom_bar(mapping = aes(x=dep_delay))

# 2. na.rm() omits all null values for the mean() and sum() functions.
sum(flights$dep_delay, na.rm = TRUE)



# 7.5.1.1 Questions
# 1. 
flights_1 <- mutate(flights, cancelled = ifelse(is.na(dep_delay) == TRUE, 1, 0))
ggplot(data = flights_1) + geom_bar(mapping = aes(x=cancelled))

# 2. Carat is most correlated with price
lm1 <- lm(price ~. , data = diamonds)
summary(lm1)
lm2 <- lm(carat ~ cut, data = diamonds)
summary(lm2)
levels(diamonds$cut)
# Slight negative correlation between carat and cut
ggplot(data=diamonds) + geom_boxplot(mapping=aes(cut, carat))
# Lower quality diamonds being more expensive may indicate that people care about size more than diamond quality.

# 3. No functional difference, the first below is quicker
ggplot(data=diamonds) + geom_boxploth(mapping=aes(carat, cut))
ggplot(aes(cut, carat), data=diamonds) + geom_boxplot() + coord_flip()

# 4. This helps show relative density of price better than a standard boxplot.
?geom_lv
ggplot(data=diamonds) + geom_lv(mapping=aes(cut, price))

# 5.
# Clear distributions of each cut. Difficult to interpret relative frequency.
ggplot(aes(cut, price), data=diamonds) + geom_violin()
# Easy to compare frequency by price and cut. Difficult to compare distributions by cut.
ggplot(aes(price), data=diamonds) + geom_histogram() + facet_wrap(~ cut)
# Gives you all the details of the distributions and makes it easy to compare although it can be messy.
ggplot(aes(price), data=diamonds) + geom_freqpoly(aes(color = cut))

# 6. Each of the methods in ggbeeswarm introduce randomness to prevent overplotting in slightly different ways.



# 7.5.2 Questions
# 1. Using percentages
diamonds %>% count(color, cut) %>% group_by(color) %>% mutate(percent = n / sum(n)) %>% 
  ggplot(mapping = aes(x = color, y = cut)) + geom_tile(mapping = aes(fill = percent))

# 2. There are too many destinations. You could look at only a few destinations at once.
ggplot(mapping = aes(x = dest, y = month, fill = dep_delay), data=flights) + geom_tile()

# 3. There are more levels of the category variable, which means it should be on the x-axis because of the
#    dimensions of most monitors.



# 7.5.3.1 Questions
# 1. cut_width() defines the range while cut_number() defines the number of intervals. The grouping of the 
#    variable changes drastically depending on how you set it.
ggplot(data = diamonds) +geom_hex(mapping = aes(x = cut_number(carat, 10), y = price))
ggplot(data = diamonds) +geom_hex(mapping = aes(x = cut_number(carat, 20), y = price))
ggplot(data = diamonds) +geom_hex(mapping = aes(x = cut_width(carat, 10), y = price))
ggplot(data = diamonds) +geom_hex(mapping = aes(x = cut_width(carat, 20), y = price))

# 2. 
ggplot(data = diamonds) +geom_hex(mapping = aes(x = cut_width(carat, 5), y = price))

# 3. It makes sense that there is a tighter distribution for large diamonds given that very few will be cheap.
ggplot(data = diamonds) +geom_hex(mapping = aes(x = cut_width(carat, 4), y = price))

# 4. 
ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price, fill=cut))

# 5. It's easier to see outlying data in a scatterplot.