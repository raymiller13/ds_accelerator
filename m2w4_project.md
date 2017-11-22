# dsa_m2w4_project
Ray Miller  
November 21, 2017  


## Summary
The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999-2008. This goal was achieved mostly through exploratory plots, though simple linear models were used to examine general trends over this time period.


## Load, glimpse, and combine data


```r
# Loading data
NEI <- readRDS("summarySCC_PM25.rds")
# Option.Group, Option.Set Created_Date, Revised_Date, Usage.Notes have blank values not listed as NA
# Map.To and Last.Inventory.Year have sparse data (missing values are correctly marked as NA)
SCC <- readRDS("Source_Classification_Code.rds")
SCC$SCC <- as.character(SCC$SCC) 

# Check out the data
glimpse(NEI)
```

```
## Observations: 6,497,651
## Variables: 6
## $ fips      <chr> "09001", "09001", "09001", "09001", "09001", "09001"...
## $ SCC       <chr> "10100401", "10100404", "10100501", "10200401", "102...
## $ Pollutant <chr> "PM25-PRI", "PM25-PRI", "PM25-PRI", "PM25-PRI", "PM2...
## $ Emissions <dbl> 15.714, 234.178, 0.128, 2.036, 0.388, 1.490, 0.200, ...
## $ type      <chr> "POINT", "POINT", "POINT", "POINT", "POINT", "POINT"...
## $ year      <int> 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999...
```

```r
glimpse(SCC)
```

```
## Observations: 11,717
## Variables: 15
## $ SCC                 <chr> "10100101", "10100102", "10100201", "10100...
## $ Data.Category       <fctr> Point, Point, Point, Point, Point, Point,...
## $ Short.Name          <fctr> Ext Comb /Electric Gen /Anthracite Coal /...
## $ EI.Sector           <fctr> Fuel Comb - Electric Generation - Coal, F...
## $ Option.Group        <fctr> , , , , , , , , , , , , , , , , , , , , ,...
## $ Option.Set          <fctr> , , , , , , , , , , , , , , , , , , , , ,...
## $ SCC.Level.One       <fctr> External Combustion Boilers, External Com...
## $ SCC.Level.Two       <fctr> Electric Generation, Electric Generation,...
## $ SCC.Level.Three     <fctr> Anthracite Coal, Anthracite Coal, Bitumin...
## $ SCC.Level.Four      <fctr> Pulverized Coal, Traveling Grate (Overfee...
## $ Map.To              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ Last.Inventory.Year <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ Created_Date        <fctr> , , , , , , , , , , , , , , , , , , , 6/6...
## $ Revised_Date        <fctr> , , , , , , , , , , , , , , , , , , , , ,...
## $ Usage.Notes         <fctr> , , , , , , , , , , , , , , , , , , , , ,...
```

```r
# Joining tables: because the dataframes joined using a left and semi join are the same, we know every
# row in NEI is properly matched to SCC
combined <- left_join(NEI, SCC, by = "SCC")
glimpse(combined)
```

```
## Observations: 6,497,651
## Variables: 20
## $ fips                <chr> "09001", "09001", "09001", "09001", "09001...
## $ SCC                 <chr> "10100401", "10100404", "10100501", "10200...
## $ Pollutant           <chr> "PM25-PRI", "PM25-PRI", "PM25-PRI", "PM25-...
## $ Emissions           <dbl> 15.714, 234.178, 0.128, 2.036, 0.388, 1.49...
## $ type                <chr> "POINT", "POINT", "POINT", "POINT", "POINT...
## $ year                <int> 1999, 1999, 1999, 1999, 1999, 1999, 1999, ...
## $ Data.Category       <fctr> Point, Point, Point, Point, Point, Point,...
## $ Short.Name          <fctr> Ext Comb /Electric Gen /Residual Oil /Gra...
## $ EI.Sector           <fctr> Fuel Comb - Electric Generation - Oil, Fu...
## $ Option.Group        <fctr> , , , , , , , , , , , , , , , , , , , , ,...
## $ Option.Set          <fctr> , , , , , , , , , , , , , , , , , , , , ,...
## $ SCC.Level.One       <fctr> External Combustion Boilers, External Com...
## $ SCC.Level.Two       <fctr> Electric Generation, Electric Generation,...
## $ SCC.Level.Three     <fctr> Residual Oil, Residual Oil, Distillate Oi...
## $ SCC.Level.Four      <fctr> Grade 6 Oil: Normal Firing, Grade 6 Oil: ...
## $ Map.To              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ Last.Inventory.Year <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ Created_Date        <fctr> , , , , , , , , , , , , , , , , , , , , ,...
## $ Revised_Date        <fctr> , , , , , , , , , , , , , , , , , , , , ,...
## $ Usage.Notes         <fctr> , , , , , , , , , , , , , , , , , , , , ,...
```

