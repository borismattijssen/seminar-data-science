library(rstudioapi)
library(robustHD)
library(car)

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
model2 <- lm(score ~ topic, data = d2, na.action = na.exclude)
anova(model2)

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
model0 <- lm(score ~ 1, data = d3, na.action = na.exclude)
model1 <- lm(score ~ lug + token + model, data = d2, na.action = na.exclude)
model2 <- lm(score ~ token, data = d3, na.action = na.exclude)
model3 <- lm(score ~ model, data = d3, na.action = na.exclude)
anova(model1)
