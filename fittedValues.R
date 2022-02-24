
# Create variable dataPath equal to path to your local folder where you saved the data file Week5_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Statistical Analysis"

dat <- read.table(paste(dataPath,'Week5_Test_Sample.csv',sep = '/'), header=TRUE)

plot(dat$Input,dat$Output, type="p",pch=19)

nSample<-length(dat$Input)

# 1.2 Estimate linear model
# Fit linear model to the data and plot the sample and the fitted values.

#Estimated.Linear.Model.Case2<-lm(Output~Input,LinearModel.Case2)
m1<-lm(Output~Input,dat)
m1$coefficients

matplot(dat$Input,cbind(dat$Output,m1$fitted.values),type="p",pch=16,ylab="Sample and Fitted Values")

summary(m1)

# Analize the residuals, plot them.
#EstimatedResiduals.Case2<-Estimated.Linear.Model.Case2$residuals
estimatedResiduals<-m1$residuals
plot(dat$Input,estimatedResiduals)

# probability density function (probability of getting random variable X is the y axis, values are x-axis. Two different curves are expected (guassian) and actual (gaussian-ish))
Probability.Density.Residuals<-density(estimatedResiduals)
plot(Probability.Density.Residuals,ylim=c(0,.5))
lines(Probability.Density.Residuals$x,
      dnorm(Probability.Density.Residuals$x,mean=mean(estimatedResiduals),sd=sd(estimatedResiduals)))

# Calculate e (difference between estimated and actaul values). RED LINE
Estimated.Residuals = resid(m1)

# Fit the estimated regression line. This is y hat (or estimated y values). PINK LINE
coeffs = coefficients(m1)
y1_manual=coeffs[1] + coeffs[2]*dat$Input #manual way to fit (y=slopeX+intercept)
y1=m1$fitted.values # this pulls the fitted values from the m1 regression (easy way)

# Calculate yi (yi=B1+B2*x+sigma)
Beta1<-m1$fitted.values-mean(m1$fitted.values)

yi<-(mean(m1$fitted.values)+Beta1*dat$Input)
head(yi)


# Calculate (y???ybar)^2, actual outputs minus y bar (which is a vector of the mean of y) squared. DARK BLUE 
y.minus.ybar.sq<-(dat$Output-mean(dat$Output))^2

# Calculate (yi-ybar)^2, expected outputs minus y bar. LIGHT BLUE 
clusteringParabola<-(m1$fitted.values-mean(dat$Output))^2

plot(dat$Input,(dat$Output-mean(dat$Output))^2, type="p",pch=19,
     ylab="Squared Deviations")
points(dat$Input,clusteringParabola,pch=19,col="red")

# Define the separating sequence Unscrambling.Sequence.Steeper.var, such that it is equal to TRUE for steeper slope subsample and FALSE for flatter slope subsample.
# Logic: If actual outputs minus average (y-ybar) are greater than expected values minus average (yhat-ybar) the TRUE, else FALSE. 
Unscrambling.Sequence.Steeper.var<-ifelse(y.minus.ybar.sq>clusteringParabola , TRUE , FALSE )

head(Unscrambling.Sequence.Steeper.var,10)

# Separate the sample into steeper and flatter part. Create data frames. Define two subsamples with NAs in the Output columns
Subsample.Steeper.var<-
  data.frame(steeperInput.var=dat$Input,steeperOutput.var=rep(NA,nSample))
Subsample.Flatter.var<-
  data.frame(flatterInput.var=dat$Input,flatterOutput.var=rep(NA,nSample))

# Fill in the unscrambled outputs instead of NAs where necessary
Subsample.Steeper.var[Unscrambling.Sequence.Steeper.var,2]<-
  dat[Unscrambling.Sequence.Steeper.var,1]
Subsample.Flatter.var[!Unscrambling.Sequence.Steeper.var,2]<-
  dat[!Unscrambling.Sequence.Steeper.var,1]

# Check the first 10 rows
head(cbind(dat,Subsample.Steeper.var,Subsample.Flatter.var),10)


# Plot clusters of the variance data and the separating parabola
plot(dat$Input,
     (dat$Output-mean(dat$Output))^2,
     type="p",pch=19,ylab="Squared Deviations")
points(dat$Input,clusteringParabola,pch=19,col="red")
points(dat$Input[Unscrambling.Sequence.Steeper.var],
       (dat$Output[Unscrambling.Sequence.Steeper.var]-
          mean(dat$Output))^2,
       pch=19,col="blue")
points(dat$Input[!Unscrambling.Sequence.Steeper.var],
       (dat$Output[!Unscrambling.Sequence.Steeper.var]-
          mean(dat$Output))^2,
       pch=19,col="green")


# Plot the unscrambled subsamples, include the original entire sample as a check. (WHY IS THIS NOT WORKING)
excludeMiddle<-(dat$Input<=mean(dat$Input)-0)|
  (dat$Input>=mean(dat$Input)+0)
matplot(dat$Input[excludeMiddle],cbind(dat$Output[excludeMiddle],
                                       Subsample.Steeper.var$steeperOutput.var[excludeMiddle],
                                       Subsample.Flatter.var$flatterOutput.var[excludeMiddle]),
        type="p",col=c("black","green","blue"),
        pch=16,ylab="Separated Subsamples")


# Fit linear models to the separated samples

# Linear Model for entire population
GeneralModel<-lm(Output~Input,dat)
summary(GeneralModel)

# Linear model for steep slope population
mSteep<-lm(steeperOutput.var~steeperInput.var,Subsample.Steeper.var)
summary(mSteep)

# Linear model for flat slope population
mFlat<-lm(flatterOutput.var~flatterInput.var,Subsample.Flatter.var)
summary(mFlat)

res <- list( GeneralModel = GeneralModel,mSteep = mSteep,mFlat = mFlat)

saveRDS(res, file = paste(dataPath,'result.rds',sep = '/'))

# Print out the coefficients of both models for the training sample.
rbind(Steeper.Coefficients=mSteep$coefficients,
      Flatter.Coefficients=mFlat$coefficients)


# Plot the entire sample with the fitted regression lines estimated from both training subsamples.
plot(dat$Input,dat$Output, type="p",pch=19)
lines(dat$Input,predict(mSteep,
                        data.frame(trainSteepInput=dat$Input),
                        interval="prediction")[,1],col="red",lwd=3)
lines(dat$Input,predict(mFlat,data.frame(trainFlatInput=dat$Input),
                        interval="prediction")[,1],col="green",lwd=3)


absolute value of y-ybar>absolute values of y hat-ybar when steeper 

y bar for estimated and actua outputs is the same 
