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

#TODO, not sure this is the correct plot
scatter <- ggplot(p3, aes(score, session))
scatter +geom_point() +geom_smooth(method="lm")# facet_wrap(~Subject,2,5) # make scate plot

#question 2 - multilevel analysis
#TODO, this model maybe is not the one that is requested
baseline <- lme(score ~ 1, data = p3, random=~1|session,  method = "ML")
summary(baseline)


randomIntercept<- lme(score ~ session, data = p3, random=~1|Subject, method = "ML")
summary(randomIntercept)

intervals(baseline, 0.95)
intervals(randomIntercept, 0.95)