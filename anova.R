# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Statistical Analysis"

test_dat <- read.table(paste(dataPath,'Week8_Test_Sample.csv',sep = '/'), header=TRUE)

plot(Output~Treatment, data=test_dat, pch=19,col="black")

# Calculate summary statistics for each group.
# Create the 2-column matrix of group means and sizes.
summaryByGroup<-aggregate(Output~Treatment,data=test_dat,FUN=summary)
means<-cbind(Means=summaryByGroup$Output[,4],Sizes=aggregate(Output~Treatment,data=test_dat,FUN=length)$Output)
rownames(means)<-as.character(summaryByGroup$Treatment)
means

# 1.1 ANOVA for the data
# Fit linear model for coag~diet.
# Observe the summary, look and interpret results of fitted linear model and regression ANOVA.
test.model<-lm(Output~Treatment,data=test_dat)
modelSummary<-summary(test.model)
modelANOVA<-anova(test.model)

# Model coefficients:
modelSummary$coefficients

# Degrees of freedom:
modelSummary$df

# Estimate of the residual standard deviation and R^2:
c(Sigma=modelSummary$sigma,Rsquared=modelSummary$r.squared)

# F-statistic:
modelSummary$fstatistic

# ANOVA table:
modelANOVA

# lm output
modelSummary

# Think about the following questions:
# 1. If the formula is coag~diet then why are we getting estimates of the parameters dietB, dietC, and dietD? 
  # Intercept in this case would be your control treatment (or treatment a), otherwise known as Beta0. You are seeing what the differences are between the control and the test variables (Beta1-BetaN) 
# 2. Analize statistical significance of all parameters based on p-values and standard errors.
  # p-values of model summary are quite low, indicating we can reject the null hypothesis that there is no difference in means between the treatments 
  # std error is good for treatment c, but is less than 2 standard deviations away for treatment b 
  # std. error is better for treatment c than treatment b 
# 3. Analize the values of parameters and interpret them.
# For example, What does the value of coefficient for treatment c tell you?
  # coefficient of treatment c tells me that the mean is further away from control (A) than treatment b. std. error is also more than 2 std devs away, indicating good output
# 4. Analize the goodness of fit based on the determination coefficient (R2), F-statistic.
  # R2 value is low (.3108), indicating a low goodness of fit. This may be due to lack of sample size. F statistic is quite high, indicating large difference between SSM and SSE
# 5. Analyze the residuals.
  # Looking at the plots of the residuals below, they looks to be normally distributed via gaussian distr in hist and correlation with residual line up to 2 std. devs 

plot(test.model$residuals)
hist(test.model$residuals) # Generally distributed normally 

qqnorm(test.model$residuals)
qqline(test.model$residuals)

# Create matrix with dummy variable inputs for ANOVA.
# Why are we creating 3 input variables if we are given 4 groups? # Because the first group is the control we are testing againt. A is Beta 0 in this case 
# We want to see if Beta1 (B) and Beta2 (C) are significant 
test<-test_dat
test$x1<-test$Treatment=="B"
test$x2<-test$Treatment=="C"
test

# Compare the calculated sums of squares with
anova(test.model)

# 2 Experiment design
# Check what experiment plan (basis) R uses in lm:
model.matrix(test.model)
# Explain the meaning of this matrix.
  # If we had the intercept column (A) with all 1's, we would have an omnibus test: Beta1 = Beta2 = 0
  # That is good for testing if all slopes are not significant from 0, but not identifying WHICH groups may be significant from 0
  # To adjust and see which groups may be significant, we use the above matrix 

# Fit alternative model without intercept.
# Check its experiment plan (basis).
test.altmodel<-lm(Output~Treatment-1,data=test_dat)
summary(test.altmodel)

# We can see in the anova test that the SSM is much higher than the standard model 
# The alt model null hypothesis is all group mean values are equal to zero. We can see based on SSM/SSE and p-value that this can definitively be rejected 
anova(test.altmodel)

# Looking at the model with the intercept, the null hypothesis is all slopes (differences between means) are zeros (is there is difference b/t control and treatment groups)
# We can see that, while the SSM is much lower, there is still a high F Stat and p-value, indicating we can asusme there is a difference b/t control and treatment groups 
anova(test.model)

summary(test.model)

# The tukey test is another way to test differences between treatment and control. 
# You want to make sure that the number of comparisons you are testing is not greater than the total number of groups
TukeyHSD(aov(Output~Treatment,test_dat))
# We can see here that the B-A comparrison is not significant, but the C-A comparrison is very significant 
