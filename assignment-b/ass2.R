library(rstudioapi)
library(robustHD)
library(car)
library(nlme)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

d <- read.csv("data.csv")

######## Data analysis

# dataset boxplots
boxplot(score~dataset,data=d, main="Score per dataset", xlab="Dataset", ylab="Score")
boxplot(score~dataset,data=d[d$metric == 'err'], main="Score per dataset for metric == 'err'", xlab="Dataset", ylab="Score")
boxplot(score~topic,data=d, main="Score per topic", xlab="Topic", ylab="Score")
boxplot(score~metric,data=d, main="Score per metric", xlab="Metric", ylab="Score")
boxplot(score~model,data=d, main="Score per model", xlab="Model", ylab="Score")

# remove outliers from the ap metric
d2 <- subset(d, (d$metric != 'ap' | !d$score %in% boxplot.stats(d$score[d$metric == 'ap'])$out))
# standardize scores
d2$score[d2$metric == 'ap'] = (d2$score[d2$metric == 'ap'] - mean(d2$score[d2$metric == 'ap'])) / sd(d2$score[d2$metric == 'ap'])
d2$score[d2$metric == 'err'] = (d2$score[d2$metric == 'err'] - mean(d2$score[d2$metric == 'err'])) / sd(d2$score[d2$metric == 'err'])
d2$score[d2$metric == 'ndcg'] = (d2$score[d2$metric == 'ndcg'] - mean(d2$score[d2$metric == 'ndcg'])) / sd(d2$score[d2$metric == 'ndcg'])
d2$score[d2$metric == 'p10'] = (d2$score[d2$metric == 'p10'] - mean(d2$score[d2$metric == 'p10'])) / sd(d2$score[d2$metric == 'p10'])
d2$score[d2$metric == 'rbp'] = (d2$score[d2$metric == 'rbp'] - mean(d2$score[d2$metric == 'rbp'])) / sd(d2$score[d2$metric == 'rbp'])

# show scores per metric
boxplot(score~metric,data=d2, main="Score per metric", xlab="Metric", ylab="Score")
boxplot(score~topic,data=d2, main="Score per topic", xlab="Topic", ylab="Score")

# effect analysis of dataset and topic
model0 <- lm(score ~ 1, data = d2, na.action = na.exclude)
model1 <- lm(score ~ dataset, data = d2, na.action = na.exclude)
d2$topic <- factor(d2$topic, levels = c(351:550), labels = c(351:550))
d$topic <- factor(d$topic, levels = c(351:550), labels = c(351:550))
model2 <- lm(score ~ topic, data = d2, na.action = na.exclude)
anova(model2)

#use linear model to predict scores with dataset and topic variables for the initial dataset and the one with the standardized aggregated scores
model <- lm(score ~ dataset + topic,data=d,na.action = na.exclude)
model1 <- lm(score ~ dataset + topic,data=d2,na.action = na.exclude)
#use the summaries to compare the systems because ANOVA can't be performed for different dataset sizes
summary(model)
summary(model1)

# only select dataset trec10
d3 <- subset(d2, d2$dataset == 'trec10')
# only select 15 topics with least variance
topics_sds <- aggregate(d3$score ~ d3$topic, FUN=sd)
s <- sort(topics_sds$`d3$score`, index.return=TRUE)
top15topics <- topics_sds$`d3$topic`[s$ix[0:15]]
d4 <- subset(d3, d3$topic %in% top15topics)

# pick top 3 systems
systems <- aggregate(d3$score ~ d3$token + d3$lug + d3$model, FUN=mean)
s <- sort(systems$`d3$score`, index.return=TRUE, decreasing = TRUE)
top3 <- systems[s$ix[0:3],]
top3



######## Component analysis

#create a different subset for each best system combination of two steady components, token has not been compared yet  
d4 <- subset(d3,d3$token=="terrier" & d3$model=="dph")
d5 <- subset(d3,d3$token=="terrier" & d3$lug=="snowballPorter")
d6 <- subset(d3,d3$token=="terrier" & d3$lug=="porter")
d7 <- subset(d3,d3$token=="terrier" & d3$model=="jskls")


#model0 <- lm(score ~ 1, data = d3, na.action = na.exclude)
#model1 <- lm(score ~ lug + token + model, data = d2, na.action = na.exclude)


#create a model for each of the subsets created above
#model2 <- lm(score ~ token, data = d4, na.action = na.exclude)
model3 <- lm(score ~ model, data = d5, na.action = na.exclude)
model4 <- lm(score ~ lug, data = d4, na.action = na.exclude)
model5 <- lm(score ~ model, data = d6, na.action = na.exclude)
model6 <- lm(score ~ lug, data = d7, na.action = na.exclude)
#anova(model2)


#token <- coef(model2)
#sd(token)
#mean(token)
#sum(token)

#get the coeffcients for the component variable of each model and check its statistical properties
model <- coef(model3)
sd(model)
mean(model)
sum(model)

lug <- coef(model4)
sd(lug)
mean(lug)
sum(lug)

model <- coef(model5)
sd(model)
mean(model)
sum(model)

lug <- coef(model6)
sd(lug)
mean(lug)
sum(lug)

#temporary solution to extracting top3 information
d8 <- top3
d8$score <- top3$`d3$score`
d8$model < top3$`d3$model`
d8$lug <- top3$`d3$lug`
d8$token <- top3$`d3$token`

#try to create a multilevel analysis model using the component variable as fixed effects 
#and the two steady components as random effects/grouping, not sure if correct
baseline <- lme(score ~ lug,data=d8,random=~1|token,method="ML")
summary(baseline)

#use a linear model for the same purpose
model0 <- lm(d3$score~d3$lug,data=top3,na.action=na.exclude)
summary(model0)
