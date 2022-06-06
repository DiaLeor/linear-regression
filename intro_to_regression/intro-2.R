
# Correlation -------------------------------------------------------------

# Galton tried to predict sons' heights based on fathers' heights.

# The mean and standard errors are insufficient for describing an important characteristic of the data: the trend
# that the taller the father, the taller the son.

# The correlation coefficient is an informative summary of how two variables move together that can be used to
# predict one variable using the other.

# ..Code..
# create the dataset
library(tidyverse)
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

# means and standard deviations
galton_heights %>%
  summarize(mean(father), sd(father), mean(son), sd(son))

# scatterplot of father and son heights
galton_heights %>%
  ggplot(aes(father, son)) +
  geom_point(alpha = 0.5)

# Correlation Coefficient -------------------------------------------------

# The correlation coefficient is defined for a list of pairs (x_1, y1), ... , (x_n, y_n) as the product of the
# standardized values: ((x_i - mu_x)/sigma_x)*((y_i - mu_i)/sigma_y) -- with mu being the symbol representing the
# mean and sigma representing SD.

# The Greek letter rho is commonly used in the statistics book to denote this correlation, as rho is the Greek
# letter for 'r,' the first letter of regression.
rho <- mean(scale(x)*scale(y))

# The correlation coefficient essentially conveys how two variables move together.

# x_i is ((x_i - mu_x)/sigma_x) SDs away from the average.
# y_i is ((y_i - mu_i)/sigma_y) SDs away from the average.
# If x and y are unrelated, then the product of these two quantities will be positive (either both positive or both
# negative) as often as they will be negative (when one is positive and the other is negative and vice versa).
# The correlation is this average, which will be about 0. Therefore, unrelated variables will have a correlation of
# about 0.

# If the quantities vary together, we are averaging mostly positive products and see a positive correlation
# (positive*positive or negative*negative).
# If they vary in opposite directions, we get a negative correlation (positive*negative and vice versa).

# The correlation coefficient is always between -1 and 1.

# ..Code..
# the correlation between father and sons' height
galton_heights %>% summarize(r = cor(father, son)) %>% pull(r)

# Sample Correlation is a Random Variable ---------------------------------

# The correlation that we compute and use as a summary is a random variable.

# When interpreting correlations, it is important to remember that correlations derived from samples are estimates
# containing uncertainty. It's a random variable, and it can have a pretty large standard error.

# Because the sample correlation is an average of independent draws, the central limit theorem applies. Therefore,
# for a large enough sample size N, the distribution of these Rs is approximately normal.

# The formula to derive the standard deviation R ~ N (rho, sqrt((1-r^2)/(N-2))) 

# ..Code..
# compute sample correlation, sample size 25
R <- sample_n(galton_heights, 25, replace = TRUE) %>%
  summarize(r = cor(father, son))
R # R is a random variable

# Monte Carlo simulation to show distribution of sample correlation
B <- 1000
N <- 25
R <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    summarize(r = cor(father, son)) %>%
    pull(r)
})
qplot(R, geom = "histogram", binwidth = 0.05, color = I("black"))

# expected value and standard error
mean(R) # We see that the expected value is the population correlation, the mean of these Rs
sd(R) # and that it has a relatively high standard error relative to its size.

# QQ-plot to evaluate whether N is large enough
data.frame(R) %>%
  ggplot(aes(sample = R)) +
  stat_qq() +
  geom_abline(intercept = mean(R), slope = sqrt((1-mean(R)^2)/(N-2)))