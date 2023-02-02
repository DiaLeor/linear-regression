## Section 3.1 - Confounding: Correlation is Not Causation

# Spurious Correlation ---------------------------------------------------

# Association/correlation is not causation. In this course, we have described tools useful for
# quantifying associations between variables, but we must be careful not to over interpret these
# associations. There are many reasons why a variable x can correlate with a variable y, without
# either being a cause for the other. One common way that can lead to misinterpreting
# associations: spurious correlations.
 
# Example: there is existing data that shows a very strong correlation between divorce rates and
# margarine consumption. Does this mean that margarine causes divorces or do divorces cause people
# to eat more margarine? To see more examples of spurious correlations:
# tylervigen.com/spurious-correlations. The site has examples of what is generally called data
# dredging, data phishing, or data snooping. It's basically a form of cherry picking (US
# terminology). One method of data dredging would be if you look through many results produced
# by a random process, and pick the one that shows a relationship that supports the theory you
# want to defend. A monte carlo simulation can be used to show how data dredging can result in
# finding high correlations among variables that are theoretically uncorrelated. It's just a
# mathematical fact that if we observe random correlations that are expected to be 0, but have a
# standard error of about 0.2, the largest one with be close to 1 if we pick from among one
# million. Note that if we performed regression on this group and interpreted the p-value, we
# would incorrectly claim this was a statistically significant relation. This particular form of
# data dredging is called p-hacking.

# p-hacking is a topic of much discussion because it is a problem in scientific publications.
# Because publishers tend to reward statistically significant results over negative results, there
# is an incentive to report significant results. In epidemiology for example, researchers may look
# for associations between an average outcome and several exposures and only report the one
# exposure that resulted in a small p-value. Furthermore, they might try fitting several different
# models to adjust for confounding and pick the one model that yields the smallest p-value. In
# experimental disciplines, an experiment might be repeated more than once, and only the one that
# results in a small p-value are reported. This doesn't necessarily happen due to unethical
# behavior, but rather to statistical ignorance or wishful thinking. In advanced statistics
# courses, you'll learn methods to adjust for what is called the multiple comparison problem.

#..Code..
# generate the Monte Carlo simulation
library(dslabs)
library(tidyverse)

N <- 25
g <- 1000000
sim_data <- tibble(group = rep(1:g, each = N), x = rnorm(N * g), y = rnorm(N * g))

# calculate correlation between X,Y for each group
res <- sim_data %>% 
  group_by(group) %>% 
  summarize(r = cor(x, y)) %>% 
  arrange(desc(r))
res

# plot points from the group with maximum correlation
sim_data %>% filter(group == res$group[which.max(res$r)]) %>%
  ggplot(aes(x, y)) +
  geom_point() + 
  geom_smooth(method = "lm")

# histogram of correlation in Monte Carlo simulations
res %>% ggplot(aes(x=r)) + geom_histogram(binwidth = 0.1, color = "black")

# linear regression on group with maximum correlation
library(broom)
sim_data %>% 
  filter(group == res$group[which.max(res$r)]) %>%
  summarize(tidy(lm(y ~ x)))

# Outliers ----------------------------------------------------------------

# Correlations can be caused by outliers.

# The Spearman correlation is calculated based on the ranks of data.

#..Code..
# simulate independent X, Y and standardize all except entry 23
# note that you may get different values than those shown in the video depending on R version
set.seed(1985)
x <- rnorm(100,100,1)
y <- rnorm(100,84,1)
x[-23] <- scale(x[-23])
y[-23] <- scale(y[-23])

# plot shows the outlier
qplot(x, y, alpha = 0.5)

# outlier makes it appear there is correlation
cor(x,y)
cor(x[-23], y[-23])

# use rank instead
qplot(rank(x), rank(y))
cor(rank(x), rank(y))

# Spearman correlation with cor function
cor(x, y, method = "spearman")

# Reversing Cause and Effect ----------------------------------------------

# Another way association can be confused with causation is when the cause and effect are reversed.

# As discussed in the video, in the Galton data, when father and son were reversed in the regression,
# the model was technically correct. The estimates and p-values were obtained correctly as well. What
# was incorrect was the interpretation of the model.

#..Code..
# cause and effect reversal using son heights to predict father heights
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

galton_heights %>% summarize(tidy(lm(father ~ son)))

# Confounders -------------------------------------------------------------

# If X and Y are correlated, we call Z a confounder if changes in Z causes changes in both X and Y.

#..Code..
# UC-Berkeley admission data
library(dslabs)
data(admissions)
admissions

# percent men and women accepted
admissions %>% group_by(gender) %>% 
  summarize(percentage = 
              round(sum(admitted*applicants)/sum(applicants),1))

# test whether gender and admission are independent
admissions %>% group_by(gender) %>% 
  summarize(total_admitted = round(sum(admitted / 100 * applicants)), 
            not_admitted = sum(applicants) - sum(total_admitted)) %>%
  select(-gender) %>% 
  summarize(tidy(chisq.test(.)))

# percent admissions by major
admissions %>% select(major, gender, admitted) %>%
  pivot_wider(names_from = gender, values_from = admitted) %>%
  mutate(women_minus_men = women - men)

# plot total percent admitted to major versus percent women applicants
admissions %>% 
  group_by(major) %>% 
  summarize(major_selectivity = sum(admitted * applicants) / sum(applicants),
            percent_women_applicants = sum(applicants * (gender=="women")) /
              sum(applicants) * 100) %>%
  ggplot(aes(major_selectivity, percent_women_applicants, label = major)) +
  geom_text()

# plot percent of applicants accepted by gender
admissions %>% 
  mutate(percent_admitted = admitted*applicants/sum(applicants)) %>%
  ggplot(aes(gender, y = percent_admitted, fill = major)) +
  geom_bar(stat = "identity", position = "stack")

# plot admissions stratified by major
admissions %>% 
  ggplot(aes(major, admitted, col = gender, size = applicants)) +
  geom_point()

# average difference by major
admissions %>%  group_by(gender) %>% summarize(average = mean(admitted))

# Simpson's Paradox -------------------------------------------------------

# Simpson’s Paradox happens when we see the sign of the correlation flip when comparing the entire
# dataset with specific strata.