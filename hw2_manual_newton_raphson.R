library(numDeriv)

# Create variable dataPath equal to path to your local folder where you saved the data file Week7_Test_Sample.csv
dataPath <- "C:/Users/Nick's Laptop/Desktop/Linear and NonLinear Models/week2_fisherScore_newton_raphson/"

testFunction<-readRDS(file=paste(dataPath,"documents_MScA Linear and Non-Linear Models 31010_MScA 31010 Lecture 2_MScA_Nonlinear_Models_Week2_TestFunction.rds",sep="/"))$Week2_Test_Function


# plot the sample funciton created by the testFunction. Your newton.raphson calculator should work on any function
my_Function<-function(X,projectID) {
  testFunction(X, projectID = 652)
}

# It looks like the function equals 0 when x is about -3. To find the root of the equation, use the uniroot function with a starting value of -3 and upper bound of -1.
X<-seq(from=-5,to=5,by=.1)
Y<-my_Function(X)
plot(X,Y,type="l")
abline(h=0)

# As suspected, the root of the function is around -3 at -2.791301. It took 4 iterations to reach this conclusion
uniroot(my_Function, c(-3,-1))


# This function manually generates the roots of the derivatives for the Log Likelihood function. The roots of the derivatives are used to calculate MLE 
newton.raphson <- function(f, a, b, tol = 0.0001, n = 1000) {
  require(numDeriv) # Package for computing f'(x), otherwise known as f prime
  
  x0 <- a # Set start value to supplied lower bound
  k <- n # Initialize for iteration results
  
  # Check the upper and lower bounds to see if approximations result in 0
  fa <- f(a)
  if (fa == 0.0) {
    return(a)
  }
  
  fb <- f(b)
  if (fb == 0.0) {
    return(b)
  }
  
  for (i in 1:n) {
    dx <- genD(func = f, x = x0)$D[1] # First-order derivative f'(x0)
    x1 <- x0 - (f(x0) / dx) # Calculate next value x1
    k[i] <- x1 # Store x1
    # Once the difference between x0 and x1 becomes sufficiently small, output the results.
    if (abs(x1 - x0) < tol) {
      root.approx <- tail(k, n=1)
      res <- list('root approximation' = root.approx, 'iterations' = k)
      return(res)
    }
    # If Newton-Raphson has not yet reached convergence set x1 as x0 and continue
    x0 <- x1
  }
  print('Too many iterations in method')
}

# As we can see by plugging in boundaries for lower and upper bounds and inputting our sample function to the manual newton.raphson, we can approximate the root from uniroot
newton.raphson(my_Function, -3, -1)

# Compare newton.raphson with uniroot. You will see that the associated root is almost identical
uniroot(my_Function, c(-3,-1))

# Create variables for res list based on newton.raphson function and uniroot 
uniroot.root = uniroot(my_Function, c(-3,-1))$root

my.root = newton.raphson(my_Function, -3, -1)$`root approximation`

Start.Value = newton.raphson(my_Function, -3, -1)$iterations[1]

uniroot.lower = -3

uniroot.upper = -1

# Output results 
res <- list(Start.Value = Start.Value,
            my.Optimizer.root =my.root,
            uniroot.root = uniroot.root,
            uniroot.lower = uniroot.lower,
            uniroot.upper = uniroot.upper)

# write to table and submit
write.table(res, file = paste(dataPath,'result.csv',sep = '/'), row.names = F)

            