# This script runs the regressions for the NC recycling project

# Loading libraries

library(plm)
library(AER)
library(dplyr)
library(lmtest)
library(jtools)
library(ggplot2)
library(sandwich)
library(stargazer)
library(systemfit)
library(kableExtra)
library(modelsummary)

# Working directory info

username <- ''
direc = paste('C:/Users/', username , '/Documents/Data/recycle_nc/', sep = '')

# Reading in the data file

nc <- read.csv(paste(direc, 'data/merged_data.csv', sep = ''))
wnc <- read.csv(paste(direc, 'data/WNC.csv', sep = ''), header = FALSE)

# Running the lagged models

nc$Grants_Lag <- c(rep(0,100),nc$Grants[1:400])
nc$Recycling_Total_Lag <- c(rep(0,100),nc$Recycling_Total[1:400])
nc$Recycling_Common_Lag <- c(rep(0,100),nc$Recycling_Common[1:400])

modtl <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants + MRF + Grants_Lag + MRF + 
           + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
           + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
           + New_Houses + factor(Shed), data = nc)

modcl <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants + MRF + Grants_Lag + MRF
           + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
           + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
           + New_Houses + factor(Shed), data = nc)

modtl2 <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants + MRF + Grants_Lag + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed) + factor(Year), data = nc)

modcl2 <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants + MRF + Grants_Lag + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed) + factor(Year), data = nc)

modtl3 <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants + MRF + Grants_Lag + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc)

modcl3 <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants + MRF + Grants_Lag + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc)

modtlc <- coeftest(modtl, vcov = vcovCL, cluster = ~County)
modclc <- coeftest(modcl, vcov = vcovCL, cluster = ~County)
modtl2c <- coeftest(modtl2, vcov = vcovCL, cluster = ~County)
modcl2c <- coeftest(modcl2, vcov = vcovCL, cluster = ~County)
modtl3c <- coeftest(modtl3, vcov = vcovCL, cluster = ~County)
modcl3c <- coeftest(modcl3, vcov = vcovCL, cluster = ~County)

stargazer(modtl, modtlc, modcl, modclc, modtl2, modtl2c, modcl2, modcl2c,# modtl3, modtl3c, modcl3, modcl3c,
          omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

# Total grants funding models

ncga <- nc$Grants[1:200]

for (i in 201:500) {
  
  y <- floor(i/100)
  f <- nc$FIPS[i]
  tmp <- nc[which(nc$FIPS == f),]
  v <- sum(tmp$Grants[1:y])
  ncga <- c(ncga,v)
  
}

nc$Grants_All <- ncga

modta <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_All + MRF + Program_Pcts + log(Population+1)
            + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc)

modca <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_All + MRF + Program_Pcts + log(Population+1)
            + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc)

modta2 <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_All + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc)

modca2 <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_All + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc)

modta3 <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_All + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc)

modca3 <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_All + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc)

modtac <- coeftest(modta, vcov = vcovCL, cluster = ~County)
modcac <- coeftest(modca, vcov = vcovCL, cluster = ~County)
modta2c <- coeftest(modta2, vcov = vcovCL, cluster = ~County)
modca2c <- coeftest(modca2, vcov = vcovCL, cluster = ~County)
modta3c <- coeftest(modta3, vcov = vcovCL, cluster = ~County)
modca3c <- coeftest(modca3, vcov = vcovCL, cluster = ~County)

stargazer(modta, modtac, modca, modcac, modta2, modta2c, modca2, modca2c, modta3,# modta3c, modca3, modca3c,
          omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

# An asymmetric shocks model

ncga.plus <- nc$Grants[1:200]
ncga.minus <- rep(0,200)

for (i in 201:500) {
  
  y <- floor(i/100)
  f <- nc$FIPS[i]
  tmp <- nc[which(nc$FIPS == f),]
  v <- tmp$Grants[y] - tmp$Grants[y-1]
  
  if (v < 0) {
    
    ncga.plus <- c(ncga.plus,0)
    ncga.minus <- c(ncga.minus,v)
    
  } else {
    
    ncga.plus <- c(ncga.plus,v)
    ncga.minus <- c(ncga.minus,0)
    
  }
  
}

nc$Grants_Pos <- ncga.plus
nc$Grants_Neg <- ncga.minus

modtx <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc)

