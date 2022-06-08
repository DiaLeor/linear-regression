## Section 1.3 - Introduction to Regression: Stratification and Variance Explained

# Anscombe's Quartet/Stratification ---------------------------------------

# Correlation is not always a good summary of the relationship between two variables.

# The general idea of conditional expectation (conditional average) is that we stratify a population into groups
# and compute summaries in each group (e.g. average son height conditioned on the father being 72 in. tall).

# A practical way to improve the estimates of the conditional expectations is to define strata with similar
# values of x (e.g. fathers with similar heights, round to approximately 72 in. tall)

#for every standard deviation sigma_x increase above the average, mu_x
# y grows rho standard deviations sigma_y above the avewrage mu_y
# The formula for the regression line:
# ((y_i - mu_y)/(sigma_y)) = rho*((x_i - mu_x)/(sigma_x))

# If there is perfect correlation, the regression line predicts an increase that is the same number of SDs for both
# variables. If there is 0 correlation, then we don't use x at all for the prediction of y and simply predict the
# average mu_y. For values between 0 and 1, the prediction is somewhere in between. If the correlation is negative,
# we predict a reduction instead of an increase.

# It is because when the correlation is positive but lower than one, that we predict something closer to the mean,
# that we call this regression (i.e. the son regresses to the average height).

# Note that if we write this in the standard form of a line, y = mx +b, where b is the intercept and m is the slope,
# the regression line has slope m = rho*(sigma_y/sigma_x) and intercept b = mu_y - m*mu_x. So if we standardize
# the variables so they have average 0 and standard deviation 1, then the regression line has intercept 0 and slope
# equal to the correlation rho.

# A regression line gives us a prediction. An advantage of using the regression line is that we used all the data
# to estimate just two parameters, the slope and the intercept. This makes it much more stable. However, we may
# not always be justified in using the regression line to make predictions.

# ..Code..
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

# number of fathers with height 72 or 72.5 inches
sum(galton_heights$father == 72)
sum(galton_heights$father == 72.5)

# predicted height of a son with a 72 inch tall father
conditional_avg <- galton_heights %>%
  filter(round(father) == 72) %>%
  summarize(avg = mean(son)) %>%
  pull(avg)
conditional_avg

# stratify fathers' heights to make a boxplot of son heights
galton_heights %>% mutate(father_strata = factor(round(father))) %>%
  ggplot(aes(father_strata, son)) +
  geom_boxplot() +
  geom_point()

# center of each boxplot
galton_heights %>%
  mutate(father = round(father)) %>%
  group_by(father) %>%
  summarize(son_conditional_avg = mean(son)) %>%
  ggplot(aes(father, son_conditional_avg)) +
  geom_point()

# plot standardized heights son versus father with a slope line equal to the correlation
r <- galton_heights %>% summarize(r = cor(father,son)) %>% .$r
galton_heights %>% 
  mutate(father = round(father)) %>% 
  group_by(father) %>% 
  summarize(son = mean(son)) %>%
  mutate(z_father = scale(father), z_son = scale(son)) %>% 
  ggplot(aes(z_father, z_son)) +
  geom_point() +
  geom_abline(intercept = 0, slope = r) # this line is called a regression line

# calculate values to plot regression line on original data
mu_x <- mean(galton_heights$father)
mu_y <- mean(galton_heights$son)
s_x <- sd(galton_heights$father)
s_y <- sd(galton_heights$son)
r <- cor(galton_heights$father, galton_heights$son)
m <- r * s_y/s_x
b <- mu_y - m*mu_x

# add regression line to plot
galton_heights %>%
  ggplot(aes(father, son)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = b, slope = m)

# compare to a plot in standard units
galton_heights %>%
  ggplot(aes(scale(father), scale(son))) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = r)

# Bivariate Normal Distribution -------------------------------------------

# When a pair of random variables are approximated by the bivariate normal distribution, scatterplots look like
# ovals. They can be thin (high correlation) or circle-shaped (no correlation).

# If X and Y are normally distributed random variables and for any group of X, X = x; then Y is approximately normal
# in that group, and the pair is approximately bivariate normal. When we fix x in this way, we then refer to the
# resulting distribution of the y's in the group -- defined by setting x in this way -- as the conditional
# distribution of y given x (conditional distribution of Y given X = x).

# Notation of conditional distribution:
# f(Y) | X = x
# Notation of conditional expected value:
# E(Y | X = x)

# When two variables follow a bivariate normal distribution, then for any given x (the expected value of the y
# in pairs for which x is set at that value) is:
# E(Y | X = x) = mu_Y + rho*((X-mu_x)/(sigma_x))*sigma_y
# Note: this is a line with slope m = rho*((sigma_Y)/(sigma_x)) and intercept b = mu_y - m*mu_x
# Therefore, this is these slope and intercept are the same as the regression line.

# i.e. Wwen two variables follow a bivariate normal distribution, computing the regression line is equivalent to
# computing conditional expectations. Said another way, if the data are approximately bivariate, conditional
# expectation is given by the regression line.

# We can obtain a much more stable estimate of the conditional expectation by finding the regression line and
# using it to make predictions.

# ..Code..
# If we think the height data is well-approximated by the bivariate normal distribution, then we should see
# the normal approximation hold for each grouping.

# Stratify the son height by the standardized father heights
galton_heights %>%
  mutate(z_father = round((father - mean(father)) / sd(father))) %>%
  filter(z_father %in% -2:2) %>%
  ggplot() +  
  stat_qq(aes(sample = son)) +
  facet_wrap( ~ z_father) # and we see that the assumption appears to hold.

# Variance Explained ------------------------------------------------------


# There are Two Regression Lines ------------------------------------------


