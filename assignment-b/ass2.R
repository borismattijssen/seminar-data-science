library(rstudioapi)
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

# pick top 3 systems
systems <- aggregate(d3$score ~ d3$token + d3$lug + d3$model, FUN=mean)
s <- sort(systems$`d3$score`, index.return=TRUE, decreasing = TRUE)
top3 <- systems[s$ix[0:3],]
top3



######## Component analysis

# dataset with lug varying freely
d_lug <- subset(d3,d3$token=="terrier" & (d3$model=="dph" | d3$model=="jskls"))
model_lug <- lm(score ~ lug, data=d_lug, na.action = na.exclude)
anova(model_lug)

# dataset with model varying freely
d_model <- subset(d3,d3$token=="terrier" & (d3$lug=="snowballPorter" | d3$lug=="porter"))
model_model <- lm(score ~ model, data=d_model, na.action = na.exclude)
anova(model_model)

# dataset with token varying freely
d_token <- subset(d3,
                  (d3$model=="dph" | d3$model=="jskls")  &
                  (d3$lug=="snowballPorter" | d3$lug=="porter")
            )
model_token <- lm(score ~ token, data=d_token, na.action = na.exclude)
anova(model_token)