modcx <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc)

modtx2 <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc)

modcx2 <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc)

modtx3 <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc)

modcx3 <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc)

modtxc <- coeftest(modtx, vcov = vcovCL, cluster = ~County)
modcxc <- coeftest(modcx, vcov = vcovCL, cluster = ~County)
modtx2c <- coeftest(modtx2, vcov = vcovCL, cluster = ~County)
modcx2c <- coeftest(modcx2, vcov = vcovCL, cluster = ~County)
modtx3c <- coeftest(modtx3, vcov = vcovCL, cluster = ~County)
modcx3c <- coeftest(modcx3, vcov = vcovCL, cluster = ~County)

stargazer(modtx, modtxc, modcx, modcxc, modtx2, modtx2c, modcx2, modcx2c,# modtx3, modtx3c, modcx3, modcx3c,
          omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

# Calculating spillover effects

W.g <- c(as.matrix(wnc)%*%nc$Grants[1:100],as.matrix(wnc)%*%nc$Grants[101:200],as.matrix(wnc)%*%nc$Grants[201:300],as.matrix(wnc)%*%nc$Grants[301:400],as.matrix(wnc)%*%nc$Grants[401:500])
W.g.all <- c(as.matrix(wnc)%*%nc$Grants_All[1:100],as.matrix(wnc)%*%nc$Grants_All[101:200],as.matrix(wnc)%*%nc$Grants_All[201:300],as.matrix(wnc)%*%nc$Grants_All[301:400],as.matrix(wnc)%*%nc$Grants_All[401:500])
W.g.pos <- c(as.matrix(wnc)%*%nc$Grants_Pos[1:100],as.matrix(wnc)%*%nc$Grants_Pos[101:200],as.matrix(wnc)%*%nc$Grants_Pos[201:300],as.matrix(wnc)%*%nc$Grants_Pos[301:400],as.matrix(wnc)%*%nc$Grants_Pos[401:500])
W.g.neg <- c(as.matrix(wnc)%*%nc$Grants_Neg[1:100],as.matrix(wnc)%*%nc$Grants_Neg[101:200],as.matrix(wnc)%*%nc$Grants_Neg[201:300],as.matrix(wnc)%*%nc$Grants_Neg[301:400],as.matrix(wnc)%*%nc$Grants_Neg[401:500])
W.g.lag <- c(as.matrix(wnc)%*%nc$Grants_Lag[1:100],as.matrix(wnc)%*%nc$Grants_Lag[101:200],as.matrix(wnc)%*%nc$Grants_Lag[201:300],as.matrix(wnc)%*%nc$Grants_Lag[301:400],as.matrix(wnc)%*%nc$Grants_Lag[401:500])

nc$Grants_W <- W.g
nc$Grants_All_W <- W.g.all
nc$Grants_Pos_W <- W.g.pos
nc$Grants_Neg_W <- W.g.neg
nc$Grants_Lag_W <- W.g.lag

modtlw <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants + MRF + Grants_Lag + MRF + Grants_W + MRF + Grants_Lag_W + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc[101:500,])

modclw <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants + MRF + Grants_Lag + MRF + Grants_W + MRF + Grants_Lag_W + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc[101:500,])

modtl2w <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants + MRF + Grants_Lag + MRF + Grants_W + MRF + Grants_Lag_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc[101:500,])

modcl2w <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants + MRF + Grants_Lag + MRF + Grants_W + MRF + Grants_Lag_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc[101:500,])

modtl3w <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants + MRF + Grants_Lag + MRF + Grants_W + MRF + Grants_Lag_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc[101:500,])

