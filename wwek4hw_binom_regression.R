

# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Linear and NonLinear Models/week4_binom_regression/"

train_dat <- read.table(paste(dataPath,'Week4_Test_Sample_Train.csv',sep = '/'), header=TRUE)
test_dat <- read.table(paste(dataPath,'Week4_Test_Sample_Test.csv',sep = '/'), header=TRUE)

#train_dat$Predictor2 <- factor(train_dat$Predictor2)
#contrasts(train_dat$Predictor2)

# Run glm for logit and probit link on training data and review output 
glm.logit<-glm(Output~Predictor1+Predictor2,family=binomial,data=train_dat)
glm.probit<-glm(Output~Predictor1+Predictor2,family=binomial(link="probit"),data=train_dat)

summary(glm.logit)
#Coefficients 
# For every one unit change in predictor1, the log odds of a positive (1) increase by 1.0889. 
# For a one unit increase in predictor2, the log odds of being admitted to graduate school decrease by -0.4417 
# Predictor1 is statistically significant, Predictor2 is not


# The test statistic is distributed chi-squared with degrees of freedom equal to the differences in degrees of freedom between the current and the null model (i.e., the number of predictor variables in the model). 
# To find the difference in deviance for the two models (i.e., the test statistic) we can use the command:
with(glm.logit, null.deviance - deviance)
with(glm.logit, df.null - df.residual)
# Finally, the p-value can be obtained using:
with(glm.logit, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))
# p-value is less than 0.001 telling us that our model as a whole fits significantly better than an empty model

# If you want to see the log likelihood of the model 
logLik(glm.logit)

# Get the predicted probabilities of success (1) for test data by incorporating training data model
Predicted.glm.logit = predict(glm.logit,type="response",newdata=data.frame(test_dat))
Predicted.glm.probit = predict(glm.probit,type="response",newdata=data.frame(test_dat))

# Convert the probabilities to 0/1 predictions 
Predicted.Output.logit = rep(0, dim(train_dat)[1])
Predicted.Output.logit[Predicted.glm.logit > .5] = 1

Predicted.Output.probit = rep(0, dim(train_dat)[1])
Predicted.Output.probit[Predicted.glm.probit > .5] = 1

# Save and export 
res <- list(Predicted.Output.logit=Predicted.Output.logit,
            Predicted.Output.probit=Predicted.Output.probit)

write.table(res, file = paste(dataPath,'result.csv',sep = '/'), row.names = F)
