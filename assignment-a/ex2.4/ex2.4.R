library(car) #Package includes Levene's test 
#install.packages('tidyr',dependencies = TRUE)
library(tidyr)  # for wide to long format transformation of the data
library(ggplot2)
#install.packages('QuantPsyc',dependencies = TRUE)
library(QuantPsyc) #include lm.beta()
#install.packages('gmodels',dependencies = TRUE)
library(gmodels)
# use rstudioapi package to get file directory
library(rstudioapi)

# set working directory to match this file's directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


q4 <- read.csv("ex2.4_dataset.csv", header=TRUE)

#binomial accepts only 0 and 1 values, not 2
q4$X1[q4$X1 == 2] <- 0
q4$X1.1[q4$X1.1== 2] <- 0

#subquestion 2 - logistic regression
model0 <- glm(X1 ~ 1, data = q4, family = binomial())
model1 <- glm(X1 ~ X4512 , data = q4, family = binomial())
model2 <- glm(X1 ~ X1530, data = q4, family = binomial())

anova(model0,model1,model2,test = "Chisq" )

summary(model1)

#need to check which model improves data and keep only that
logisticPseudoR2s(model1)

#odds ratio
exp(model1$coefficients)

#odds ration confidence interval
exp(confint(model1))
q4$X1pred <- fitted(model1)

#subquestion 3 - crosstable of predicted and observed values
CrossTable(q4$X1pred, q4$X1, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, fisher=FALSE, chisq=FALSE, expected = FALSE)