modcl3w <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants + MRF + Grants_Lag + MRF + Grants_W + MRF + Grants_Lag_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc[101:500,])

modtlwc <- coeftest(modtlw, vcov = vcovCL, cluster = ~County)
modclwc <- coeftest(modclw, vcov = vcovCL, cluster = ~County)
modtl2wc <- coeftest(modtl2w, vcov = vcovCL, cluster = ~County)
modcl2wc <- coeftest(modcl2w, vcov = vcovCL, cluster = ~County)
modtl3wc <- coeftest(modtl3w, vcov = vcovCL, cluster = ~County)
modcl3wc <- coeftest(modcl3w, vcov = vcovCL, cluster = ~County)

stargazer(modtlw, modtlwc, modclw, modclwc, modtl2w, modtl2wc, modcl2w, modcl2wc,# modtl3w, modtl3wc, modcl3w, modcl3wc,
          omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

stargazer(modtl3w, modtl3wc, modcl3w, modcl3wc, omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

modtaw <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_All + MRF + Grants_All_W + MRF + Program_Pcts + log(Population+1)
            + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc[101:500,])

modcaw <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_All + MRF + Grants_All_W + MRF + Program_Pcts + log(Population+1)
            + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc[101:500,])

modta2w <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_All + MRF + Grants_All_W + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc[101:500,])

modca2w <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_All + MRF + Grants_All_W + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc[101:500,])

modta3w <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_All + MRF + Grants_All_W + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc[101:500,])

modca3w <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_All + MRF + Grants_All_W + MRF + Program_Pcts + log(Population+1)
             + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc[101:500,])

modtawc <- coeftest(modtaw, vcov = vcovCL, cluster = ~County)
modcawc <- coeftest(modcaw, vcov = vcovCL, cluster = ~County)
modta2wc <- coeftest(modta2w, vcov = vcovCL, cluster = ~County)
modca2wc <- coeftest(modca2w, vcov = vcovCL, cluster = ~County)
modta3wc <- coeftest(modta3w, vcov = vcovCL, cluster = ~County)
modca3wc <- coeftest(modca3w, vcov = vcovCL, cluster = ~County)

stargazer(modtaw, modtawc, modcaw, modcawc, modta2w, modta2wc, modca2w, modca2wc,# modta3w, modta3wc, modca3w, modca3wc,
          omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

stargazer(modta3w, modta3wc, modca3w, modca3wc, omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

# An asymmetric shocks model

modtxw <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Grants_Pos_W + MRF + Grants_Neg_W + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc[101:500,])

modcxw <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Grants_Pos_W + MRF + Grants_Neg_W + MRF
            + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
            + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
            + New_Houses + factor(Shed), data = nc[101:500,])

modtx2w <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Grants_Pos_W + MRF + Grants_Neg_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc[101:500,])

modcx2w <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Grants_Pos_W + MRF + Grants_Neg_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(Year), data = nc[101:500,])

modtx3w <- lm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Grants_Pos_W + MRF + Grants_Neg_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc[101:500,])

modcx3w <- lm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Grants_Pos_W + MRF + Grants_Neg_W + MRF
             + Program_Pcts + log(Population+1) + Amenities + log(Population+1) + Population_Density
             + Education_HS + Education_BS + Education_MS + Median_HH_Income + Unemployment
             + New_Houses + factor(Shed) + factor(County) + factor(Year), data = nc[101:500,])

modtxwc <- coeftest(modtxw, vcov = vcovCL, cluster = ~County)
modcxwc <- coeftest(modcxw, vcov = vcovCL, cluster = ~County)
modtx2wc <- coeftest(modtx2w, vcov = vcovCL, cluster = ~County)
modcx2wc <- coeftest(modcx2w, vcov = vcovCL, cluster = ~County)
modtx3wc <- coeftest(modtx3w, vcov = vcovCL, cluster = ~County)
modcx3wc <- coeftest(modcx3w, vcov = vcovCL, cluster = ~County)

