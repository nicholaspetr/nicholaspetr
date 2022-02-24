library(relaimpo)

# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Dropbox/PC/Desktop/Statistical Analysis"

test_dat <- read.table(paste(dataPath,'Week9_Test_Sample.csv',sep = '/'), header=TRUE)

dim(test_dat)

# The first column is the type: response variable. The features are Pred1 through Pred 10
head(test_dat)

# Separate the response variable so we can use princomp to test the importance of the predictor variables 
pred<-test_dat[,-1]
head(pred)

# Importance of Factors using princomp (Figuring out how many factors will lead us to an acceptable threshold)
PCA.Yields<-princomp(pred)
names(PCA.Yields)

# 1. What is the smallest number of factors sufficient for explanation of at least: 97.67194 % of the total variance of predictors?
# ANSWER: Looking at the PCA.Yeilds Cumulative Proportion output, we can see that it will take 3 factors to reach the listed threshold to fit our model 
summary(PCA.Yields)

# 2. Which are the factors selected in question 1?
# ANSWER: This would just be the first 3 factors that get you to your required threshold (Factor 1, Factor 2, Factor 3)
plot(PCA.Yields)


# 3). Fit another linear model with the same response, but predictors replaced by principal components (factors). 
# Which principal components you decide to include in such linear model if you are asked to achive R^2 of at least `0.9*r.squared`, 
# where `r.squared` is R-squared of the model with all original predictors?

# Step 1: Develop a model using original predictors to get the original R Squared 
orig_model = lm(Resp ~ ., data = test_dat)

# Step 2: Multiply R Squared against 0.9 to get required target 
target_required = 0.9 * summary(orig_model)$r.squared

# Step 3: Run principal component analysis to get PCA scores amd combine w. response variable
pca_obj = princomp(test_dat[,-1] - apply(test_dat[,-1], 2, mean))
comps = data.frame(Resp = test_dat[,1], pca_obj$scores)

# Step 4: Generate model using comps dataset instead of original dataset
comp_model = lm(Resp ~ ., data = comps)
summary(comp_model)

# Step 5: Use Relimp to find relative importance of each component as it relates to R Squared 

# Relimp shows us how each component factors into the R Squared value 
metrics.comp.pca = calc.relimp(comp_model, type = c("lmg"))
metrics.comp.pca
# Adding up lmg values will give you the R Squared value (see comparison here)
sum(metrics.comp.pca$lmg)
summary(comp_model)

# Show which components had the largest impact on R Squared by ranking them (which have largest impact on explaining Y)
metrics.comp.pca$lmg.rank
# Order of Importance: 1, 3, 7, 6, ...

# Step 6: 
# Order Components by Importance 
orderComponents = c(1, 3, 7, 6, 10, 8, 4, 2, 9, 5)

# Re-order comps df by importance 
Resp_Comp.Reordered = comps[,c(1, orderComponents+1)]

# Step 8: Use apply function to calculate how each comp adds to total R Squared Score
# Determine how many components are needed to reach target
nestedRSquared = sapply(2:11, function(z) summary(lm(Resp ~ . , data = Resp_Comp.Reordered[,1:z]))$r.squared)

nestedRSquared
target_required
# ANSWER: Target is 0.890. We reach that with the first component. Therefore, answer = Factor 1









# Factors and Loading's (Figuring out which factors are most important)

# Create Covariance Matrix where everything is centered
cvar = cov(pred - apply(pred, 2, mean))

# Generate eigenvalues and eigenvectors manually 
e = eigen(cvar)
e$values
# Eigenvectors are the weights of the original predictors on the new predictors. 
# Each column represents a new direction of covariance, which will align w. loadings matrix (below)
e$vector

# Use princomp to get the loadings, which are the eigenvectors after being rotated
p = princomp(pred - apply(pred, 2, mean))
p$loadings
p$scores

# F = Y0 * L 
# F are the factors. Y0 is the original predictor data, L is the Loadings matrix
f = pred*(p$loadings)













# Create first 3 loadings and factors
pcaLoadings<-PCA.Yields$loadings[,1:3]
pcaLoading0<-PCA.Yields$center
pcaFactors<-PCA.Yields$scores[,1:3]

pcaLoadings

# Compare the loadings 
loadingsComparison<-cbind(pcaLoadings,Maturities,Eigen.Decomposition$vectors[,1:3])
colnames(loadingsComparison)<-c(paste0("PCA",1:3),"Maturity",paste0("Manual",1:3))
loadingsComparison



mod<-lm(test_dat)
summary(mod)

0.9*0.9896
