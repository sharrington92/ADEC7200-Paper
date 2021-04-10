---
title: "Royal Dutch Shell:"
subtitle: "A Macroeconomic Analysis"
author: "Shaun Harrington"
date: "4/7/2021"
output: 
  word_document: 
    reference_docx: word-styles-reference-01.docx
    fig_width: 8
    fig_height: 5
    keep_md: true
---





# Royal Dutch Shell: A Macroeconomic Analysis

#### Motivation

  Royal Dutch Shell is a international company that spans the entire globe. As such, it is subject to several macroeconomic variables throughout numerous countries. Due to COVID-19, we have seen considerable fluctuations in the macroeconomy.

[Insert discussion of change in macroeconomic indicators over past year]

  As numerous macroeconomic indicators are highly correlated with revenues, such as the price of a barrel of oil, the net financial impact is exposed to these uncontrollable variables. By understanding the impacts, measures can be taken to mitigate the impact of changes to the macroeconomy.
  
  Royal Dutch Shell (RDS) segments revenue streams by region. Those being the United States, Europe, Other Americas, and Asia/Oceania/Africa. In 2019, the distribution of revenues were: 24% in the US, 29% in Europe, 7% in Other Americas, and 41% in Asia/Oceania/Africa. See below for a chart of revenues by region:
  
  
 <br>
 
 

```r
rev %>% 
  filter(Year > 2007, Year < 2020) %>% 
  ggplot(aes(x = Year, y = Revenue, color = Region)) +
  geom_line(size = 1) +
  ggtitle("Regional Revenues", "Royal Dutch Shell") +
  ylab("(In Millions of Dollars)") +
  xlab("") +
  scale_x_continuous(n.breaks = 10, limits = c(2008, 2019)) +
  scale_y_continuous(labels = label_dollar()) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom"
  ) 
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Regional Rev Chart-1.png)<!-- -->
 
 <br>
 
 As evidenced in the chart above, revenue streams are subject to large deviations, moreso in some regions than others. Royal Dutch Shell is also experiencing a changing market with decreasing revenues in non-US Americas and Europe yet increasing revenues in the US and Asia/Oceania/Africa. The chart below displays how the regional percent of total revenues has changed during the period from 2008 to 2019.
 
 <br>
 

```r
rev %>% 
  filter(Year > 2007, Year < 2020) %>% 
  ggplot(aes(x = Year, y = Percent.Annual, color = Region)) +
  geom_line(size = 1) +
  ggtitle("Regional Percent of Total Revenues", "Royal Dutch Shell") +
  ylab("") +
  xlab("") +
  scale_x_continuous(n.breaks = 10, limits = c(2008, 2019)) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom"
  ) 
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Regional Percent Rev Chart-1.png)<!-- -->
 

 
 



#### Objectives

  This report will cover some major macroeconomic indicators and how they impact Royal Dutch Shell. An analysis of specific measures to mitigate this risk will be compared with the goal of maximizing revenues. By evaluating the sensitivity, or elasticity, of these indicators, Royal Dutch shell will be able to quantify the risks of a changing macroeconomy. With these elasticities, a strategy to mitigate these risks will be developed.

  The macroeconomics indicators that will be considered are changes in real GDP, consumption, industrial production, nominal interest rate, inflation, unemployment rate, exchange rate, and natural gas and oil prices. All data is retrieved from the World Bank. The national values for GDP, consumption, and industrial production within a region are summed by year to calculate the total regional values. The nominal interest rates and inflation rates are averaged for each nation using the nation's GDP as a weight. Likewise, the unemployment rate for each nation in a region is averaged using each nation's population as a weight. The exchange rate used is an index provided by the World Bank. The exchange rate for each region is set to the exchange rate for the largest national economy, as measured in GDP, in 2019.


## Literature Review

#### Determinants of price of oil and natural gas.

#### Correlation of price of oil/LNG with macroeconomic indicators.

#### Limiting exchange rate risk of international corporations.

#### Microeconomics of Fossil Fuel industry to maximize revenues.




## Method of Analysis

