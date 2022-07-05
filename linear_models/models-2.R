## Section 2.2 - Linear Models: Least Squares Estimates


# Least Squares Estimates (LSE) -------------------------------------------

# For regression, we aim to find the coefficient values that minimize the distance of the fitted model to the data.

# Residual sum of squares (RSS) measures the distance between the true value and the predicted value given by the 
# regression line. The values that minimize the RSS are called the least squares estimates (LSE).

# We can use partial derivatives to get the values for β_0 and β_1 in Galton's data.

#..Code..
# compute RSS for any pair of beta0 and beta1 in Galton's data
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

# The lm Function ---------------------------------------------------------

# When calling the lm() function, the variable that we want to predict is put to the left of the ~ symbol, and the
# variables that we use to predict is put to the right of the ~ symbol. The intercept is added automatically.

# LSEs are random variables.

#..Code..
# fit regression line to predict son's height from father's height
fit <- lm(son ~ father, data = galton_heights)
fit

# summary statistics
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

# predict Y directly
fit <- galton_heights %>% lm(son ~ father, data = .) 
Y_hat <- predict(fit, se.fit = TRUE)
names(Y_hat)

# plot best fit line
galton_heights %>%
  mutate(Y_hat = predict(lm(son ~ father, data=.))) %>%
  ggplot(aes(father, Y_hat))+
  geom_line()