```r
nrow(combined)
```

```
## [1] 6497651
```


## Plot 1  
Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.


```r
# Eliminating any rows without an emissions measurement as a precaution and simplifying the data for this plot. I made a separate data frame for each plot, so that I could always have the flexibility of changing the data frame without affecting multiple plots.
summed <- combined %>% 
  filter(!is.na(Emissions)) %>% 
  transmute(year, Emissions = Emissions/1000000) %>% 
  group_by(year) %>%
  summarise(summed_emissions = sum(Emissions))

# Linear model showing how emissions change as a function of year
lm1 <- lm(summed_emissions ~ year, data = summed)
# Intercept = 793; slope = -.393
summary(lm1)
```

```
## 
## Call:
## lm(formula = summed_emissions ~ year, data = summed)
## 
## Residuals:
##        1        2        3        4 
##  0.09295 -0.42550  0.57216 -0.23960 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)  
## (Intercept) 792.67111  160.06650   4.952   0.0384 *
## year         -0.39291    0.07989  -4.918   0.0389 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.5359 on 2 degrees of freedom
## Multiple R-squared:  0.9236,	Adjusted R-squared:  0.8854 
## F-statistic: 24.19 on 1 and 2 DF,  p-value: 0.03895
```

```r
plot(x = summed$year, y = summed$summed_emissions, col = "Dark Red", main = "Total PM2.5 Emissions in the U.S. By Year", sub = "Emissions decreased in the U.S. from 1999 to 2008 in each year measurements were taken", xlab = "Year", ylab = "Emissions  (Megatons)", pch = 19, lwd = 8)
lines(x = summed$year, y = summed$summed_emissions, lwd = 2)
arrows(x0 = 1999, x1 = 2008, y0 = (lm1$coefficients[1]+lm1$coefficients[2]*1999), y1 = (lm1$coefficients[1]+lm1$coefficients[2]*2008),  lwd = 1, col = "Dark Gray", length = .15)
```

![](m2w4_project_files/figure-html/chunk - Plot 1 (Total U.S. Emissions Trends)-1.png)<!-- -->


## Plot 2
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.


```r
summed_Baltimore <- combined %>% 
  filter(!is.na(Emissions)) %>% 
  filter(fips == '24510') %>% 
  transmute(year, Emissions = Emissions/1000) %>% 
  group_by(year) %>%
  summarise(summed_emissions = sum(Emissions), median_emissions = median(Emissions))

# Linear model showing how emissions change as a function of year
lm2 <- lm(summed_emissions ~ year, data = summed_Baltimore)
# Intercept = 24.297404; slope = -0.011994
summary(lm2)
```

```
## 
## Call:
## lm(formula = summed_emissions ~ year, data = summed_Baltimore)
## 
## Residuals:
##        1        2        3        4 
##  0.06401 -0.39643  0.60083 -0.26841 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)
## (Intercept) 242.97404  162.80655   1.492    0.274
## year         -0.11994    0.08126  -1.476    0.278
## 
## Residual standard error: 0.5451 on 2 degrees of freedom
## Multiple R-squared:  0.5214,	Adjusted R-squared:  0.2821 
## F-statistic: 2.179 on 1 and 2 DF,  p-value: 0.2779
```

```r
plot(x = summed_Baltimore$year, y = summed_Baltimore$summed_emissions, col = "Purple", main = "Total PM2.5 Emissions By Year in Baltimore City", xlab = "Year", ylab = "Emissions  (Kilotons)", pch = 19, lwd = 8)

lines(x = summed_Baltimore$year, y = summed_Baltimore$summed_emissions, lwd = 2)

arrows(x0 = 1999, x1 = 2008, y0 = (lm2$coefficients[1]+lm2$coefficients[2]*1999), y1 = (lm2$coefficients[1]+lm2$coefficients[2]*2008),  lwd = 1, col = "Dark Gray", length = .15)
```

![](m2w4_project_files/figure-html/chunk - Plot 2a (Baltimore City Total Emissions Trends)-1.png)<!-- -->

While emissions in Baltimore City generally fell from 1999 to 2008, emissions rose from 2002 levels in 2005.



```r
summed_Baltimore <- combined %>% 
  filter(!is.na(Emissions)) %>% 
  filter(fips == '24510') %>% 
  transmute(year, Emissions = Emissions) %>% 
  group_by(year) %>%
  summarise(summed_emissions = sum(Emissions), median_emissions = median(Emissions))

# Linear model of median emissions as a function of year
lm3 <- lm(median_emissions ~ year, data = summed_Baltimore)
# Intercept = 4.719034; slope = -0.011994
summary(lm3)
```

