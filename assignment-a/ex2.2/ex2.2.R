# use rstudioapi package to get file directory
library(rstudioapi)

# set working directory to match this file's directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load the webvisit file (2 + 25 + 24 mod 3 = 0)
WebVisit <- read.csv(file="./webvisit0.csv", header=TRUE, sep=",")

# plot the page visits in a histogram
hist(WebVisit[WebVisit[, "version"] == 0,]$pages, main="Version == 0")
hist(WebVisit[WebVisit[, "version"] == 1,]$pages, main="Version == 1")
hist(WebVisit[WebVisit[, "portal"] == 0,]$pages, main="Portal == 0")
hist(WebVisit[WebVisit[, "portal"] == 1,]$pages, main="Portal == 1")

# shapiro-wilk test for normal distribution
shapiro.test(WebVisit$pages)

# model analysis
model <- glm(pages ~ version + portal + version:portal, data = WebVisit, family=poisson(), na.action = na.exclude)
anova(model,test="Chisq")

# do the simple effect analysis
WebVisit$simple <- interaction(WebVisit$version, WebVisit$portal) 
simpleEffectModel <-glm(pages ~ simple , data = WebVisit, family=poisson(), na.action = na.exclude)
summary.glm(simpleEffectModel)
