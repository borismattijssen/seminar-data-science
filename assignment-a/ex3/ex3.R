library(car)
library(ggplot2)
library(nlme)
library(reshape)
library(graphics)
# use rstudioapi package to get file directory
library(rstudioapi)

# set working directory to match this file's directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


p3 <- read.csv("set1.csv",header = TRUE)

#question 1 - histogram to see distribution and scatterplot to see relation
hist(p3$score)


scatterplot(p3$session,p3$score)

#question 2 - multilevel analysis

baseline <- lme(score ~ 1,data=p3,random=~1|Subject,method="ML")
summary(baseline)

randomIntercept<- lme(score ~ session, data = p3, random=~1|Subject, method = "ML")
summary(randomIntercept)

anova(baseline,randomIntercept)

intervals(baseline, 0.95)
intervals(randomIntercept, 0.95)
