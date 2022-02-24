# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Statistical Analysis"

test_dat <- read.table(paste(dataPath,'Week7_Test_Sample.csv',sep = '/'), header=TRUE)
head(test_dat)

# 1.2 Fit linear models using: no inputs, only Input1, only Input2, both Input1 and Input2.
fit.1<-lm(Output~1,data=test_dat)
fit.1.2<-lm(Output~1+Input1,data=test_dat)
fit.1.3<-lm(Output~1+Input2,data=test_dat)
fit.1.2.3<-lm(Output~.,data=test_dat)

# 2 Compare ANOVA table of each fit with the summary 
# 2.1 Outputs of anova().
anova(fit.1.2)

# Explain the following outputs and calculate them using only data and linear model fit (for example, Regression.ANOVA.Data and fit.1.2):
anova(fit.1.2)$Df

# Sum of Squares: Total variation that can be attributed to various factors. 
# Comparing it to Mean Sq (dividing by DF) lets you compare the ratios and determine if there is a significant difference due to your input variables
anova(fit.1.2)$"Sum Sq"

# F Value: Is the variance between the means of two populations significantly different. We want it to match the F Stat we see in the lm summary for the model 
anova(fit.1.2)$"F value"[1]

# This is the p-value. We want it to match what we see in the lm output. Low p values indicate strong evidence against the null hypothesis (there is no difference in means)
anova(fit.1.2)$"Pr(>F)"[1]
# What does "<2.2e-16" mean in the output of anova()? ANSWER: This is your p value

# 2.2 Compare summary(fit.1) and anova(fit.1)
summary(fit.1)

anova(fit.1)

# Note that anova(fit.1)$"Sum Sq" is the same as sum(fit.1$residuals^2)
c(anova(fit.1)$"Sum Sq",sum(fit.1$residuals^2))

# and the numbers of degrees of freedom are also the same
c(anova(fit.1)$Df,fit.1$df.residual,summary(fit.1)$df[2])

# Why anova table does not show fields F value and Pr(>F)? ANSWER: I believe it is because those are stats to compare means, and this lm only looks at the output variable
# The anova table also does not have a residuals row because we are just looking at output variable. Therefore we Sum Sq is total sum of squares, since there are not residuals 
#Remember, residuals are the sum of squares unexplained by the model fit 

# 2.3 Compare summary(fit.1.2) and anova(fit.1.2): This is not a well-fit model
summary(fit.1.2)

anova(fit.1.2)
# Note here that the sum of squares explained by the model fit is only 2.86, compared to the residuals being 534.31 (SSE, or sum of squares unexplained by the model fit)
# This would indicate this variable does not explain much of all about the output variable

# F-statistic and Pr(>F) in both outputs are equivalent
summary(fit.1.2)$fstatistic

# What is H0 for F value in anova(fit.1.2) and for F-ststistic in summary(fit.1.2)?
# Obtain R2 from anova() and calculate it manually
summary(fit.1.2)$r.squared
# R squared value is not good at all here 

# 2.4 Compare summary(fit.1.3) and anova(fit.1.3)
summary(fit.1.3)

anova(fit.1.3)
# We see here that a lot more of the sum of squares is explained by the model fit, while the residuals are less. This means the variable does a better job correlating to output

# What do you conclude from the anova table? ANSWER: This model seems to be much better fit than 1.2
  
# Compare F-values
c(F.value=anova(fit.1.3)$"F value"[1],Df=anova(fit.1.3)$Df,P.value=anova(fit.1.3)$"Pr(>F)"[1])

# What do you conclude from the F-statistic and its p-value? P value indicates we can reject null hypothesis that means are the same (good). Unclear of f stat
#   What is the minimum level for which you reject the null hypothesis?
#   What is the null hypothesis of this F-test? That both means are the same, meaning there is not a significant impact coming from input variable 

# 2.5 Compare summary(fit.1.2.3) and anova(fit.1.2.3)
summary(fit.1.2.3)
# We can see here that the model is a good fit. Slightly better than 1.3, but Input 1 is not doing much at all to sway this

anova(fit.1.2.3) # Need more insight on what to conclude from anova test 
# We can see that the residuals only get slightly better from 1.3 to 1.2.3, indicating again the 1.2 is not helping explain much of the output 

# Compare F-statistic and R2 values.



summary(ANOVA)[[1]][1,6]

# Homework Answers

# 1) Sum of Squares explained by Input1 in model fit.1.2: 2.86

# 2) Sum of Squares unexplained by Input1 in model fit.1.2: 534.31

# 3) Sum of Squares explained by Input2 in model fit.1.3: 356.26

# 4) Sum of Squares unexplained by Input2 in model fit.1.3: 180.91

# 5) F statistic for comparison of fit.1 and fit.1.2.3: 492.6429

# 6) P-value for comparison of fit.1 with fit.1.2.3: 

# 7) Which inputs should be removed? First



ANOVA<-anova(fit.1,fit.1.2.3)

anova(fit.1,fit.1.2.3)

c(anova(fit.1,fit.1.2.3)$F[2],summary(fit.1.2.3)$"p-value"[1])


anova(fit.1,fit.1.2.3)$"Pr(>F)"

anova(fit.1,fit.1.2.3)$"Pr(>F)"[2]

test<-anova(fit.1,fit.1.2.3)

test$`Pr(>F)`

summary(fit.1.2.3)$coefficients[,4]  


anova(fit.1,fit.1.2.3)

anova(fit.1,fit.1.2.3)$"Pr(>F)"[2]


c(F.value=anova(fit.1,fit.1.2.3)$"F value"[1],Df=anova(fit.1,fit.1.2.3)$Df,P.value=anova(fit.1,fit.1.2.3)$"Pr(>F)"[2])

anova(fit.1,fit.1.2.3)
