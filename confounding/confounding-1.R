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

# Correlations can be caused by outliers. Suppose we take measurements from two independent
# outcomes, x and y, and we standardize the measurements. However, imagine we made a mistake and
# forgot to standardize entry 23. We can simulate such data using code. Not surprisingly, the
# correlation is very high. One point, an outlier, is making the correlations as high as 0.99. If
# we remove this sole outlier, the correlation is greatly reduced to almost 0, which is what it
# should be. So one way to deal with outliers is to detect them and remove them. But there is an
# alternative way to the sample correlation for estimating the population correlation that is
# robust to outliers - Spearman correlation.

# The Spearman correlation is calculated based on the ranks of data. Compute the correlation on the
# ranks of the values rather than the values themselves. Note in this way, the one point that wasn't
# previously standardized is no longer really out there pulling the correlation towards 1. So if we
# compute the correlation of the ranks, we get something much closer to 0. Spearman correlation can
# also be calculated with the correlation function, but using the method argument to tell cor()
# which correlation to compute. There are other methods for robust fitting of linear models, which
# you can learn more about outside this course.

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
# An example of this is claiming that tutoring makes students perform worse because they test
# lower than peers that are not tutored. Here, the tutoring is not causing the low test, but the
# other way around.

# As discussed in the video, in the Galton data, when father and son were reversed in the regression,
# the model was technically correct. The estimates and p-values were obtained correctly as well.
# Looking at the mathematical formulation of the model, it could easily be incorrectly interpreted
# as to suggest that the son being tall caused the father to be tall. But given what we know about
# genetics and biology, we know it's the other way around. So what is wrong here is simply the
# interpretation.

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

# Confounders are perhaps the most common reason that leads to associations being misinterpreted.
# If X and Y are correlated, we call Z a confounder if changes in Z causes changes in both X and Y.
# When studying baseball data, we saw how home runs was a confounder that resulted in higher than
# expected correlation when studying the relationship between bases on balls and runs. In some
# cases, we can use linear models to account for confounders. But it's not always possible.
# Incorrect interpretation due to confounders is ubiquitous in the lay press. They are sometimes
# hard to detect. 

# Example: When examining admission data from UC Berkeley majors from 1973, it seems to be the case
# that more men were being admitted than women. The percent can be computed from the data using
# code  - 44% men compared to 30% women. The chi-squared test we learned in a previous course
# clearly rejects the hypothesis that gender and admissions are independent. The p-value is very
# small. But closer inspection shows a paradoxical result. When we view the percent of admissions
# by major, four out of the six majors favor women. But more importantly, all the differences are
# much smaller than the 14% difference that we see when examining the totals. The paradox is that
# analyzing the totals suggest a dependence between admissions and gender. But when the data is
# grouped by major, this dependence seems to disappear.

# This can actually happen if an uncounted confounder is driving most of the variability. If we
# define three variables:
#     x - 1 for men and 0 for women
#     y - 1 for admitted and 0 otherwise
#     z - quantifies how selective the major is
# A gender bias claim would be based on the fact that this probability is higher when X is 1 than
# when X is 0. But z is an important confounder. Clearly, z is associated with y because the more
# selective a major, the lower the probability that someone enters that major. But is major
# selectivity associated with gender? One way to see this is to plot the total percent admitted to
# a major versus the percent of women that make up the applicants. There seems to be an association.
# The plot suggests that women were much more likely to apply to the two hard majors. Gender and
# major selectivity are confounded.
# Compare, for example, major B and major E. Major E is much harder to enter than major B. And over
# 60% of applicants to major E were women while less than 30% of the applicants of major B were
# women. We can plot the percentage of applicants that were accepted by gender, using color to
# represent major. It also breaks down the acceptance rates by major. The size of the colored bar
# represents the percent of each major students that were admitted to. This breakdown lets us see
# that the majority of accepted men came from two majors, A and B. It also lets us see that few
# women apply to these two easy majors. What the plot doesn't show us is what's the percent admitted
# by major. In another plot, we can condition or stratify by major and then look at the differences.
# We control for the confounder, and the effect goes away. Now we see that, major by major, there's
# not much difference. The size of the dot represents the number of applicants and explains the
# paradox. If we first stratify by major, compute the difference, and then average; we find that the
# percent difference is actually quite small.

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
# dataset with specific strata. The previous example demonstrated this. View lecture video to
# see an illustrative scatterplot.