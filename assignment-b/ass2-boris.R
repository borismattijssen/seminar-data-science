library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

d <- read.csv("data.csv")

# dataset boxplots
boxplot(score~dataset,data=d, main="Score per dataset", xlab="Dataset", ylab="Score")
boxplot(score~dataset,data=d[d$metric == 'err'], main="Score per dataset for metric == 'err'", xlab="Dataset", ylab="Score")
boxplot(score~topic,data=d, main="Score per topic", xlab="Topic", ylab="Score")
boxplot(score~metric,data=d, main="Score per metric", xlab="Metric", ylab="Score")
boxplot(score~model,data=d, main="Score per model", xlab="Model", ylab="Score")

# model analysis
model0 <- lm(score ~ 1, data = d, na.action = na.exclude)
model1 <- lm(score ~ lug, data = d, na.action = na.exclude)
model2 <- lm(score ~ token, data = d, na.action = na.exclude)
model3 <- lm(score ~ model, data = d, na.action = na.exclude)
anova(model0, model1)
anova(model0, model2)
anova(model0, model3)
summary(model1)
summary(model2)
summary(model3)

# pick top three systems, based on the mean of scores per system
system <- array(0,612)
models <- levels(d$model)
lugs <- levels(d$lug)
tokens <- levels(d$token)
i <- 1
systext <- array(0,612)
for(model in models){
  for(lug in lugs) {
    for(token in tokens) {
      system[i] = mean(d$score[d$model == model & d$lug == lug & d$token == token])
      systext[i] = paste(model, ", ", lug, ", ", token)
      i <- i + 1
    }
  }
}

s <- sort(system, decreasing=TRUE,index.return=TRUE)
s$ix[1:3]