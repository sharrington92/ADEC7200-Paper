#Libraries
{
  library(tidyverse)
  library(broom)
  library(car)
  
  options(scipen = 9999)
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
    filter(
      Region == "Americas.Other", Year > 2002, Year < 2019,
      !is.na(Revenue), Revenue != 0
    ) %>% 
    lm(
      dlog(Revenue) ~ dlog(consumption) + dlog(gdp) + dlog(indust.production) + dlog(cpi) +
        diff(interest.nom) + #dlog(gas.price) + 
        dlog(oil.price) + diff(unemployment.rate) + dlog(exchange.rate.index)
      , data = ., na.action = na.omit
    ) %>% 
    summary(.)
  
  model.regional.list <- lapply(unique(indicators$Region), function(r){
    indicators %>% 
      filter(
        Region == r, Year > 2002, Year < 2019,
        !is.na(Revenue), Revenue != 0
      ) %>% 
      lm(
        dlog(Revenue) ~ dlog(consumption) + dlog(gdp) + dlog(indust.production) + dlog(cpi) +
          diff(interest.nom) + #dlog(gas.price) + 
          dlog(oil.price) + diff(unemployment.rate) + dlog(exchange.rate.index)
        , data = ., na.action = na.omit
      )
  })
  
  #Split data by region, evaluate linear model
  model.regional <- indicators %>% 
    filter(Year < 2019, Year > 2003, Revenue > 0, gas.price > 0) %>% #View()
    nest(-Region) %>% 
    mutate(
      fit = map(data, ~ lm(
        dlog(Revenue) ~ dlog(consumption) + dlog(gdp) + dlog(indust.production) + dlog(cpi) +
          diff(interest.nom) + dlog(gas.price) + dlog(oil.price) + diff(unemployment.rate) + dlog(exchange.rate.index)
        , data = ., na.action = na.omit
      )),
      results = map(fit, glance)
    ) %>% 
    unnest(results)
}

#Get only most promising variables by region
{
  model.tuned <- indicators %>% 
    pivot_longer(
      -c(Year, Region), names_to = "Indicator", values_to = "Value"
    ) %>% 
    mutate(ID = paste(Region, Indicator, sep = ".")) %>%
    ungroup() %>% 
    select(-c(Indicator, Region)) %>% 
    pivot_wider(names_from = ID, values_from = Value) %>% 
    mutate(
      Revenue.Total = Americas.Other.Revenue + US.Revenue + Europe.Revenue + Asia.Oceania.Africa.Revenue
    ) %>% 
    filter(Year < 2019, Year > 2003) %>% 
    lm(
      dlog(Revenue.Total) ~ 
        #dlog(Asia.Oceania.Africa.oil.price) +
        dlog(Europe.gdp /  Europe.population) +
        #dlog(US.indust.production) +
        dlog(US.consumption / US.population) +
        #dlog(US.gdp / US.population) +
        dlog(Europe.oil.price) +
        #dlog(Europe.exchange.rate.index) +
        #diff(US.interest.nom) +
        #dlog(Americas.Other.consumption / Americas.Other.population) +
        diff(Asia.Oceania.Africa.exchange.rate.index) +
        dlog(Asia.Oceania.Africa.consumption / Asia.Oceania.Africa.population) 
      , data = ., na.action = na.omit
    )
  
  summary(model.tuned)
  
  #Test for multicollinearity
  vif(model.tuned)
}
# "Region"              "Year"                "consumption"        
# [4] "gdp"                 "indust.production"   "cpi"                
# [7] "interest.nom"        "gas.price"           "oil.price"          
# [10] "unemployment.rate"   "population"          "exchange.rate.index"
# [13] "Revenue"            

