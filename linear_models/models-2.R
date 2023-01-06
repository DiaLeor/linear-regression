## Section 2.2 - Linear Models: Least Squares Estimates

# Least Squares Estimates (LSE) -------------------------------------------

# For linear models to be useful, we have to estimate the unknown parameters, the βs (betas). In the standard
# approach for regression, we aim to find the coefficient values that minimize the distance of the fitted model
# to the data. To quantify this, we use the least squares equation.

# For Galton's data, we would write something like this:
# RSS = the sum from i = 1, ..., i = n{Y_i - β_0 + β_1*X_i)}^2

# This quantity is called the Residual sum of squares (RSS), which measures the distance between the true value
# and the predicted value given by the regression line. The values that minimize the RSS are called the least
# squares estimates (LSE) and denote them ( in this case) with β_0-hat and β_1-hat.

# We can use partial derivatives to get the values for β_0 and β_1 in Galton's data.

#..Code..
# compute RSS for any pair of β_0 (beta0) and β_1 (beta1) in our galton_heights data
library(HistData)
data("GaltonFamilies")
set.seed(1983)
galton_heights <- GaltonFamilies %>%
  filter(gender == "male") %>%
  group_by(family) %>%
  sample_n(1) %>%
  ungroup() %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

str(galton_heights)
head(galton_heights)

rss <- function(beta0, beta1){
  resid <- galton_heights$son - (beta0+beta1*galton_heights$father)
  return(sum(resid^2))
}


# plot RSS as a function of beta1 when beta0=25
beta1 = seq(0, 1, len=nrow(galton_heights))
results <- data.frame(beta1 = beta1,
                      rss = sapply(beta1, rss, beta0 = 25))
results %>% ggplot(aes(beta1, rss)) + geom_line() + 
  geom_line(aes(beta1, rss))

# NOTE: this minimum is for beta1 when beta0 is fixed at 25. We don't know if that's the minimum for beta0. We don't
# know if expression: (25, 0.65) minimizes the equation across all pairs. So we can use calculus to take the partial
# derivatives, set them equal to 0, and solve for beta1 and beta0. If we have many paramenters, these equations can
# get rather complex. Fortunately, there are functions in R that do these calculations for us.

# The lm Function ---------------------------------------------------------

# In r, we can obtain the LSE using the lm() function. To fit the following model where Y_i is the son's height and
# X_i is the father's height (Y_i = β_0 + β_1*X_i + ∈_i), we would write the following piece of code.

#..Code..
# fit regression line to predict son's height from father's height
fit <- lm(son ~ father, data = galton_heights)
fit

# When calling the lm() function, the variable that we want to predict is put to the left of the ~ symbol, and the
# variables that we use to predict are put to the right of the ~ symbol. The intercept is added automatically.

# we can use the function summary() to extract more information
summary(fit)

# LSE are Random Variables ------------------------------------------------

# Because they are derived from the samples, LSE are random variables.

# β_0 and β_1 appear to be normally distributed because the central limit theorem plays a role.

# The t-statistic depends on the assumption that ∈ follows a normal distribution.

#..Code..
# Monte Carlo simulation
B <- 1000
N <- 50
lse <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>% 
    lm(son ~ father, data = .) %>% 
    .$coef 
})
lse <- data.frame(beta_0 = lse[1,], beta_1 = lse[2,]) 

# Plot the distribution of beta_0 and beta_1
library(gridExtra)
p1 <- lse %>% ggplot(aes(beta_0)) + geom_histogram(binwidth = 5, color = "black") 
p2 <- lse %>% ggplot(aes(beta_1)) + geom_histogram(binwidth = 0.1, color = "black") 
grid.arrange(p1, p2, ncol = 2)

# summary statistics
sample_n(galton_heights, N, replace = TRUE) %>% 
  lm(son ~ father, data = .) %>% 
  summary %>%
  .$coef

lse %>% summarize(se_0 = sd(beta_0), se_1 = sd(beta_1))

# The summary funciton also reports t-statistics and the p-value
sample_n(galton_heights, N, replace = TRUE) %>% 
  lm(son ~ father, data = .) %>% 
  summary

# There is also a Pr(greater than the absolute value of t) column
# The t-statistic is not actually based on the CLT, but rather on the assumption that the epsilons follow a 
# normal distribution. Under this assumption, mathematical theory tells us that the LSE/standard error follow a
# t-distribution with N - p degrees of freedom with p, the number of parameters in our model (in this case p = 2).
# The 2p values are testing the null hypothesis that beta_0 = 0 and that beta_1 = 0 respectively. However, for a
# large enough N, the CLT works as the t-distrubution becomes almost the same as the normal distribution.

# So if you assume either that the errors are normal and use the t-distribution or if you assume that N is large
# enough to use the CLT, you can construct confidence intervals for your parameters. Note: hypothesis testing for
# regression models is very commonly used in fields such as epidemiology and economics to make statements such as:
  # the effect of A and B was statistically significant after adjusting for X, Y, and Z.
# Important to note that several assumptions have to hold for the statements to hold.

# Advanced Note on LSE ----------------------------------------------------

# Although interpretation is not straight-forward, it is also useful to know that the LSE can be strongly
# correlated, which can be seen using this code:

lse %>% summarize(cor(beta_0, beta_1))

# However, the correlation depends on how the predictors are defined or transformed.

# Here we standardize the father heights, which changes x_i to x_i - x-bar.

B <- 1000
N <- 50
lse <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    mutate(father = father - mean(father)) %>%
    lm(son ~ father, data = .) %>% .$coef 
})

# Observe what happens to the correlation in this case:

cor(lse[1,], lse[2,])

# Predicted Variables are Random Variables --------------------------------

# The predicted value is often denoted as Y-hat, which is a random variable. Mathematical theory tells us what the
# standard error of the predicted value is.

# The predict() function in R can give us predictions directly.

#..Code..
# plot predictions and confidence intervals
galton_heights %>% ggplot(aes(father, son)) +
  geom_point() +
  geom_smooth(method = "lm")

# plot best fit line
galton_heights %>%
  mutate(Y_hat = predict(lm(son ~ father, data=.))) %>%
  ggplot(aes(father, Y_hat))+
  geom_line()

# predict Y directly
fit <- galton_heights %>% lm(son ~ father, data = .) 
Y_hat <- predict(fit, se.fit = TRUE)
names(Y_hat)