#### Scope 

  By means of a log-log model with regional revenues as the dependent variable and macroeconomics indicators as the independent variables, the elasticities of each of these indicators can be evaluated. However, given that available revenue data only trace back to 2004, this approach is severely limited in the vigor necessary for some of the claims that must be met. Therefore, a laxed approach must be considered such that the empirical results do not counter economic theory.

  We begin by visually inspecting the included macroeconomic variables with RDS revenues by region. As the exact amounts of these variables are not as important as the correlation to revenues, each of the variables for each region will be scaled and centered to give a mean of zero and standard deviation of one. By doing so, each variable may be visually analyzed in comparison to the scaled and centered revenues.


```r
indicators.scaled <- indicators %>% 
  group_by(Region) %>% 
  mutate(
    across(
      .cols = c(
        'consumption', 'gdp', 'indust.production', 'cpi', 'interest.nom', 'gas.price', 'oil.price', 'unemployment.rate', 'population', 'exchange.rate.index', 'Revenue'
      ), scale
    )
  )
```


#### GDP

  Real Gross Domestic Product is monumental in the discussion of macroeconomic indicators as it is the heartbeat of an economy, measuring the total value of goods and services produced during a period. This is relevant to Royal Dutch Shell as demand for energy will fluctuate with the economy. When an economy is expanding, the energy that it needs to fulfill this expansion will increase. On the contrary, an economy will have a baseline energy requirement that must be met regardless of the growth of an economy.

  The charts below show little correlation between GDP and revenues, outside of non-US Americas. Because GDP is an all-encompassing value, the impact of more specific variables could be masking the visual impact that GDP has on revenues. 


```r
indicators.scaled %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = gdp)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Real GDP by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/GDP Plot-1.png)<!-- -->



#### Consumption

  Real Consumption is a large component of real GDP. This would reflect the actions of consumers within an economy. Higher consumption levels could lead to increased retail sales due to a populace commuting more or traveling. However, a visual analysis does not indicate much correlation, as shown below.


```r
indicators.scaled %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = consumption)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Real Consumption by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Consumption Plot-1.png)<!-- -->



#### Industrial Production

  Industrial Production is the measure of output from manufacturing, mining, and utilities. Most of which are higher energy-consuming processes. There appears to be significant correlation to revenues in non-US Americas but little outside of this region. This could indicate differences in energy use. Economies that are more reliant on fossil fuels will have revenues more correlated to industrial production. 


```r
indicators.scaled %>% 
  filter(Year < 2019) %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = indust.production)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Real Industrial Production by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2018, 2), limits = c(2008, 2018)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Industrial Plot-1.png)<!-- -->




#### Inflation

  The inflation rate, as measured by the rate of growth in the Consumer Price Index, is another instrumental macroeconomic variable. Yet it appears to correlate with revenues very little. This could be due to mostly stable inflation rates, especially when aggregated in regions, with higher inflation areas in rare pockets across the globe.


```r
indicators.scaled %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = cpi)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Consumer Price Index by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Inflation Plot-1.png)<!-- -->



#### Nominal Interest Rate

  The nominal interest rate is an important variable to consider as it is the opportunity cost of holding money. Higher rates would mean that RDS is more constrained in financing projects such as research and development. This could mean that interest rates today wouldn't necessarily impact only revenues today but future revenues as some capital projects today would be foregone lowering future revenues. 

  The graph below does seem to indicate some correlation but as past interest rates could be impacting current revenues, a linear model will be a more appropriate measure of this correlation.


```r
indicators.scaled %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = interest.nom)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Nominal Interest Rate by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Interest Plot-1.png)<!-- -->





#### Unemployment Rate

  Another central pillar of macroeconomics, the unemployment rate will also indicate the health of an economy. RDS should expect lower revenues in regions with higher unemployment as commutes to work, lowered consumption, among other factors would lower energy demand. 

  Asia/Oceania/Africa and non-US Americas seem to follow this theory, but Europe and the US do not show much of a correlation. Again, this could be that higher-income nations are less reliant on fossil fuels which would limit the correlation between revenues and unemployment. 


```r
indicators.scaled %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = unemployment.rate)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Unemployment Rate by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Unemployment Plot-1.png)<!-- -->



#### Exchange Rate Index

  The exchange rate index indicates how an economy is operating relative to other economies. High-importing nations will generally reflect a higher exchange rate while high-exporting nations will generally have lower exchange rates. It will be a reflection of how local prices compare to foreign prices. 

  There does appear to be some correlation to regional revenues. The US appears to be negatively correlated with the exchange rate while non-US Americas appears to be positively correlated. 