```
## 
## Call:
## lm(formula = median_emissions ~ year, data = summed_Baltimore)
## 
## Residuals:
##         1         2         3         4 
##  0.061328 -0.088164 -0.007656  0.034492 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept) 47.19034   23.87672   1.976    0.187
## year        -0.02350    0.01192  -1.972    0.187
## 
## Residual standard error: 0.07994 on 2 degrees of freedom
## Multiple R-squared:  0.6604,	Adjusted R-squared:  0.4906 
## F-statistic: 3.889 on 1 and 2 DF,  p-value: 0.1874
```

```r
# Linear model of median emissions as a function of year for 2002-2008
lm4 <- lm(median_emissions ~ year, data = summed_Baltimore[2:4,])
# Intercept = 0.6182246; slope = -0.0003060
summary(lm4)
```

```
## 
## Call:
## lm(formula = median_emissions ~ year, data = summed_Baltimore[2:4, 
##     ])
## 
## Residuals:
##         1         2         3 
## -0.006393  0.012786 -0.006393 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)
## (Intercept)  6.182246   7.400693   0.835    0.557
## year        -0.003060   0.003691  -0.829    0.559
## 
## Residual standard error: 0.01566 on 1 degrees of freedom
## Multiple R-squared:  0.4073,	Adjusted R-squared:  -0.1854 
## F-statistic: 0.6872 on 1 and 1 DF,  p-value: 0.5594
```

```r
plot(x = summed_Baltimore$year, y = summed_Baltimore$median_emissions, col = "Purple", main = "Median PM2.5 Emissions By Year in Baltimore City", xlab = "Year", ylab = "Emissions  (Tons)", pch = 19, lwd = 8, ylim = c(0,.3))

lines(x = summed_Baltimore$year, y = summed_Baltimore$median_emissions*1000, lwd = 2)

arrows(x0 = 1999, x1 = 2008, y0 = (lm3$coefficients[1]+lm3$coefficients[2]*1999), y1 = (lm3$coefficients[1]+lm3$coefficients[2]*2008),  lwd = 2, col = "Dark Green", length = .15)

arrows(x0 = 1999, x1 = 2008, y0 = (lm4$coefficients[1]+lm4$coefficients[2]*1999), y1 = (lm4$coefficients[1]+lm4$coefficients[2]*2008),  lwd = 2, col = "Red", length = .15)
```

![](m2w4_project_files/figure-html/chunk - Plot 2b (Baltimore City Median Emissions Trends)-1.png)<!-- -->

In the above plot, the green line shows the downward trend in Baltimore City median emissions with all data included. However, from only including data from 2002 onward, the red line shows a flat trend for median emissions. Looking at this view, one can argue that the most progess was made between 1999 and 2002.


## Plot 3
Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.


```r
summed_type<- combined %>% 
  filter(!is.na(Emissions)) %>% 
  filter(fips == '24510') %>%
  transmute(year, Emissions, type) %>% 
  group_by(year, type) %>%
  summarise(summed_emissions = sum(Emissions), median_emissions = median(Emissions))

# Make type a factor and reorder in order that they'll appear vertically on the plot
summed_type$type <- as.factor(summed_type$type)
summed_type$type <- factor(summed_type$type, levels=c("NONPOINT","POINT","NON-ROAD", "ON-ROAD"))

ggplot(data = summed_type, mapping = aes(x = year, y = summed_emissions, group = type, color = type)) + 
  geom_line(size = 1) + geom_point(size = 2) + labs(title = "Total Emissions By Type of Source in Baltimore City 1999-2008", caption = "Looking at emissions by type of source, we see that Point \nsources were the cause of the 2005 spike in emissions.") + ylab("Total Emissions  (tons)") + xlab("Year") 
```

![](m2w4_project_files/figure-html/chunk - Plot 3 (Total Emissions By Type of Source in Baltimore City)-1.png)<!-- -->


## Plot 4
Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?


```r
summed_coal <- combined %>% 
  filter(!is.na(Emissions)) %>%
  filter(grepl("Coal", Short.Name) | grepl("coal", Short.Name)) %>% 
  transmute(year, Emissions = Emissions/1000000) %>% 
  group_by(year) %>%
  summarise(summed_emissions = sum(Emissions), median_emissions = median(Emissions))

ggplot(data = summed_coal, mapping = aes(x = year, y = summed_emissions)) + geom_point(size = 4) +
  geom_line(size = 1.5) + labs(title = "Total Emissions From Coal Sources in The U.S. 1999-2008", caption = "Emissions from Coal Sources have generally been decreasing in the U.S., especially since 2005") + ylab("Total Emissions  (Megatons)") + xlab("Year") + geom_smooth(method='lm', se = FALSE, col = "darksalmon")
```

