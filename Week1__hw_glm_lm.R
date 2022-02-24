# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Linear and NonLinear Models/Week1_glm_MLE"

test_dat <- read.table(paste(dataPath,'Week1_Test_Sample.csv',sep = '/'), header=TRUE)

# Fit Linear model Using lm() and glm()
lmDat_lm<-lm(Output~.,data=test_dat)
lmDat_glm<-glm(Output~.,family=gaussian(link="identity"),data=test_dat)

Linear.Model.Data.lm = lmDat_lm

# Coefficients 
coefficients = (lmDat_lm$coefficients)
coefficients = as.double(coefficients)


# Residuals  
# lm
residuals = lmDat_lm$residuals
residuals = as.double(residuals)
#glm: returns same values
glm.residuals = lmDat_glm$residuals
residuals.review = cbind(residuals,glm.residuals)

# Fitted Values
#lm
fitted.values = lmDat_lm$fitted.values
fitted.values = as.double(fitted.values)
# glm: returns same values
glm.fitted.values = lmDat_glm$fitted.values
fitted.values.review = cbind(fitted.values,glm.fitted.values)

# Linear Predictors 
#lm
linear.predictors = lmDat_lm$fitted.values
linear.predictors = as.double(fitted.values)
# glm: fitted.values (y hat) in lm() = linear predictors in glm()
glm.linear.predictors = lmDat_glm$linear.predictors
linear.predictors.review = cbind(fitted.values,glm.linear.predictors)


# Deviance: This replaces R Squared for Goodness of Fit. Typically want it to be less than or equal to df  
# lm(): Deviance can be calculated from lm by taking the sum of squared residuals 
deviance = as.double(sum(lmDat_lm$residuals^2))
# glm()
deviance.glm = lmDat_glm$deviance
deviance.glm = as.double(deviance)

# AIC: Can be used as alternative of Deviance for goodness of fit 
# lm()
aic = nrow(test_dat)*(log(2*pi)+1+log((sum(lmDat_lm$residuals^2)/nrow(test_dat))))+((length(lmDat_lm$coefficients)+1)*2)
aic.lm.auto = AIC(lmDat_lm)
#glm()
aic.glm = lmDat_glm$aic
aic.glm = as.double(aic)

# Y (Output). Will just be Y output for gaussian model, but will help us with non-gaussian
# lm()
y = test_dat[,1]
y = as.double(y)
# glm()
y.glm = lmDat_glm$y
y.glm = as.double(y)

# Null Deviance (Pulled from the Null Mode (All noise unattributed to model))
# lm()
lmDF_Null_lm<-lm(Output~1,data=test_dat)
null.deviance<-sum(lmDF_Null_lm$residuals^2)
# glm()
null.deviance.glm = lmDat_glm$null.deviance
null.deviance.glm = as.double(null.deviance)

# We can get sigma from lm() summary, square it, and compare with glm()
# lm()
dispersion = sigma(lmDat_lm)  
dispersion = as.double(dispersion*dispersion)
# glm()



res<- list(Linear.Model.Data.lm = lmDat_lm,
           coefficients = coefficients,
           residuals = residuals,
           fitted.values = fitted.values,
           linear.predictors = linear.predictors,
           deviance = deviance,
           aic = aic,
           y = y,
           null.deviance = null.deviance,
           dispersion = dispersion
)

saveRDS(res, file = paste(dataPath,'result.rds',sep = '/'))
