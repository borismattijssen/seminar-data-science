#  CS4125 Seminar Research Methodology for Data Science - Lecture 4 - Generalized linear models
# 2018
#
# Data file used in the script
#   exam marks2004-2007_equal_year_sample.sav
#   examples_Chi.sav
#   feedback experiment.sav
#   mobile phone (interacting with computers).sav
#   MobilePhone and Skin Design Survey.sav
#   mp3playersurvey.sav
#
################################
library(foreign)
library(car) #Package includes Levene's test 
library(tidyr)  # for wide to long format transformation of the data
library(ggplot2)
library(QuantPsyc) #include lm.beta()
library(gmodels)
library(rstudioapi)

################ Functions

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

# set working directory to match this file's directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# sink("output-lecture.txt")  # divert R output to file
################# Chi-square


Lec4a <- read.spss("examples_Chi.sav", use.value.labels=TRUE, to.data.frame=TRUE)
CrossTable(Lec4a$UI_type, Lec4a$task_completed, fisher = FALSE, chisq = TRUE, expected = TRUE, sresid = TRUE)


##################### comparing with constant ####################
Lec7c <- read.spss("mp3playersurvey.sav", use.value.labels=TRUE, to.data.frame=TRUE)
mean(Lec7c$FileAvg)
sd(Lec7c$FileAvg)

model0 <- lm(I(FileAvg - 5.29) ~ 1, data = Lec7c,na.action = na.exclude)
summary(model0)

### analyses of normality of the sample and the residuals
hist(Lec7c$FileAvg) # so this data is not normal distibuted!
shapiro.test(Lec7c$FileAvg)
hist(resid(model0))
shapiro.test(resid(model0))

## alternative way to compare a constant (One-Sample t-test)

t.test(Lec7c$FileAvg, mu=5.29)

################ Comparing two groups ###############
Lec7d <- read.spss("feedback experiment.sav", use.value.labels=TRUE, to.data.frame=TRUE)
lec7dsub <- subset(Lec7d, (Feedback != "V"))  # filter out the video feedback condition from the data

model0<- lm(Post_score ~ 1, data = lec7dsub)            #model without predictor
model1 <- lm(Post_score ~ Feedback, data = lec7dsub)    #model with predictor
anova(model0,model1, test = "F")                        #compare if model1 provide better fitt than model0

summary(model1)
anova(model1) #print results in anova format

### examine assumptions
hist(Lec7d$Post_score) 
shapiro.test(Lec7d$Post_score)
hist(resid(model1))
shapiro.test(resid(model1))

aggregate(lec7dsub$Post_score~lec7dsub$Feedback, FUN=mean) # mean Postcode for each type of Feedback
aggregate(lec7dsub$Post_score~lec7dsub$Feedback, FUN=sd)


leveneTest(lec7dsub$Post_score, lec7dsub$Feedback, center = median)
# center = mean gives same results as SPSS, default is center = median, apparently preferred 

## alternative way to compare two independent groups
t.test(Post_score ~ Feedback, data = lec7dsub, paired = FALSE, var.equal = TRUE, na.action = na.exclude)
#var.equal = FALSE is the defaults setting. If leveneTest is sign. consider put var.equal = FALSE


############### Paired-Sample comparison ######################
Lec7e <- read.spss("feedback experiment.sav", use.value.labels=TRUE, to.data.frame=TRUE)
subject <- c(1:91) # add participants numbers
Lec7e <-cbind(Lec7e,subject)
Lec7e$subject <-factor(Lec7e$subject)

#data is wide format (i.e. pre and post score seperate varaibles) need to be transformed into longformat (i.e measurement in single variable)
Lec7e_long <-  gather(Lec7e, condition, measurement, Pre_score, Post_score)
Lec7e_long$condition <- factor(Lec7e_long$condition)
m <- aov(measurement ~ condition + Error(subject/condition), data =Lec7e_long ) # Error term let r know that "condition within subject", i.e. condition is nested within subjects
summary(m)
coefficients(m)

### 3 alternative ways of comparing two paired variables 
# alternative 1
Lec7e$delta_score <-Lec7e$Post_score-Lec7e$Pre_score

m1 <- lm(delta_score ~ 1, data = Lec7e)
summary(m1)

# alternative 2
t.test(Lec7e$Pre_score, Lec7e$Post_score, paired = TRUE)

