#Libraries
{
  library(tidyverse)
}

{
  options(scipen = 9999)
}

#Pull in data
{
  info.country <- read.csv(
    "Data/Country Info.csv",
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(Country.Code, Region, IncomeGroup) %>% 
    filter(Region != "") %>% 
    mutate(
      Region = case_when(
        Region == "Latin America & Caribbean" ~ "America.Other",
        Region == "South Asia" ~ "Asia.Oceania.Africa",
        Region == "Sub-Saharan Africa" ~ "Asia.Oceania.Africa",
        Region == "Europe & Central Asia" ~ "Europe",
        Region == "Middle East & North Africa" ~ "Asia.Oceania.Africa",
        Region == "East Asia & Pacific" ~ "Asia.Oceania.Africa",
        Region == "North America" ~ "US",
        Region == "North America" & Country.Code == "CAN" ~ "America.Other",
      )
    )
  
  exchange.rate <- read.csv(
      "Data/Exchange Rate.csv",
      skip = 4,
      fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "exchange.rate",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(exchange.rate)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  inflation <- read.csv(
    "Data/Inflation.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "inflation.rate",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(inflation.rate)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  natgas.rent.gdp.p <- read.csv(
    "Data/Natural Gas Rents as Percent of GDP.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "gas.percent",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(gas.percent)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  oil.rent.gdp.p <- read.csv(
    "Data/Oil Rents as Percent of GDP.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "oil.percent",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(oil.percent)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  population <- read.csv(
    "Data/Population.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "population",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(population)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  consumption <- read.csv(
    "Data/Real Consumption.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "consumption",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(consumption)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  gdp <- read.csv(
    "Data/Real GDP.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "gdp",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(gdp)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  indust.production <- read.csv(
    "Data/Real Industrial Production.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "indust.production",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(indust.production)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  interest.real <- read.csv(
    "Data/Real Interest Rate.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "interest.real",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(interest.real)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  unemployment.rate <- read.csv(
    "Data/Unemployment Rate.csv",
    skip = 4,
    fileEncoding = "UTF-8-BOM"
    ) %>% 
    select(
      -c(X, Indicator.Name, Indicator.Code)
    ) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code), 
      names_to = "Year",
      values_to = "unemployment.rate",
      names_prefix = "X"
    ) %>% 
    filter(!is.na(unemployment.rate)) %>% 
    pivot_longer(
      -c(Country.Name, Country.Code, Year),
      names_to = "Indicator",
      values_to = "Value"
    )
  
  revenues <- readxl::read_xlsx(
    "Data/Revenues by Region.xlsx"
  ) 
}

#Merge economic variables into one dataset
{
  indicators <- bind_rows(
    consumption, exchange.rate, gdp, indust.production, 
    inflation, interest.real, natgas.rent.gdp.p,
    oil.rent.gdp.p, population, unemployment.rate
    ) %>% 
    pivot_wider(
      names_from = Indicator, values_from = Value
    ) %>% 
    left_join(
      x = ., y = info.country, by = "Country.Code"
    ) %>% 
    group_by(Region, Year) %>% 
    mutate(
      gdp.largest = ifelse(gdp == max(gdp, na.rm = TRUE), 1, 0)
    ) %>% 
    summarize(
      consumption = sum(consumption, na.rm = TRUE),
      gdp = sum(gdp, na.rm = TRUE),
      indust.production = sum(indust.production, na.rm = TRUE),
      inflation.rate = sum(inflation.rate*gdp, na.rm = TRUE)/sum(gdp, na.rm = TRUE),
      interest.nom = sum((interest.real + inflation.rate)*gdp, na.rm = TRUE)/sum(gdp, na.rm = TRUE),
      gas.price = sum(gas.percent * gdp, na.rm = TRUE),
      oil.price = sum(oil.percent * gdp, na.rm = TRUE),
      unemployment.rate = sum(unemployment.rate * population, na.rm = TRUE) / sum(population, na.rm = TRUE),
      population = sum(population, na.rm = TRUE),
      exchange.rate = sum(exchange.rate * gdp.largest, na.rm = TRUE)
    )
  
  
  
}

















