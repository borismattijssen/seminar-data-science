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
model1 <-lm(msrp ~ + mpg, data = q3, na.action = na.exclude )
model2 <-lm(msrp ~ + mpg + mpgmpge , data = q3, na.action = na.exclude )
model3 <-lm(msrp ~ + mpg + mpgmpge + accelrate , data = q3, na.action = na.exclude )

anova(model1,model2)
anova(model2,model3)

summary(model3)
confint(model3) #gives CI95% of the estimates (B-values)
lm.beta(model3) #give standardized Beta values


#subquestion 5

###### Assumption tests 

#testing independence of error
durbinWatsonTest(model3)

#test of multicollinearity
vif(model3)



hist(model3$residuals)
hist(rstudent(model3))
plot(model3$residuals, model3$fitted)
plot(model3)



#subquestion 6 - DFBeta
dfbeta(model3)
