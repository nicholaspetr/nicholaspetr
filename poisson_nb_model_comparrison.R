install.packages('AER')
library(MASS)
library(AER)

# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Linear and NonLinear Models/week5_/"

# Sample test data has one predictor and output. We are testing to see which type of model is better suited for the data 
test_dat <- read.table(paste(dataPath,'Week5_Test_Sample.csv',sep = '/'), header=TRUE)
head(test_dat)

glm.poisson.fit = glm(Output~Predictor,family=poisson,data=test_dat)
summary(glm.poisson.fit)

glm.nb.fit = glm.nb(Output~Predictor,test_dat)
summary(glm.nb.fit)

dispersion.test.p.value = as.double(pchisq(deviance(glm.poisson.fit),df.residual(glm.poisson.fit),lower=F))

theta = as.double(glm.nb.fit$theta)

predicted.values = glm.nb.fit$fitted.values

res <- list(predicted.values=predicted.values,  
            dispersion.test.p.value=dispersion.test.p.value,
            theta = theta)

saveRDS(res, file = paste(dataPath,'result.rds',sep = '/'))