# alternative 3
library(ez)
m3 <- ezANOVA(data = Lec7e_long, dv = .(measurement), wid = .(subject), within = .(condition), detailed = TRUE, type =3)
m3

################## Comparing multiple levels (One-way ANOVA) ###########
Lec7f <- read.spss("exam marks2004-2007_equal_year_sample.sav", use.value.labels=TRUE, to.data.frame=TRUE)
Lec7f$yearF <- factor(Lec7f$year, levels = c(2004:2007), labels = c(2004:2007)) # in this example year is considered an nominal factor

model0 <- lm(t_term1 ~ 1, data = Lec7f, na.action = na.exclude)
model1 <- lm(t_term1 ~ yearF, data = Lec7f, na.action = na.exclude)
anova(model0,model1)
summary(model1)

anova(model1) # provide the output in ANOVA style

#### examine assumptions
tapply(Lec7f$t_term1,Lec7f$yearF, shapiro.test) # test normaliy of each level
leveneTest(Lec7f$t_term1, Lec7f$yearF)
plot(model1)


Lec7f$unstandardizedResiduals <- resid(model1)
hp <- ggplot(Lec7f, aes(x= unstandardizedResiduals)) + 
  geom_histogram() +
  labs(title="distribution residuals")
hp + facet_grid(.~yearF)

### alternative ways of analysing

#1. alternative when variance is not equal across groups (Welch's F test)

oneway.test(t_term1 ~ yearF, data = Lec7f, na.action = na.exclude)

#2. other output formt
model <- aov(t_term1 ~ yearF, data = Lec7f, na.action = na.exclude)
summary(model)

########## ########## Post-Hoc testing  #########

pairwise.t.test(Lec7f$t_term1, Lec7f$yearF, paired = FALSE, p.adjust.method = "bonferroni")

TukeyHSD(model) # prefered is equal sample size (which not case in this data set) and homogeneity of varience. Also note "model" is result from aov function


########### Multiple Factors ###########################

Lec7g <- read.spss("mobile phone (interacting with computers).sav", use.value.labels=TRUE, to.data.frame=TRUE)
leveneTest(Lec7g$qakeyboa, interaction(Lec7g$keypad , Lec7g$sms)) #to test homogeneity accross all 4 conditions
bar <- ggplot(Lec7g, aes(sms , qakeyboa, fill = keypad))
bar + stat_summary(fun.y = mean, geom = "bar", position="dodge")

model0 <- lm(qakeyboa ~ 1 , data = Lec7g, na.action = na.exclude)
model1 <- lm(qakeyboa ~ keypad  , data = Lec7g, na.action = na.exclude)
model2 <- lm(qakeyboa ~ sms , data = Lec7g, na.action = na.exclude)
model3 <- lm(qakeyboa ~ keypad + sms , data = Lec7g, na.action = na.exclude)
model4 <- lm(qakeyboa ~ keypad + sms + keypad:sms , data = Lec7g, na.action = na.exclude)

anova(model0,model1)
anova(model0,model2)
anova(model3,model4)

summary(model4)
anova(model4)





###################################### Simple Effect analaysis to analyse the interaction effect

Lec7g$simple <- interaction(Lec7g$keypad, Lec7g$sms) #merge two factors into one factor with 4 levels
levels(Lec7g$simple) #to see the level in the new factor
contractSimple <-c(1,-1,0,0) #looking only at the condition phone sms function had Simple implementation, comparing keypad  Repeat-Key and Modified Modal implementation
contractComplex <-c(0,0,1,-1) #looking only at the condition phone sms function had Complex implementation, comparing keypad  Repeat-Key and Modified Modal implementation
SimpleEff <- cbind(contractSimple,contractComplex)
contrasts(Lec7g$simple) <- SimpleEff #now we link the two contrasts with the factor simple
simpleEffectModel <-lm(qakeyboa ~ simple , data = Lec7g, na.action = na.exclude)
summary.lm(simpleEffectModel)


############################################## Interval level independent variables (Regression Analysis) ##############
Lec8d <- read.spss("MobilePhone and Skin Design Survey.sav", use.value.labels=TRUE, to.data.frame=TRUE)

#first remove missing values as model comparison might give errors
subset <-Lec8d[, c("att_ph", "phone", "sn_ph", "gender", "n", "e")]
Lec8d <-na.omit(subset)

