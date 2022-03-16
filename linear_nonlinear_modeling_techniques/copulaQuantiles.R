library(VineCopula)
library(copula)

# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Linear and NonLinear Models/week3_copulas/"

dat <- readRDS(paste(dataPath,'test_sample.rds',sep = '/'))

copulaType = c("normal")

# X=Exponential Distro with rate 1
X<-pexp(dat$predictor, rate=0.4)
# Y is lognormal with mean 4 and sd 0.2
Y<-plnorm(dat$output, mean=4, sd=0.2)

fittedCopula_obj<-normalCopula(dim=2)
fittedCopula<-fitCopula(fittedCopula_obj,empCopula,"ml")
(theta<-fittedCopula@estimate)

plot(X,Y)

empCopula<-(cbind(X,Y))
plot(empCopula)

fittedCopula_obj<-normalCopula(dim=2)
fittedCopula<-fitCopula(fittedCopula_obj,empCopula,"ml")
(theta<-fittedCopula@estimate)

quantileLow = as.double(pnorm(qnorm(0.05)*sqrt(1-(theta^2))+theta*qnorm(empCopula[,1])))

quantileMid = as.double(pnorm(qnorm(0.5)*sqrt(1-(theta^2))+theta*qnorm(empCopula[,1])))

quantileHigh = as.double(pnorm(qnorm(0.95)*sqrt(1-(theta^2))+theta*qnorm(empCopula[,1])))

# Plot the copula quantiles to see if it aligns with copula
plot(empCopula)
points(empCopula[,1],quantileLow,col="orange",pch=16)
points(empCopula[,1],quantileMid,col="cyan",pch=16)
points(empCopula[,1],quantileHigh,col="orange")


res <- list(copulaType = copulaType,
            quantileLow=quantileLow_orig,
            quantileMid=quantileMid_orig,
            quantileHigh=quantileHigh_orig
)

saveRDS(res, file = paste(dataPath,'workshop_result.rds',sep = '/'))
