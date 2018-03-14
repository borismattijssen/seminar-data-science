library(rstudioapi)
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
