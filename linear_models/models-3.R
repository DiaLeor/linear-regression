## Section 2.3 - Linear Models: Advanced dplyr - Summarize with Functions and Broom

# Advanced dplyr: summarize with functions and broom ----------------------

# To provide a more rigorous defense of the slopes being the same, we could compute confidence
# intervals for each slope. Though we haven't learned the formula for this, the lm() function provides
# enough information to construct them.

# Note: if we try to use the lm() function to get the estimated slopes for each strata, we don't get
# what we want. The lm() function ignores group_by() because lm() is not part of the tidyverse and
# doesn't know how to handle to outcome of a group_by() - a grouped tibble.
# Tibbles can be regarded as a modern version of data frames and are the default data structure in
# the tidyverse. Some functions that do not work properly with data frames do work with tibbles.

# Including a function inside a summarize can help that function handle a grouped tibble.

# The broom package has three main functions, tidy, glance, and augment, that are useful for
# connecting lm() to the tidyverse. It lets us do things like compute confidence intervals.
    # tidy() - returns estimates and related information as a data frame
    # learn more about the other functions by reading the broom documentation
    
# Because the outcome is a data frame, we can immediately use it with the summarize function and
# string together the commands that produce the table that we're after.
# Because a data frame is returned and we can filter and select the rows and columns we want, we can
# make it prettier by simply adding a could of lines of code. A table like this can then be easily
# visualized with ggplot().

# The plot we just made using summarize and broom shows that the confidence intervals overlap, which
# provides a nice visual confirmation that our assumption that our slopes don't change is a safe one.

#..Code..
# stratify by HR
dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR = round(HR/G, 1), 
         BB = BB/G,
         R = R/G) %>%
  select(HR, BB, R) %>%
  filter(HR >= 0.4 & HR<=1.2)

# calculate slope of regression lines to predict runs by BB in different HR strata
dat %>%  
  group_by(HR) %>%
  summarize(slope = cor(BB,R)*sd(R)/sd(BB))

# use lm to get estimated slopes - lm does not work with grouped tibbles
dat %>%  
  group_by(HR) %>%
  lm(R ~ BB, data = .) %>%
  .$coef

# include the lm inside a summarize and it will work
dat %>%  
  group_by(HR) %>%
  summarize(slope = lm(R ~ BB)$coef[2])

# tidy function from broom returns estimates in and information in a data frame
library(broom)
fit <- lm(R ~ BB, data = dat)
tidy(fit)

# add confidence intervals
tidy(fit, conf.int = TRUE)

# combine with group_by and summarize to get the table we want
dat %>%  
  group_by(HR) %>%
  summarize(tidy(lm(R ~ BB), conf.int = TRUE))

# it's a data frame so we can filter and select the rows and columns we want
dat %>%  
  group_by(HR) %>%
  summarize(tidy(lm(R ~ BB), conf.int = TRUE)) %>%
  filter(term == "BB") %>%
  select(HR, estimate, conf.low, conf.high)

# visualize the table with ggplot
dat %>%  
  group_by(HR) %>%
  summarize(tidy(lm(R ~ BB), conf.int = TRUE)) %>%
  filter(term == "BB") %>%
  select(HR, estimate, conf.low, conf.high) %>%
  ggplot(aes(HR, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point()