model0 <-lm(phone ~ 1 , data = Lec8d, na.action = na.exclude )
model1 <-lm(phone ~ att_ph , data = Lec8d, na.action = na.exclude )
model2 <-lm(phone ~ att_ph + e  , data = Lec8d, na.action = na.exclude )
anova(model0, model1, model2)

summary(model2)
confint(model2) #gives CI95% of the estimates (B-values)
lm.beta(model2) #give standardized Beta values


###### Assumption tests 

#testing independence of error
durbinWatsonTest(model2)

#test of multicollinearity
vif(model2)
1/vif(model2) # Tolerance

### histogram of studentized residual to check if normal distributed
hist(model2$residuals)
hist(rstudent(model2))
plot(model2$residuals, model2$fitted)
plot(model2)

#### checking model
Lec8d$predicted.probabilities <-fitted(model2)
#explore last 20 cases
head(Lec8d[, c("phone", "att_ph", "e", "predicted.probabilities" )], n=20L)

#explore leverage should be around (number of predictors+1)/sample size, so (2+1)/83 = 0.036
#explore studentized residual only 5% outside 1.96, and 1% outside 2.58
#explore DFBeta should be less than 1
Lec8d$studentized.residuals<-rstudent(model2)
Lec8d$dfbeta<-dfbeta(model2)
Lec8d$leverage<-hatvalues(model2)
Lec8d[, c("leverage", "studentized.residuals", "dfbeta")]

################################### Logistic Regression  #####################
Lec8e <- read.spss("MobilePhone and Skin Design Survey.sav", use.value.labels=TRUE, to.data.frame=TRUE)
subset <-Lec8e[, c("att_ph", "phone", "sn_ph")]
Lec8e <-na.omit(subset)
Lec8e$phoneYN[Lec8e$phone >=3] <- 1
Lec8e$phoneYN[Lec8e$phone <3] <- 0
Lec8e$phoneYN<-factor(Lec8e$phoneYN, levels = c(0:1), labels = c("No","Yes"))

#Centering predictors, this will make easier to interpret predictors
Lec8e$att_phC <-Lec8e$att_ph - mean(Lec8e$att_ph)
Lec8e$sn_phC <-Lec8e$sn_ph - mean(Lec8e$sn_ph)

model0 <- glm(phoneYN ~ 1, data = Lec8e, family = binomial())
model1 <- glm(phoneYN ~ att_phC , data = Lec8e, family = binomial())
model2 <- glm(phoneYN ~ att_phC + sn_phC, data = Lec8e, family = binomial())

anova(model0,model1,model2,test = "Chisq" )

summary(model1)


Lec8e$phoneYNpred[fitted(model1) <=0.5] <- 0
Lec8e$phoneYNpred[fitted(model1) > 0.5] <- 1
Lec8e$phoneYNpred<-factor(Lec8e$phoneYNpred, levels = c(0:1), labels = c("No","Yes"))
table(Lec8e$phoneYN, Lec8e$phoneYNpred)


### examine fitt
CrossTable(Lec8e$phoneYNpred, Lec8e$phoneYN, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, fisher=FALSE, chisq=FALSE, expected = FALSE)
logisticPseudoR2s(model1)


#odds ratio
exp(model1$coefficients)
#CI95% of odds ratio
exp(confint(model1))

#### checking model
Lec8e$predicted.probabilities <-fitted(model1)
#explore first few cases
head(Lec8e[, c("phoneYN","att_phC", "phoneYNpred", "predicted.probabilities" )])

#explore leverage should be around (number of predictors+1)/sample size, so (1+1)/106 =0.0188
#explore studentized residual only 5% outside 1.96, and 1% outside 2.58, case 3 need inspection
#explore DFBeta should be less than 1
Lec8e$studentized.residuals<-rstudent(model1)
Lec8e$dfbeta<-dfbeta(model1)
Lec8e$leverage<-hatvalues(model1)
Lec8e[, c("leverage", "studentized.residuals", "dfbeta")]

### histogram of studentized residual to check if normal distributed

hist(rstudent(model1))
plot(rstandard(model1), fitted(model1))

plot(model1)

#check for multicollinearity
1/vif(model2) #as model1 only has 1 predictor

sink() #stop diverting R output to file