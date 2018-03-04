library(car)
library(ggplot2)
library(nlme)
library(reshape)
library(graphics)
library(QuantPsyc) #include lm.beta()

# use rstudioapi package to get file directory
library(rstudioapi)

# set working directory to match this file's directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


q3 <- read.csv("hybrid_reg.csv",header = TRUE)

#subquestion 2 - histogram of dependent variable
hist(q3$msrp)

#subquestion 3 - scatterplots of dependent and predictor variables
scatterplot(msrp ~ mpg, data = q3) 
scatterplot(msrp ~ mpgmpge, data = q3)
scatterplot(msrp ~ accelrate, data = q3)

#subquestion 4 - linear regression
model <-lm(msrp ~ + mpg + mpgmpge + accelrate , data = q3, na.action = na.exclude )

summary(model)
confint(model) #gives CI95% of the estimates (B-values)
lm.beta(model) #give standardized Beta values


#subquestion 5

###### Assumption tests 

#testing independence of error
durbinWatsonTest(model)

#test of multicollinearity
vif(model)
1/vif(model) # Tolerance

# these two don't work for these data
#leveneTest(model)
#shapiro.test(model)

hist(model$residuals)
hist(rstudent(model))
plot(model$residuals, model$fitted)
plot(model)



#subquestion 6 - DFBeta
dfbeta(model)
hatvalues(model2)
