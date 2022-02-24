install.packages("caret")
library(caret)

# Create variable dataPath equal to path to your local folder where you saved the data file Week4_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Statistical Analysis"

dat <- read.table(paste(dataPath,'Week4_Test_Sample.csv',sep = '/'), header=TRUE)

head(dat)

# Plot the Data (X as input, Y as output)
plot(dat$X,dat$Y)

# 2 Fitting linear model
# Estimate linear model using function lm() look at the output of the function
Estimated.LinearModel <- lm(Y ~ X,data=dat)
names(Estimated.LinearModel)

# Fitted values are a prediction of the mean response value when you input the values of the predictors (what y equals when plugging X value into y =aX+b)
fitted.values(Estimated.LinearModel)


# The residual data of the simple linear regression model is the difference between the observed data of the dependent variable y and the fitted values y.
# It is calculated by taking the predicted value and subtracting it from the measured value
Estimated.Residuals = resid(Estimated.LinearModel)


plot(dat$X, Estimated.Residuals, 
          ylab="Residuals", xlab="Input Variable", 
          main="Y Predicting yhat")


# 2.2 Object of summary
# Look at the summary.
summary(Estimated.LinearModel)

# Sigma extracts the residual standard deviation (see residual standard error in the summary for Estimated Linear Model)
summary(Estimated.LinearModel)$sigma


summary(Estimated.LinearModel)$sigma^2

# 3.1 Residuals of the model

# Observe the residuals, plot them against the input.
Estimated.Residuals <- Estimated.LinearModel$residuals
plot(dat$X, Estimated.Residuals)

# probability density in comparison with the normal density
Probability.Density.Residuals <- density(Estimated.Residuals)
plot(Probability.Density.Residuals, ylim = c(0, 0.5))
lines(Probability.Density.Residuals$x, dnorm(Probability.Density.Residuals$x, 
                                             mean = mean(Estimated.Residuals), sd = sd(Estimated.Residuals)))

# 3.2 Clustering the sample

# Calculate mean values of negative residuals and positive residuals.
c(Left.Mean = mean(Estimated.Residuals[Estimated.Residuals < 0]), 
  Right.Mean = mean(Estimated.Residuals[Estimated.Residuals > 0]))

# Separate the given sample into 2 subsamples: one, for which the residuals are below zero and another, for which they are above zero.
resid_pos<-(Estimated.Residuals[Estimated.Residuals > 0])
resid_neg<-(Estimated.Residuals[Estimated.Residuals < 0])

# Separate the given sample into 2 subsamples: one, for which the residuals are below zero and another, for which they are above zero. 
# Create variable Unscrambled.Selection.Sequence estimating switching between the two subsamples (1 corresponds to the positive residual case and 0 corresponds to the negative residual case).
Unscrambled.Selection.Sequence<-ifelse(Estimated.Residuals>0 , 1 , 0 )

# Save results and upload (this concludes the homework section)
res <- list(Unscrambled.Selection.Sequence =  Unscrambled.Selection.Sequence)
write.table(res, file = paste(dataPath,'result.csv',sep = '/'), row.names = F)


plot(Unscrambled.Selection.Sequence[1:100], type = "s")


# 3.3 Confusion matrix
# There is a common measure for comparison of the estimated Unscrambled.Selection.
# Sequence and the true selection sequence that may be known from the training data set. The measure is called confusion matrix.

# Confusion matrix for comparison of Unscrambled.Selection.Sequence estimated in the project with the true selection sequence used to create the data is:

cm<-confusionMatrix(as.factor(Unscrambled.Selection.Sequence),
                    as.factor(Selection.Sequence.true))$table
cm






