# use rstudioapi package to get file directory
library(rstudioapi)

# set working directory to match this file's directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load the webvisit file (2 + 25 + 24 mod 3 = 0)
WebVisit <- read.csv(file="./webvisit0.csv", header=TRUE, sep=",")

# plot the page visits in a histogram
hist(WebVisit$pages)

# model 
model <- lm(pages ~ version + portal + version:portal , data = WebVisit, na.action = na.exclude)

# TODO
WebVisit$simple <- interaction(WebVisit$version, WebVisit$portal) 
levels(WebVisit$simple)

simpleEffectModel <-lm(pages ~ simple , data = WebVisit, na.action = na.exclude)
anova(simpleEffectModel)