library(rstudioapi)
library(stats)
library(graphics)
library(ggplot2)
library(QuantPsyc) #include lm.beta()
library(car)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

d <- read.csv("data.csv")
str(d)

#sort data based on score in descending order
i <- order(d$score,decreasing=TRUE)
dd <- data.frame(d$metric[i],d$dataset[i],d$topic[i],d$token[i],d$lug[i],d$model[i],d$score[i])

#naive attempt to find the best systems, 6895 is the final index where score is one
hist(dd$d.topic.i[1:6895])
barplot(dd$d.score.i[1:6895],names.arg=dd$d.dataset.i.[1:6895])
barplot(dd$d.score.i[1:6895],names.arg=dd$d.metric.i.[1:6895])
barplot(dd$d.score.i[1:6895],names.arg=dd$d.token.i.[1:6895])
barplot(dd$d.score.i[1:6895],names.arg=dd$d.lug.i.[1:6895])
barplot(dd$d.score.i[1:6895],names.arg=dd$d.model.i.[1:6895])

#example of an expression to get a specific system only from the data
d$score[d$token=="indri" & d$model=="bb2" & d$lug=="krovetz"] 

#initial attempt to get the best systems
s <- data.matrix(d$score)
mat <- matrix(s,nrow=1000,ncol=612)
m <- colMeans((mat))
s <- sort(m,decreasing=TRUE,index.return=TRUE)
s$ix[1:3]

#normal distiribution test
shapiro.test(mat[,397])

#question 1b - compare the effect of each value of the predictor variables by checking the sign and magnitude of their coefficients
baseline <- lm(score ~ 1,data=d,na.action=na.exclude)
model <-lm(score ~ + lug  + model + token , data = d, na.action = na.exclude)

anova(baseline,model)
summary(model)

#best systems
best1 <- d[246,]
best2 <- d[222,]
best3 <- d[240,]

#check interaction effects
model1 <- lm(score~ +lug + model + token +lug:model + lug:token + model:token,data=d,na.action=na.exclude)
anova(baseline,model1)
summary(model1)


model2 <- lm(score~ lug,data=d,na.action=na.exclude)
anova(baseline,model2)
summary(model2)

#homogeneity of variance
leveneTest(d$score,d$topic)