![](m2w4_project_files/figure-html/chunk - Plot 4 (U.S. Emissions Trends From Coal Sources)-1.png)<!-- -->


## Plot 5
How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?    

** Note that motor vehicles are defined as all "ON-ROAD" types of sources. "NON-ROAD" sources such as emissions from construction and lawncare equipment are not included in this. **

```r
summed_vehicle <- combined %>% 
  filter(!is.na(Emissions) & fips == '24510' & type == 'ON-ROAD') %>% 
  transmute(year, Emissions) %>% 
  group_by(year) %>%
  summarise(summed_emissions = sum(Emissions), median_emissions = median(Emissions))

# Total
ggplot(data = summed_vehicle, mapping = aes(x = year, y = summed_emissions)) + geom_point(size = 4) +
  geom_line(size = 1.5) + labs(title = "Total Emissions From Motor Vehicles in Baltimore City 1999-2008", 
                             caption = "Though total motor vehicle emissions are trending downward, the most progress was made between 1999 and 2002") + 
  ylab("Total Emissions  (tons)") + xlab("Year") + geom_smooth(method='lm', se = FALSE, col = "darksalmon")
```

![](m2w4_project_files/figure-html/chunk - Plot 5 (Total and Median Emission Trends in Baltimore City From Motor Vehicles)-1.png)<!-- -->

```r
# Median
ggplot(data = summed_vehicle, mapping = aes(x = year, y = median_emissions)) + geom_point(size = 4) +
  geom_line(size = 1.5) + labs(title = "Total Emissions From Motor Vehicles in Baltimore City 1999-2008", 
                             caption = "Median emissions are even more concerning, trending upward since 2002") + 
  ylab("Median Emissions  (tons)") + xlab("Year") + geom_smooth(method='lm', se = FALSE, col = "darksalmon")
```

![](m2w4_project_files/figure-html/chunk - Plot 5 (Total and Median Emission Trends in Baltimore City From Motor Vehicles)-2.png)<!-- -->


## Plot 6
Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

** Note that motor vehicles are defined as all "ON-ROAD" types of sources. "NON-ROAD" sources such as emissions from construction and lawncare equipment are not included in this. **


```r
summed_bl_la <- combined %>% 
  filter(!is.na(Emissions) & (fips == '24510' | fips == '06037') & type == 'ON-ROAD') %>% 
  transmute(year, Emissions = Emissions/1000, fips) %>% 
  group_by(year, fips) %>%
  summarise(summed_emissions = sum(Emissions), median_emissions = median(Emissions))

ggplot(data = summed_bl_la, mapping = aes(x = year, y = summed_emissions, group = fips, color = fips)) + 
  geom_line(size = 1) + labs(title = "Total Motor Vehicle Emissions in LA County (06037) & Baltimore City \n(24510) 1999-2008", caption = "Data from measurements in 1999,2002, 2005, and 2008", color = "Measurement Location", subtitle = "Emissions in LA rose 4% from 1999-2008. This is very different from the 75% Drop in Emissions \nSeen in Baltimore City.") + ylab("Total Emissions  (Kilotons)") + xlab("Year") + scale_color_hue(labels = c("LA County", "Baltimore City"))
```

![](m2w4_project_files/figure-html/chunk - Plot 6 (Motor Vehicle Emissions Trends in Baltimore City and LA County)-1.png)<!-- -->

```r
# Seeing drop from 1999 to 2008
(max(summed_bl_la$summed_emissions[summed_bl_la$fips == '06037' & summed_bl_la$year == '2008']) - 
    max(summed_bl_la$summed_emissions[summed_bl_la$fips == '06037' & summed_bl_la$year == '1999']))/
  max(summed_bl_la$summed_emissions[summed_bl_la$fips == '06037' & summed_bl_la$year == '1999'])
```

```
## [1] 0.0432958
```

```r
(max(summed_bl_la$summed_emissions[summed_bl_la$fips == '24510' & summed_bl_la$year == '2008']) - 
    max(summed_bl_la$summed_emissions[summed_bl_la$fips == '24510' & summed_bl_la$year == '1999']))/
  max(summed_bl_la$summed_emissions[summed_bl_la$fips == '24510' & summed_bl_la$year == '1999'])
```

```
## [1] -0.7454718
```
