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


logisticPseudoR2s <- function(LogModel)
  #taken from Andy Fields et al. book on R, p.334
{
  dev <- LogModel$deviance
  nullDev <- LogModel$null.deviance
  modelN <- length(LogModel$fitted.values)
  R.l <- 1 - dev / nullDev
  R.cs <- 1 - exp(-(nullDev - dev) / modelN)
  R.n <- R.cs / (1 - (exp(-(nullDev / modelN))))
  cat("Pseudo R^2 for logistic regression\n")
  cat("Hosmer and Lemshow R^2:  ", round(R.l, 3), "\n")
  cat("Cox and Snell R^2:       ", round(R.cs, 3), "\n")
  cat("Nagelkerke R^2:          ", round(R.n, 3), "\n")
}


q4 <- read.csv("ex2.4_dataset.csv", header=TRUE)

#binomial accepts only 0 and 1 values, not 2
q4$Gender[q4$Gender == 2] <- 0
q4$Age.Range[q4$Age.Range== 2] <- 0
q4$Gender<-factor(q4$Gender, levels = c(0:1), labels = c("Female","Male"))

#subquestion 2 - logistic regression

#Centering predictors, this will make easier to interpret predictors
q4$Head.Size <-q4$Head.Size - mean(q4$Head.Size)
q4$Brain.Weight <-q4$Brain.Weight - mean(q4$Brain.Weight)


model0 <- glm(Gender ~ 1, data = q4, family = binomial())
model1 <- glm(Gender ~ Head.Size , data = q4, family = binomial())
model2 <- glm(Gender ~ Brain.Weight, data = q4, family = binomial())

anova(model0,model1,test = "Chisq" )
anova(model0,model2,test = "Chisq")

#summary(model1)
#summary(model2)

model3 <-glm(Gender ~ Brain.Weight + Head.Size, data = q4, family = binomial())
anova(model0,model3,test = "Chisq")
#need to check which model improves data and keep only that
logisticPseudoR2s(model3)

#odds ratio
exp(model3$coefficients)

#odds ration confidence interval
exp(confint(model3))


q4$Genderpred[fitted(model3) <=0.5] <- 0
q4$Genderpred[fitted(model3) > 0.5] <- 1
q4$Genderpred<-factor(q4$Genderpred, levels = c(0:1), labels = c("Female","Male"))


#subquestion 3 - crosstable of predicted and observed values
CrossTable(q4$Genderpred, q4$Gender, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, fisher=FALSE, chisq=FALSE, expected = FALSE)
