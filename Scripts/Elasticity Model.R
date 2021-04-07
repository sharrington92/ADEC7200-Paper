#Libraries
{
  library(tidyverse)
  
  option(scipen = 9999)
}

#User-defined functions
{
  dlog <- function(x){
    diff(log(x)) %>% return()
  }
}

#Pull data
{
  indicators <- read.csv("Data/Combined and Prepared Data.csv")
  
  
}

#Construct model of all data irregardless of region
{
  indicators %>% 
    ungroup() %>% 
    group_by(Year) %>% 
    summarize(
      Revenue = sum(Revenue),
      consumption = sum(consumption),
      gdp = sum(gdp),
      indust.production = sum(indust.production),
      cpi = sum(cpi * gdp) / sum(gdp),
      interest.nom = sum(interest.nom * gdp) / sum(gdp),
      gas.price = mean(gas.price),
      oil.price = mean(oil.price),
      unemployment.rate = sum(unemployment.rate * population) / sum(population),
      exchange.rate.index = sum(exchange.rate.index * gdp) / sum(gdp)
    ) %>% 
    ungroup() %>% 
    filter(Year < 2019) %>% 
    lm(
      dlog(Revenue) ~ dlog(consumption) + dlog(gdp) + dlog(indust.production) + dlog(cpi) +
        diff(interest.nom) + dlog(gas.price) + dlog(oil.price) + diff(unemployment.rate) + dlog(exchange.rate.index)
      , data = .
    ) %>% 
    summary(.)
}

#Construct model with respect to region
{
  indicators %>% 
    filter(Year < 2019, Year > 2003, Revenue > 0, !is.na(Revenue)) %>% 
    group_by(Region) %>% 
    lm(
      dlog(Revenue) ~ dlog(consumption) + dlog(gdp) + dlog(indust.production) + dlog(cpi) +
        diff(interest.nom) + dlog(gas.price) + dlog(oil.price) + diff(unemployment.rate) + 
        dlog(exchange.rate.index)
        #as.factor(Region)
      , data = .
    ) %>% 
    summary(.)
  
  model.regional <- indicators %>% 
    filter(Year < 2019, Year > 2003, Revenue > 0, gas.price > 0) %>% #View()
    nest(-Region) %>% 
    mutate(fit = map(data, ~ lm(
      dlog(Revenue) ~ dlog(consumption) + dlog(gdp) + dlog(indust.production) + dlog(cpi) +
        diff(interest.nom) + dlog(gas.price) + dlog(oil.price) + diff(unemployment.rate) + dlog(exchange.rate.index)
      , data = .
    )))
}