```r
indicators.scaled %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = exchange.rate.index)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Exchange Rate Index by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Exchange Rate Plot-1.png)<!-- -->




#### Oil Rents

  The World Bank defines oil rents as "...the difference between the value of crude oil production at world prices and total costs of production." The data gathered was as a percent of GDP however, the chart below converts the units to dollars by multiplying each economies GDP in dollars by this percentage. This is extremely correlated to revenues, as expected. As the difference between value of production and cost of production increases, we should expect to see higher revenues. Including this variable within the linear modeling will act as a control of the volatile price of oil.


```r
indicators.scaled %>% 
  filter(Year < 2019) %>% 
  group_by(Region) %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = oil.price)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Total Oil Rents by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Oil Price Plot-1.png)<!-- -->



#### Natural Gas Rents

  Natural gas rents were similarly derived as oil rents. As natural gas extration and production is also a major operation at RDS, although not as major as oil, we would also expect there to be correlation with revenues. 


```r
indicators.scaled %>% 
  filter(Year < 2019) %>% 
  group_by(Region) %>% 
  ggplot(aes(x = Year, color = Region)) +
  geom_line(aes(y = gas.price)) +
  geom_line(aes(y = Revenue), color = "gray70") +
  facet_wrap(. ~ Region, scales = "free_y") +
  ggtitle("Total Natural Gas Rents by Region", "With Regional Revenues in Gray") +
  ylab("Scaled & Centered") +
  xlab("") +
  scale_x_continuous(breaks = seq(2008, 2019, 2), limits = c(2008, 2019)) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    legend.position = "bottom",
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank()
  )
```

![](Royal-Dutch-Shell-Draft1_files/figure-docx/Gas Price Plot-1.png)<!-- -->



  A visual analysis is helpful in seeing the bilateral interactions between revenues and these macroeconomic indicators, but, due to the complexity of the market, is not sufficient to infer conclusions. Using a linear model, the numerous intricacies can be quantified and help determine the most significant. A log-log model enables the evaluation of the elasticies for each of these variables to RDS revenues. Which enables the ability to determine which macroeconomic variables impact revenues the greatest. Knowing these sensitivies will indicate where to allocate resources to hedge this risk.
  

#### Log-Log model evaluation


```r
regions <- unique(indicators$Region)

model.regional.list <- lapply(regions, function(r){
    indicators %>% 
      filter(
        Region == r, Year > 2002, Year < 2019,
        !is.na(Revenue), Revenue != 0
      ) %>% 
      lm(
        dlog(Revenue) ~ dlog(consumption) +
          dlog(gdp) + dlog(indust.production) + dlog(cpi) +
          diff(interest.nom) + 
          #dlog(gas.price) + #Need to re-examine. US is missing multiple years.
          dlog(oil.price) +
          diff(unemployment.rate) + dlog(exchange.rate.index)
        , data = ., na.action = na.omit
      )
  })

names(model.regional.list) <- regions
```

The following tables are the output of this model for each region. The "dlog()" encapsulating each variable is a function that returns the first difference of the natural log of the variable.
 
 
#### Asia/Oceania/Africa:


```r
model.regional.list[["Asia.Oceania.Africa"]] %>% 
  #summary() %>% 
  broom::tidy() %>% 
  kable(
    caption = "Asia/Oceania/Africa Log-Log Model.",
    col.names = c("Predictor", "Estimate", "SE", "t-Statistic", "P-Value"),
    digits = c(0, 2, 2, 2, 2)
  )
```



Table: Asia/Oceania/Africa Log-Log Model.

|Predictor                 | Estimate|    SE| t-Statistic| P-Value|
|:-------------------------|--------:|-----:|-----------:|-------:|
|(Intercept)               |    -0.35|  0.17|       -1.99|    0.10|
|dlog(consumption)         |     6.23|  5.24|        1.19|    0.29|
|dlog(gdp)                 |     6.14|  5.00|        1.23|    0.27|
|dlog(indust.production)   |    -3.56|  1.98|       -1.80|    0.13|
|dlog(cpi)                 |    -0.05|  0.33|       -0.16|    0.88|
|diff(interest.nom)        |    -2.17|  2.55|       -0.85|    0.44|
|dlog(oil.price)           |     0.71|  0.13|        5.53|    0.00|
|diff(unemployment.rate)   |   -52.07| 47.48|       -1.10|    0.32|
|dlog(exchange.rate.index) |     0.47|  0.82|        0.57|    0.60|