stargazer(modtxw, modtxwc, modcxw, modcxwc, modtx2w, modtx2wc, modcx2w, modcx2wc,# modtx3w, modtx3wc, modcx3w, modcx3wc,
          omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

stargazer(modtx3w, modtx3wc, modcx3w, modcx3wc, omit = c('County', 'Shed', 'Year'), omit.stat = c('f', 'ser'), type = 'text')

# Running the first differenced models

modt <- plm(Recycling_Total ~ Grants + MRF + Amenities + log(Population+1)
            + Population_Density + Education_HS + Education_BS + Education_MS
            + Median_HH_Income + Unemployment + New_Houses + factor(County)
            + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modc <- plm(Recycling_Common ~ Grants + MRF + Amenities + log(Population+1)
            + Population_Density + Education_HS + Education_BS + Education_MS
            + Median_HH_Income + Unemployment + New_Houses + factor(County)
            + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modtc <- coeftest(modt, (100/99) * vcovHC(modt, type = 'HC1', cluster = 'group'))
modcc <- coeftest(modc, (100/99) * vcovHC(modc, type = 'HC1', cluster = 'group'))

stargazer(modt, modtc, modc, modcc, type = 'text')

# Running the first differenced models with asymmetric grant effects

modtx <- plm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Amenities + log(Population+1)
            + Population_Density + Education_HS + Education_BS + Education_MS
            + Median_HH_Income + Unemployment + New_Houses + factor(County)
            + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modcx <- plm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Amenities + log(Population+1)
            + Population_Density + Education_HS + Education_BS + Education_MS
            + Median_HH_Income + Unemployment + New_Houses + factor(County)
            + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modtcx <- coeftest(modtx, (100/99) * vcovHC(modtx, type = 'HC1', cluster = 'group'))
modccx <- coeftest(modcx, (100/99) * vcovHC(modcx, type = 'HC1', cluster = 'group'))

stargazer(modtx, modtcx, modcx, modccx, type = 'text')

# Repeating above two sets of models with spillover effects

modtw <- plm(Recycling_Total ~ Grants + Grants_W + MRF + Amenities + log(Population+1)
            + Population_Density + Education_HS + Education_BS + Education_MS
            + Median_HH_Income + Unemployment + New_Houses + factor(County)
            + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modcw <- plm(Recycling_Common ~ Grants + Grants_W + MRF + Amenities + log(Population+1)
            + Population_Density + Education_HS + Education_BS + Education_MS
            + Median_HH_Income + Unemployment + New_Houses + factor(County)
            + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modtwc <- coeftest(modtw, (100/99) * vcovHC(modtw, type = 'HC1', cluster = 'group'))
modcwc <- coeftest(modcw, (100/99) * vcovHC(modcw, type = 'HC1', cluster = 'group'))

stargazer(modtw, modtwc, modcw, modcwc, type = 'text')

modtx <- plm(Recycling_Total ~ Recycling_Total_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Amenities + log(Population+1)
             + Population_Density + Education_HS + Education_BS + Education_MS
             + Median_HH_Income + Unemployment + New_Houses + factor(County)
             + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modcx <- plm(Recycling_Common ~ Recycling_Common_Lag + Grants_Pos + MRF + Grants_Neg + MRF + Amenities + log(Population+1)
             + Population_Density + Education_HS + Education_BS + Education_MS
             + Median_HH_Income + Unemployment + New_Houses + factor(County)
             + factor(Year), data = nc, model = 'fd', index = c('County','Year'))

modtcx <- coeftest(modtx, (100/99) * vcovHC(modtx, type = 'HC1', cluster = 'group'))
modccx <- coeftest(modcx, (100/99) * vcovHC(modcx, type = 'HC1', cluster = 'group'))

stargazer(modtx, modtcx, modcx, modccx, type = 'text')

# Terminal - Initial Models

nc$Amenities_X <- c(rep(0,100),nc$Amenities[101:dim(nc)[1]])

modtxx <- plm(Recycling_Total ~ Grants_All + Grants_All_W + MRF + Amenities_X + log(Population+1)
             + Population_Density + Education_HS + Education_BS + Education_MS
             + Median_HH_Income + Unemployment + New_Houses + factor(Year),
             data = nc[c(1:100,410:500),], model = 'fd', index = c('County','Year'))

modcxx <- plm(Recycling_Common ~ Grants_All + Grants_All_W + MRF + Amenities_X + log(Population+1)
             + Population_Density + Education_HS + Education_BS + Education_MS
             + Median_HH_Income + Unemployment + New_Houses + factor(Year),
             data = nc[c(1:100,410:500),], model = 'fd', index = c('County','Year'))

modtcxx <- coeftest(modtxx, (100/99) * vcovHC(modtxx, type = 'HC1', cluster = 'group'))
modccxx <- coeftest(modcxx, (100/99) * vcovHC(modcxx, type = 'HC1', cluster = 'group'))

stargazer(modtxx, modtcxx, modcxx, modccxx, type = 'text')

# SEM for Amenities and Recycling on all years

RECYCLE.TOT2 <- Recycling_Total ~ Amenities + Grants_All + Grants_All_W + MRF + Program_Pcts + log(Population+1) + Population_Density + Education_HS + Education_BS +  Median_HH_Income + Unemployment + New_Houses + factor(Shed) + factor(Year)
RECYCLE.COM2 <- Recycling_Common ~ Amenities + Grants_All + Grants_All_W + MRF + Program_Pcts + log(Population+1) + Population_Density + Education_HS + Education_BS + Median_HH_Income + Unemployment + New_Houses + factor(Shed) + factor(Year)
AMENITIES.T2 <- Amenities ~ Recycling_Total + Grants_All + Grants_All_W + MRF + Program_Pcts + log(Population+1) + Population_Density + Education_HS + Education_BS + Education_MS + Median_HH_Income + New_Houses + factor(Shed) + factor(Year)
AMENITIES.C2 <- Amenities ~ Recycling_Common + Grants_All + Grants_All_W + MRF + Program_Pcts + log(Population+1) + Population_Density + Education_HS + Education_BS + Education_MS + Median_HH_Income + New_Houses + factor(Shed) + factor(Year)
sys.t2 <- list(RECYCLE.TOT2,AMENITIES.T2)
sys.c2 <- list(RECYCLE.COM2,AMENITIES.C2)
system.t2 <- systemfit(sys.t2, method = 'OLS', data = nc)
system.c2 <- systemfit(sys.c2, method = 'OLS', data = nc)
summary(system.t2)
summary(system.c2)

# SEM for Amenities and Recycling on final year cross section

RECYCLE.TOT <- Recycling_Total ~ Amenities + Grants_All + Grants_All_W + MRF + Program_Pcts + log(Population+1) + Population_Density + Education_HS + Education_BS + Median_HH_Income + Unemployment + New_Houses + factor(Shed)
AMENITIES.T <- Amenities ~ Recycling_Total + Grants_All + Grants_All_W + MRF + Program_Pcts + log(Population+1) + Population_Density + Education_HS + Education_BS + Education_MS + Median_HH_Income + New_Houses + factor(Shed)
sys.t <- list(RECYCLE.TOT,AMENITIES.T)
system.t <- systemfit(sys.t, method = 'OLS', data = nc[401:500,])
summary(system.t)

# Cute sum stats table

keepers <- c('Recycling_Total', 'Amenities', 'MRF', 'Program_Pcts', 'Grants',
             'Population_Density', 'Median_HH_Income', 'Unemployment', 'New_Houses')

new_names <- c('Natural Amenities', 'Materials Recovery Facility', 'Municipalities w/Recycling Progs', 'Grants',
               'Recycling', 'Populaton Density', 'Median Household Income', 'Unemployment Rate', 'New Houses')

sumdata <- nc[1:500,names(nc) %in% keepers]
names(sumdata) <- new_names
datasummary_skim(sumdata, fmt = '%.3f')

