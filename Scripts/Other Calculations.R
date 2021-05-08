
### Average Growth Rate Past Decade
{
  indicators %>% 
    group_by(Year) %>% 
    summarise(Revenue = sum(Revenue)) %>% 
    arrange(Year) %>% 
    mutate(
      Rev.diff = Revenue - dplyr::lag(Revenue),
      Rev.percent = Rev.diff / Revenue
    ) %>% 
    top_n(Year, n = 10) %>% 
    ungroup() %>% 
    summarize(
      #Avg.Percent = prod(1+Rev.percent)^(1 / 10) - 1
      Avg.Percent = (last(Revenue) / first(Revenue))^(1/10) - 1
    )
}


### Average Growth Rate Past Decade by Region
{
  indicators %>% 
    select(Year, Region, Revenue) %>% 
    group_by(Region) %>% 
    filter(Revenue != 0) %>% 
    arrange(Year) %>% 
    mutate(
      Rev.diff = Revenue - dplyr::lag(Revenue, default = 0),
      Rev.percent = Rev.diff / Revenue
    ) %>% 
    top_n(Year, n = 10) %>% 
    summarize(
      #Avg.Percent = prod(1+Rev.percent)^(1 / 10) - 1
      Avg.Percent = (last(Revenue) / first(Revenue))^(1/10) - 1
    )
}



### Fixed Effects Regression Model
{
  indicators.diff <- indicators %>%
    select(
      Year, Region, Revenue, consumption, gdp, indust.production, cpi,
      interest.nom, gas.price, oil.price, unemployment.rate, exchange.rate.index
    ) %>% 
    group_by(Region) %>% 
    arrange(Year) %>% 
    mutate(
      c.to.gdp = consumption / gdp,
      indust.to.gdp = indust.production / gdp,
      c.to.indust = consumption / indust.production,
      c.to.e = scale(consumption) / exchange.rate.index,
      interest.squared = ((interest.nom+1)^2-1),
      across(
        c(
          Revenue, consumption, gdp, indust.production, gas.price,
          cpi, oil.price, exchange.rate.index
        ),
        .fns = function(x)(x / lag(x) - 1)
      ),
      across(
        c(
          interest.nom, unemployment.rate, c.to.gdp, indust.to.gdp, c.to.indust, c.to.e, interest.squared
        ),
        .fns = function(x)(x - lag(x))
      )
    )
  
  
  lm(
      Revenue ~ gdp 
      #+ consumption
      #+ indust.production 
      #+ c.to.e
      #+ indust.to.gdp
      #+ c.to.indust
      #+ cpi 
      #+ oil.price 
      #+ gas.price
      + interest.nom 
      #+ unemployment.rate 
      + exchange.rate.index 
      + Region - 1,
      data = indicators.diff %>% 
        filter(!is.na(Revenue), Revenue != Inf, Year < 2019)
    ) %>% 
    #residuals(.)
    #vif(.)
    #plot(.)
    summary(.)
}



###
{
  lm(
    Revenue ~ gdp 
    #+ consumption
    #+ indust.production 
    #+ c.to.e
    #+ indust.to.gdp
    #+ c.to.indust
    #+ cpi 
    #+ oil.price 
    #+ gas.price
    #+ interest.nom 
    + lag(interest.nom, n = 1) 
    + lag(interest.nom, n = 2) 
    + lag(interest.nom, n = 3) 
    #+ lag(interest.nom, n = 4) 
    #+ lag(interest.nom, n = 3) 
    #+ unemployment.rate 
    + exchange.rate.index 
     - 1,
    data = indicators.diff %>% 
      filter(!is.na(Revenue), Revenue != Inf, Year < 2019)
  ) %>% 
    #residuals(.)
    #vif(.)
    #plot(.)
    summary(.)
}