<br> 

#### Europe:


```r
model.regional.list[["Europe"]] %>% 
  #summary() %>% 
  tidy() %>% 
  kable(
    caption = "Europe Log-Log Model.",
    col.names = c("Predictor", "Estimate", "SE", "t-Statistic", "P-Value"),
    digits = c(0, 2, 2, 2, 2)
  )
```



Table: Europe Log-Log Model.

|Predictor                 | Estimate|    SE| t-Statistic| P-Value|
|:-------------------------|--------:|-----:|-----------:|-------:|
|(Intercept)               |    -0.18|  0.10|       -1.79|    0.13|
|dlog(consumption)         |    -4.15|  7.80|       -0.53|    0.62|
|dlog(gdp)                 |     9.68| 12.92|        0.75|    0.49|
|dlog(indust.production)   |     1.64|  6.14|        0.27|    0.80|
|dlog(cpi)                 |     3.62|  2.02|        1.80|    0.13|
|diff(interest.nom)        |     3.80|  6.23|        0.61|    0.57|
|dlog(oil.price)           |     0.77|  0.12|        6.49|    0.00|
|diff(unemployment.rate)   |    23.26| 16.32|        1.43|    0.21|
|dlog(exchange.rate.index) |     0.95|  1.39|        0.69|    0.52|

<br> 

#### United States:


```r
model.regional.list[["US"]] %>% 
  #summary() %>% 
  tidy() %>% 
  kable(
    caption = "US Log-Log Model.",
    col.names = c("Predictor", "Estimate", "SE", "t-Statistic", "P-Value"),
    digits = c(0, 2, 2, 2, 2)
  )
```



Table: US Log-Log Model.

|Predictor                 | Estimate|    SE| t-Statistic| P-Value|
|:-------------------------|--------:|-----:|-----------:|-------:|
|(Intercept)               |    -0.16|  0.31|       -0.51|    0.63|
|dlog(consumption)         |     9.92| 17.03|        0.58|    0.59|
|dlog(gdp)                 |     0.60| 16.36|        0.04|    0.97|
|dlog(indust.production)   |     0.01|  1.97|        0.00|    1.00|
|dlog(cpi)                 |    -3.37| 15.50|       -0.22|    0.84|
|diff(interest.nom)        |   -13.06|  7.75|       -1.69|    0.15|
|dlog(oil.price)           |     0.03|  0.06|        0.42|    0.69|
|diff(unemployment.rate)   |    -8.50| 17.06|       -0.50|    0.64|
|dlog(exchange.rate.index) |    -4.18|  4.80|       -0.87|    0.42|

<br> 

#### Other Americas:


```r
model.regional.list[["Europe"]] %>% 
  #summary() %>% 
  tidy() %>% 
  kable(
    caption = "Other Americas Log-Log Model.",
    col.names = c("Predictor", "Estimate", "SE", "t-Statistic", "P-Value"),
    digits = c(0, 2, 2, 2, 2)
  )
```



Table: Other Americas Log-Log Model.

|Predictor                 | Estimate|    SE| t-Statistic| P-Value|
|:-------------------------|--------:|-----:|-----------:|-------:|
|(Intercept)               |    -0.18|  0.10|       -1.79|    0.13|
|dlog(consumption)         |    -4.15|  7.80|       -0.53|    0.62|
|dlog(gdp)                 |     9.68| 12.92|        0.75|    0.49|
|dlog(indust.production)   |     1.64|  6.14|        0.27|    0.80|
|dlog(cpi)                 |     3.62|  2.02|        1.80|    0.13|
|diff(interest.nom)        |     3.80|  6.23|        0.61|    0.57|
|dlog(oil.price)           |     0.77|  0.12|        6.49|    0.00|
|diff(unemployment.rate)   |    23.26| 16.32|        1.43|    0.21|
|dlog(exchange.rate.index) |     0.95|  1.39|        0.69|    0.52|

<br> 

#### Hedging risk of elasticities

#### Optimization

#### Economic value-added of differing operations



## Results & Discussion

#### log-log model breakdown

#### basis of theoretical model and application

#### discussion of ideal inputs

#### Diverse operations portfolio vs. allocation towards most profitable



## Conclusion

#### Summary of available options to mitigate risk

#### How to maximize revenues given current conditions

#### Discussion of variability outside of scope