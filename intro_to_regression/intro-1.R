## Section 1.1 - Introduction to Regression: Baseball as a Motivating Example

# Motivating Example: Moneyball -------------------------------------------

# Statistics have been used in baseball since its beginnings. Note that the data set we will be using, included in the Lahman library,
# goes back to the 19th century. For example, a summary of statistics such as the batting average, home runs, runs batted in, and
# stolen bases are reported for each player in the game in the sports section of newspapers. And players are rewarded for high numbers.
# Although summary statistics were widely used in baseball, data analysis, per se, was not. These statistics were arbitrarily decided
# on without much thought as to whether they actually predicted or were related to helping a team win.

# This all changed with Bill James. In the late 1970s, he started publishing articles with more in-depth analysis of baseball data.
# Bill James was the originator of using data to predict what outcomes best predicted if a team would win. He named this approach
# sabermetrics. At the time, his work was mostly ignored by the baseball world. Today, pretty much every team uses his approach and it
# has gone beyond baseball into other sports.

# To simplify the example we use, we'll focus on scoring runs and ignore pitching and fielding, although these are important as well.
# We will see how regression analysis can help develop strategies to build a competitive baseball team with a constrained budget. The
# approach can be divided into two separate data analyses:

# 1. determine which recorded player-specific statistics predict runs and

# 2. examine if players were undervalued based on what our first analysis predicts.

# Baseball Basics ---------------------------------------------------------

# The goal of a baseball game is to score more runs (points) than the other team.

# Each team has 9 batters who have an opportunity to hit a ball with a bat in a predetermined order. 

# Each time a batter has an opportunity to bat, we call it a plate appearance (PA).

# The PA ends with a binary outcome: the batter either makes an out (failure) and returns to the bench or the batter doesn’t (success)
# and can run around the bases, and potentially score a run (reach all 4 bases).

# We are simplifying a bit, but there are five ways a batter can succeed (not make an out):
    # Base on balls (BB): the pitcher fails to throw the ball through a predefined area considered to be hittable (the strike zone),
    # so the batter is permitted to go to first base.
    # Single: the batter hits the ball and gets to first base.
    # Double (2B): the batter hits the ball and gets to second base.
    # Triple (3B): the batter hits the ball and gets to third base.
    # Home Run (HR): the batter hits the ball and goes all the way home and scores a run.

# Historically, the batting average has been considered the most important offensive statistic. To define this average, we define a
# hit (H) and an at bat (AB). Singles, doubles, triples, and home runs are hits. The fifth way to be successful, a walk (BB), is not a
# hit. An AB is the number of times you either get a hit or make an out; BBs are excluded. The batting average is simply H/AB and is
# considered the main measure of a success rate.

# Note: The video states that if you hit AFTER someone who hits many home runs, you will score many runs, while the textbook states
# that if you hit BEFORE someone who hits many home runs, you will score many runs. The textbook wording is accurate.

# Bases on Balls or Stolen Bases? ----------------------------------------

# The visualization of choice when exploring the relationship between two variables like home runs and runs is a scatter plot.

# ...Code...
library(Lahman)
library(tidyverse)
library(dslabs)
ds_theme_set()

str(Teams)
?Teams

# Scatter plot of the relationship between HRs and wins
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_per_game = HR / G, R_per_game = R / G) %>%
  ggplot(aes(HR_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)
# The plot shows a very strong association: teams with more home runs tended to score more runs.

# Scatter plot of the relationship between SBs and wins
Teams %>% filter(yearID %in% 1961:2001) %>%
mutate(SB_per_game = SB / G, R_per_game = R / G) %>%
  ggplot(aes(SB_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)
# Here, the relationship is not as clear.


# Scatter plot of the relationship between BBs and wins
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_per_game = BB / G, R_per_game = R / G) %>%
  ggplot(aes(BB_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)
# Although the relationship is not as strong as it was for home runs, we do see a pretty strong relationship here.

# We know that, by definition, home runs cause runs, because when you hit a home run, at least one run will score. Now it could be that
# home runs also cause the bases on balls. If you understand the game, you will agree that that could be the case. So it might appear
# that a base on ball is causing runs, when in fact, it's home runs that's causing both. This is called confounding.

# Linear regression will help us parse all this out and quantify the associations.
# This will then help us determine what players to recruit.