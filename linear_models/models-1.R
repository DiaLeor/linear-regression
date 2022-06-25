## Section 2.1 - Linear Models: Introduction to Linear Models

# Confounding: Are BBs More Predictive? -----------------------------------

# Association is not causation!

# Although it may appear that BB cause runs, it is actually the HR that cause most of these runs. We say that
# BB are confounded with HR.

# Regression can help us account for confounding.

# ..Code From Video..
# Note that this code has been revised since this video was filmed.
# The code given in the textbook is provided below.

# find regression line for predicting runs from BBs
library(tidyverse)
library(Lahman)
bb_slope <- Teams %>% 
  filter(yearID %in% 1961:2001 ) %>% 
  mutate(BB_per_game = BB/G, R_per_game = R/G) %>% 
  lm(R_per_game ~ BB_per_game, data = .) %>% 
  .$coef %>%
  .[2]
bb_slope

# compute regression line for predicting runs from singles
singles_slope <- Teams %>% 
  filter(yearID %in% 1961:2001 ) %>%
  mutate(Singles_per_game = (H-HR-X2B-X3B)/G, R_per_game = R/G) %>%
  lm(R_per_game ~ Singles_per_game, data = .) %>%
  .$coef  %>%
  .[2]
singles_slope

# calculate correlation between HR, BB and singles
Teams %>% 
  filter(yearID %in% 1961:2001 ) %>% 
  mutate(Singles = (H-HR-X2B-X3B)/G, BB = BB/G, HR = HR/G) %>%  
  summarize(cor(BB, HR), cor(Singles, HR), cor(BB,Singles))

# ..Code From the Textbook..
# find regression line for predicting runs from BBs
library(tidyverse)
library(Lahman)
get_slope <- function(x, y) cor(x, y) * sd(y) / sd(x) # NOTE: this is the formula for calculating the slope of a
# regression line

bb_slope <- Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(BB_per_game = BB/G, R_per_game = R/G) %>% 
  summarize(slope = get_slope(BB_per_game, R_per_game))

bb_slope

# compute regression line for predicting runs from singles
singles_slope <- Teams %>% 
  filter(yearID %in% 1961:2001) %>%
  mutate(Singles_per_game = (H-HR-X2B-X3B)/G, R_per_game = R/G) %>%
  summarize(slope = get_slope(Singles_per_game, R_per_game))

singles_slope

# calculate correlation between HR, BB and singles
Teams %>% 
  filter(yearID %in% 1961:2001 ) %>% 
  mutate(Singles = (H-HR-X2B-X3B)/G, BB = BB/G, HR = HR/G) %>%  
  summarize(cor(BB, HR), cor(Singles, HR), cor(BB, Singles))

# Stratification and Multivariate Regression ------------------------------

# A first approach to check confounding is to keep HRs fixed at a certain value and then examine the relationship
# between BB and runs.

# The slopes of BB after stratifying on HR are reduced, but they are not 0, which indicates that BB are helpful
# for producing runs, just not as much as previously thought.

# We're essentially fitting this model:
# E[R|BB = x_1, HR = x_2] = β_0 + β_1(x_2)*x_1 + β_2(x_1*)x_2
# with the slopes for x_1 and x_2 and vice versa.

# If we take random variability into account, the estimated slopes by strata don't appear to change that much. If
# these slopes are in fact the same, this implies that this function β_1(x_2) and β_2(x_1) are actually constant.
# This in turn implies that the expectation of runs conditional on home runs and bases on balls can be wriiten
# in this simpler model:
# E[R|BB = x_1, HR = x_2] = β_0 + β_1*x_1 + β_2*x_2

# This model implies that if the number of home runds is fixed, we observe a linear relationship between runs and
# bases on balls. And that the slope of that relationship doesn't depend on the number of home runs. Only the
# intercept changes as the home runs increase. The same is true if we swap home runs and bases on balls.
 
# NOTE: There is an error in the script. The quote "Only the slope changes as the home runs increase." will be
# corrected to "Only the INTERCEPT changes as the home runs increase." in a future version of the video.

# In this analysis, known as multivariate regression, we say that bases on balls slope (β_1) is adjusted for the
# home run effect. If this model is correct, then confounding has been accounted for.

# ..Code..
# stratify HR per game to nearest 10, filter out strata with few points
dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_strata = round(HR/G, 1), 
         BB_per_game = BB / G,
         R_per_game = R / G) %>%
  filter(HR_strata >= 0.4 & HR_strata <=1.2)

# scatterplot for each HR stratum
dat %>% 
  ggplot(aes(BB_per_game, R_per_game)) +  
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap( ~ HR_strata)

# calculate slope of regression line after stratifying by HR
dat %>%  
  group_by(HR_strata) %>%
  summarize(slope = cor(BB_per_game, R_per_game)*sd(R_per_game)/sd(BB_per_game))

# stratify by BB
dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_strata = round(BB/G, 1), 
         HR_per_game = HR / G,
         R_per_game = R / G) %>%
  filter(BB_strata >= 2.8 & BB_strata <=3.9) 

# scatterplot for each BB stratum
dat %>% ggplot(aes(HR_per_game, R_per_game)) +  
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap( ~ BB_strata)

# slope of regression line after stratifying by BB
dat %>%  
  group_by(BB_strata) %>%
  summarize(slope = cor(HR_per_game, R_per_game)*sd(R_per_game)/sd(HR_per_game))

# Linear Models -----------------------------------------------------------

# “Linear” here does not refer to lines, but rather to the fact that the conditional expectation is a linear
# combination of known quantities.

# In Galton's model, we assume Y (son's height) is a linear combination of a constant and X (father's height)
# plus random noise. We further assume that ∈_i are independent from each other, have expected value 0 and the
# standard deviation sigma which does not depend on i.

# Note that if we further assume that  is normally distributed, then the model is exactly the same one we derived earlier by assuming bivariate normal data.

# We can subtract the mean from X to make β_0 more interpretable.
