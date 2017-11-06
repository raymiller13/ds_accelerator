# DSA Month 2 Week 2 Exercises
Ray Miller  
November 5, 2017  



### 28.2.1 Exercises
1. Fuel economy data plot with a title, subtitle, caption, x, y, and color labels  

```r
library(ggplot2)
ggplot(data = mpg, aes(x = displ, y = cty, color = class)) + geom_point() + labs(title = "City Fuel Economy By Engine Displacement", x = "Engine Displacement (L)", y = "City Fuel Economy (mpg)", subtitle = "Colored by Car Type", color = "Car Type", caption = "Data from fueleconomy.gov")
```

![](m2w2_work_files/figure-html/unnamed-chunk-1-1.png)<!-- -->



2. Using linear lines of best fit faceted by Car Type  

```r
ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_smooth(se = FALSE, method = "lm") + facet_grid(class ~ .) + labs(title = "Highway mileage by Engine Displacement") 
```

![](m2w2_work_files/figure-html/unnamed-chunk-2-1.png)<!-- -->



3. Exploratory graphic with titles  

```r
ggplot(data = mpg, aes(cty, hwy)) + geom_point() + geom_smooth(method = "lm") + labs(title = "Relationship Between Highway and City Fuel Economy", x = "City Fuel Economy (mpg)", y = "Highway Fuel Economy (mpg)")
```

![](m2w2_work_files/figure-html/unnamed-chunk-3-1.png)<!-- -->


### 28.3.1 Exercises  
1. Labels in each corner.  

```r
library(tidyverse)
tllabel <- tibble(displ = -(Inf), hwy = Inf, label = "Top Left")
trlabel <- tibble(displ = Inf, hwy = Inf, label = "Top Right")
bllabel <- tibble(displ = -(Inf), hwy = -(Inf), label = "Bottom Left")
brlabel <- tibble(displ = Inf, hwy = -(Inf), label = "Bottom Right")
ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_text(aes(label = label), data = trlabel, vjust = "top", hjust = "right") + geom_text(aes(label = label), data = tllabel, vjust = "top", hjust = "left") + geom_text(aes(label = label), data = brlabel, vjust = "bottom", hjust = "right") + geom_text(aes(label = label), data = bllabel, vjust = "bottom", hjust = "left") 
```

![](m2w2_work_files/figure-html/unnamed-chunk-4-1.png)<!-- -->



2. Take your current plot and add an annotate call to a particular point you want: current_plot + annotate("text", x = 4, y = 25, label = "Some text")   



3. Labels are added to each facet. 

```r
trlabel <- tibble(displ = Inf, hwy = Inf, label = "Top Right")
ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_smooth(se = FALSE, method = "lm") + facet_grid(class ~ .) + geom_text(aes(label = label), data = trlabel, vjust = "top", hjust = "right")
```

![](m2w2_work_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
label <- tibble(displ = Inf, hwy = Inf, label = "Top Right", class = "compact")
ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point() + facet_wrap(~ class) + geom_text(aes(label = label), data = label, vjust = "top", hjust = "right", size =3)
```

![](m2w2_work_files/figure-html/unnamed-chunk-5-2.png)<!-- -->

```r
label <- tibble(displ = Inf, hwy = Inf, label = unique(mpg$class), class = c("2seater", "compact", "midsize", "minivan", "pickup", "subcompact", "suv"))
ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point() + facet_wrap(~ class) + geom_text(aes(label = label), data = label, vjust = "top", hjust = "right", size =3)
```

![](m2w2_work_files/figure-html/unnamed-chunk-5-3.png)<!-- -->


4. The fill aesthetic.  

```r
ggplot(data = mpg, aes(x = displ, y = hwy, label = rownames(mpg))) + geom_label(aes(fill = factor(class)))
```

![](m2w2_work_files/figure-html/unnamed-chunk-6-1.png)<!-- -->


5. Arrow arguments: angle, length, ends, type  

```r
ggplot(data = mpg, aes(x = displ, y = hwy, label = rownames(mpg))) + geom_label(aes(fill = factor(class))) + geom_curve(aes(x = 2, y = 40, xend = 5, yend = 42), data = mpg, arrow = arrow(length = unit(.1, "npc"), type = "closed"))
```

![](m2w2_work_files/figure-html/unnamed-chunk-7-1.png)<!-- -->


### 28.4.4 Exercises  
1. Fill, not color, changes the gradient for hex plots  

```r
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)
ggplot(df, aes(x, y)) + geom_hex() + scale_fill_gradient(low = "white", high = "red") +coord_fixed()
```

![](m2w2_work_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


2. The first argument to any scale function is the name/title. Scales and labs are equivalent.  


3. Changed Presidential plot.   

```r
library(lubridate)

years <- make_date(seq(year(min(presidential$start)),
              year(max(presidential$end)), by = 4), 1, 1)

presidential %>%
  mutate(id = 33 + row_number(), 
         name_id = stringr::str_c(name, " ", id), 
         pres_num = factor(name_id, levels = name_id)) %>%
  ggplot(aes(start, pres_num, colour = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = pres_num)) +
  scale_colour_manual(values = c(Republican = "red", Democratic = "blue")) + 
  labs(x = "Year", y = "President Name and Number", title = "Plot of Each President's Term By Party Post WWII") + 
  scale_x_date(breaks = years, date_labels = "%Y")
```

![](m2w2_work_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

4. Color of cut labels changed to have no transparency.   

```r
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(colour = cut), alpha = 1/20) + 
  guides(colour = guide_legend(override.aes = list(alpha = 1)))
```

![](m2w2_work_files/figure-html/unnamed-chunk-10-1.png)<!-- -->
