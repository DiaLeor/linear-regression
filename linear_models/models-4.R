## Section 2.4 - Linear Models: Regression and Baseball

# Building a Better Offensive Metric for Baseball -------------------------

# In our model that helps us explore how well bases on balls predict runs, the data is approximately
# normal. And conditional distributions were also normal. So it's justified to propose the linear
# model: Y_i = β_0 + β_1*X_i,1 + β_2*X_i,2 + ∈_i with runs per game (Y_i), walks per game (X_i,1)m, and home
# runs per game X_i,2.

# To use lm() here, we need to let it know that we have two predictor variables. We use the plus
# symbol like this:
lm(R ~ BB + HR, data = .)
# to build a multiple regression model and use the tidy() funciton to see a summary. When we fit the
# model with only one variable without the adjustment, the estimated slopes were 0.735 and 1.844 for
# bases on balls and home runs, respectively. But when we fit the multivariate model, both these slopes
# go down, with the bases on balls effect decreasing much more.

# Now if we want to construct a metric to pick players, we need to consider singles, doubles (X2B),
# and triples (X3B) as well. We will assume that these five variables are jointly normal. This means
# that if we pick any one of them and hold the other four fixed, the relationship with the outcome
# (in this case runs per game) is linear and the slopes for this relationship do not depend on the
# other four values that were held constant. If this is true, then a linear model for our data
# would look like this: Y_i = β_0 + β_1*X_i1 + β_2*X_i2 + β_3*X_i3 + β_4*X_i4 + β_5*X_i5 +∈_i with
# the X's representing bases on balls/game, singles/game, doubles/game, triples/game, and home
# runs/game, respectively.

# Using lm(), we can quickly find the least squared errors for the parameters using code. And we can
# use the tidy function to see the coefficients, standard errors, and confidence intervals. To see
# how well our metric actually predicts runs, we can predict the number of runs for each team in 2002
# using the function predict() to make the plot. NOTE: remember that we didn't use the 2002 year to
# create this metric. We can conclude our model does a decent job, as demonstrated by the fact that
# points from the observed versus predicted plot fall close to the identity line.

# So instead of using batting average or just the number of home runs as a measure for picking
# players, we can use our fitted model to form a more informative metric that relates more directly
# to run production.

# To define a metric for player A, we can imagine a team of players just like player A and use our
# fitted regression model to predict how many runs this team would produce. This formula would be:
singles <- H-HR-X2B-X3B
-2.769 + 0.371*BB + 0.519*singles + 0.771*X2B + 1.240*X3B + 1.443*HR
# Basically, we plug in the estimated coefficients into the regression formula.

# However, a challenge here is that we have derived the metrics for teams based on team-level summary
# statistics (ex: the HR value is HR/G for the entire team). If you compute HR/G for a player, it
# will be much lower (as the total is accumulated by nine batters).Furthermore, if a player only
# plays part of the game and gets less opportunity than average, it's still considered a game played.
# And that would also make their rates lower than they should be. For players, a rate that instead
# takes into account opportunities is a per-plate-appearance rate. To make the per-game team rate
# comparable to the per-plate-appearance player rate, we compute the average number of team plate
# appearances per game using code. And now we are ready to use this metric.

# We will compute the per-plate-appearance rates for players available in 2002 (again using data from
# previous years). To avoid sample artifacts, we're going to filter players with few plate
# appearances. We can create a calculation of what we want to do in one long line of code using
# tidyverse.

# So we fit our model. We have player-specific metrics. The player-specific predicted runs computed
# here can be interpreted as the number of runs we would predict a team to score if this team was
# made up of just that player - if that player batted every single time. The distribution shows
# that there is wide variability across players.

# To actually build the teams, we will need to know the players' salaries, since we have a limited
# budget. NOTE: Remember we are pretending to be the Oakland A's in 2002 with a mere $40 million
# budget. We also need to know the player's position, as we're going to need one shortstop, one
# second baseman, on third baseman, etc. For this, we can do some data wrangling to combine info
# that is contained in different tables from the Lahman library.

# We start by adding the 2002 salaries for each player using code. It's a bit complicated to select
# for position, as players play more than one position each year. In this case, we're going to pick
# the one position most played by each player using the top_n() function. And to make sure that we
# only pick one position in case of ties, we're going to take the first row. We remove the
# OF (outfielder) position, which is a generalization of three positions. We also code to remove
# pitchers, as they don't bat in the league. Finally, we add their first and last names so we know
# who we're talking about.

# Now we have a table with our predicted run statistic, some other statistics, player name, position,
# and salary. Note the very high salaries of the players in the top 10. The majority of players with
# high metrics have high salaries. By making a plot, however, we do see that some low-cost players
# have high metrics. These would be great for our low budget team. Unfortunately, these are likely
# young players that have not yet been able to negotiate a salary and are not going to be available
# in 2002 (for example, the lowest earner on our top 10 list is Albert Pujols (who was a rookie in
# 2001).

# If we make a plot of players that debuted before 1997, we can remove all the young players. We can
# now search for good deals by looking at players that produce many more runs and others with similar
# salaries. We can use this table to decide what players to pick and keep our total salary below the
# $40 million budget.
?Teams
#..Code..
# linear regression with two variables
fit <- Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(BB = BB/G, HR = HR/G,  R = R/G) %>%  
  lm(R ~ BB + HR, data = .)
tidy(fit, conf.int = TRUE)

# regression with BB, singles, doubles, triples, HR
fit <- Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(BB = BB / G, 
         singles = (H - X2B - X3B - HR) / G, 
         doubles = X2B / G, 
         triples = X3B / G, 
         HR = HR / G,
         R = R / G) %>%  
  lm(R ~ BB + singles + doubles + triples + HR, data = .)
coefs <- tidy(fit, conf.int = TRUE)
coefs

# predict number of runs for each team in 2002 and plot
Teams %>% 
  filter(yearID %in% 2002) %>% 
  mutate(BB = BB/G, 
         singles = (H-X2B-X3B-HR)/G, 
         doubles = X2B/G, 
         triples =X3B/G, 
         HR=HR/G,
         R=R/G)  %>% 
  mutate(R_hat = predict(fit, newdata = .)) %>%
  ggplot(aes(R_hat, R, label = teamID)) + 
  geom_point() +
  geom_text(nudge_x=0.1, cex = 2) + 
  geom_abline()

# average number of team plate appearances per game
pa_per_game <- Batting %>% filter(yearID == 2002) %>% 
  group_by(teamID) %>%
  summarize(pa_per_game = sum(AB+BB)/max(G)) %>% 
  pull(pa_per_game) %>% 
  mean

# compute per-plate-appearance rates for players available in 2002 using previous data
players <- Batting %>% filter(yearID %in% 1999:2001) %>% 
  group_by(playerID) %>%
  mutate(PA = BB + AB) %>%
  summarize(G = sum(PA)/pa_per_game,
            BB = sum(BB)/G,
            singles = sum(H-X2B-X3B-HR)/G,
            doubles = sum(X2B)/G, 
            triples = sum(X3B)/G, 
            HR = sum(HR)/G,
            AVG = sum(H)/sum(AB),
            PA = sum(PA)) %>%
  filter(PA >= 300) %>%
  select(-G) %>%
  mutate(R_hat = predict(fit, newdata = .))

# plot player-specific predicted runs
qplot(R_hat, data = players, geom = "histogram", binwidth = 0.5, color = I("black"))

# add 2002 salary of each player
players <- Salaries %>% 
  filter(yearID == 2002) %>%
  select(playerID, salary) %>%
  right_join(players, by="playerID")

# add defensive position
position_names <- c("G_p","G_c","G_1b","G_2b","G_3b","G_ss","G_lf","G_cf","G_rf")
tmp_tab <- Appearances %>% 
  filter(yearID == 2002) %>% 
  group_by(playerID) %>%
  summarize_at(position_names, sum) %>%
  ungroup()  
pos <- tmp_tab %>%
  select(position_names) %>%
  apply(., 1, which.max) 
players <- data_frame(playerID = tmp_tab$playerID, POS = position_names[pos]) %>%
  mutate(POS = str_to_upper(str_remove(POS, "G_"))) %>%
  filter(POS != "P") %>%
  right_join(players, by="playerID") %>%
  filter(!is.na(POS)  & !is.na(salary))

# add players' first and last names
# NOTE: In old versions of the Lahman library, the "People" dataset was called "Master"
# The following code may need to be modified if you have not recently updated the Lahman library.
players <- People %>%
  select(playerID, nameFirst, nameLast, debut) %>%
  mutate(debut = as.Date(debut)) %>%
  right_join(players, by="playerID")

# top 10 players
players %>% select(nameFirst, nameLast, POS, salary, R_hat) %>% 
  arrange(desc(R_hat)) %>% 
  top_n(10) 

# players with a higher metric have higher salaries
players %>% ggplot(aes(salary, R_hat, color = POS)) + 
  geom_point() +
  scale_x_log10()

# remake plot without players that debuted after 1998
library(lubridate)
players %>% filter(year(debut) < 1998) %>%
  ggplot(aes(salary, R_hat, color = POS)) + 
  geom_point() +
  scale_x_log10()

# A way to actually pick the players for the team can be done using what computer scientists call
# linear programming. Although we don't go into this topic in detail in this course, we include the
# code anyway:
library(reshape2)
library(lpSolve)

players <- players %>% filter(debut <= "1997-01-01" & debut > "1988-01-01")
constraint_matrix <- acast(players, POS ~ playerID, fun.aggregate = length)
npos <- nrow(constraint_matrix)
constraint_matrix <- rbind(constraint_matrix, salary = players$salary)
constraint_dir <- c(rep("==", npos), "<=")
constraint_limit <- c(rep(1, npos), 50*10^6)
lp_solution <- lp("max", players$R_hat,
                  constraint_matrix, constraint_dir, constraint_limit,
                  all.int = TRUE)

# The algorithm chooses 9 players
our_team <- players %>%
  filter(lp_solution$solution == 1) %>%
  arrange(desc(R_hat))
our_team %>% select(nameFirst, nameLast, POS, salary, R_hat)

# We note that these players all have above average BB and HR rates while the same is not true for
# singles.
my_scale <- function(x) (x - median(x))/mad(x)
players %>% mutate(BB = my_scale(BB), 
                   singles = my_scale(singles),
                   doubles = my_scale(doubles),
                   triples = my_scale(triples),
                   HR = my_scale(HR),
                   AVG = my_scale(AVG),
                   R_hat = my_scale(R_hat)) %>%
  filter(playerID %in% our_team$playerID) %>%
  select(nameFirst, nameLast, BB, singles, doubles, triples, HR, AVG, R_hat) %>%
  arrange(desc(R_hat))

# On Base Plus Slugging (OPS) ---------------------------------------------

# Since the 1980s, sabermetricians have used a summary statistic different from batting average to
# evaluate players. They realized walks were important and that doubles and triples and homeruns
# should be weighted much more than singles, then proposed the following on-base-percentage plus
# slugging percentage (OPS) metric:
singles <- H-HR-X2B-X3B
BA/PA + (singles + 2*X2B + 3*X3B + 4*HR)/AB
# Although sabermetricians are probably not using regression, this metric is impressively close to
# what one gets with regression to the summary statistic that we created (they're very correlated).

# Regression Fallacy ------------------------------------------------------

# Regression can bring about errors in reasoning, especially when interpreting individual
# observations.

# The example showed in the video demonstrates that the "sophomore slump" observed in the
# data is caused by regressing to the mean. According to wikipedia, a sophomore slump/jinx/jitters
# refers to an instance in which a second, or sophomore, effort fails to live up to the standard of
# the first effort. It's commonly used to refer to the apathy of students (in their second year of
# high school/college/university), the performance of athletes (second season of play), singers/bands
# (second album), television shows (second season), and movies (sequels/prequels).

# In Major League Baseball, the Rookie of the Year (an award given to the first year player that is
# judged to have performed the best) usually doesn't perform as well during their second year.

# Can we use data to confirm the existence of the sophomore slump? Take a look and examine the data
# for batting averages to see if the observation holds true. The data is available in the Lahman
# library, but we have to do some work to create a table with the statistics for all the rookies of
# the year.

# First, we create a table with player ID, their names and their most played position. Now we will
# create a table with only the Rookie of the Year Award winners and add their batting statistics.
# We filter out pitchers, since pitchers are not given awards for batting, and focus on offense.
# Specifically, we focus on batting average, since it is the summary that most pundits talk about
# when discussing the sophomore slump. Now we keep only the rookie and sophomore seasons and remove
# players that did not play a sophomore season. Finally, we use the spread function to have one
# column for the rookie and another column for the sophomore years' batting averages.

# Now we can see the top performers in their first year aka Rookie of the Year Award winners and
# display their rookie season batting average and sophomore season batting average. Look closely and
# you see the sophomore slump. It definitely appears to be real. In fact, the proportion of players
# that have a lower batting average in their sophomore years is 68%. Why is this?

# To answer this question, we can turn our attention to all players, looking at the 2013 and 2014
# seasons. And we select players that batted at least 130 times (this is a minimum needed to win
# the Rookie of the Year award). We perform a similar operation as we did before to construct the
# data set. When we look at the top performers of 2013 and then look at their performance in 2014,
# the same pattern arises. Batting averages go down for the top performers. But these are not
# rookies. So this can't be explained with the sophomore slump. Also, we look at the worst performers
# of 2013. Their batting averages go up in their second season in 2014. Is this a reverse slump?

# In fact, there is no such thing as a sophomore slump. This can all be explained with a simple
# statistical fact: the correlation of performance in two separate years is high but not perfect.
# Looking at a plot, we see 2013 and 2014 performance is correlated. But not perfectly. The
# correlation is 0.46. The data look very much like a bivariate normal distribution, which means
# that if we were to predict the 2014 batting average (y) for any given player that had a 2013
# batting average of x, we would use the regression equation. Regression tells us that on average,
# we expect high performers from 2013 to do a little bit worse in 2014. This is regression to the
# mean. The rookies of the year are selected from the top values of x. So it is expected that their y
# will regress to the mean.

#..Code..
# The code to create a table with player ID, their names, and their most played position:
library(Lahman)
playerInfo <- Fielding %>%
  group_by(playerID) %>%
  arrange(desc(G)) %>%
  slice(1) %>%
  ungroup %>%
  left_join(People, by="playerID") %>%
  select(playerID, nameFirst, nameLast, POS)

# The code to create a table with only the ROY award winners and add their batting statistics:
ROY <- AwardsPlayers %>%
  filter(awardID == "Rookie of the Year") %>%
  left_join(playerInfo, by="playerID") %>%
  rename(rookie_year = yearID) %>%
  right_join(Batting, by="playerID") %>%
  mutate(AVG = H/AB) %>%
  filter(POS != "P")

# The code to keep only the rookie and sophomore seasons and remove players who did not play
# sophomore seasons:
ROY <- ROY %>%
  filter(yearID == rookie_year | yearID == rookie_year+1) %>%
  group_by(playerID) %>%
  mutate(rookie = ifelse(yearID == min(yearID), "rookie", "sophomore")) %>%
  filter(n() == 2) %>%
  ungroup %>%
  select(playerID, rookie_year, rookie, nameFirst, nameLast, AVG)

# The code to use the spread function to have one column for the rookie and sophomore years
# batting averages:
ROY <- ROY %>% spread(rookie, AVG) %>% arrange(desc(rookie))
ROY

# The code to calculate the proportion of players who have a lower batting average their
# sophomore year:
mean(ROY$sophomore - ROY$rookie <= 0)

# The code to do the similar analysis on all players that played the 2013 and 2014 seasons and
# batted more than 130 times (minimum to win Rookie of the Year):
two_years <- Batting %>%
  filter(yearID %in% 2013:2014) %>%
  group_by(playerID, yearID) %>%
  filter(sum(AB) >= 130) %>%
  summarize(AVG = sum(H)/sum(AB)) %>%
  ungroup %>%
  spread(yearID, AVG) %>%
  filter(!is.na(`2013`) & !is.na(`2014`)) %>%
  left_join(playerInfo, by="playerID") %>%
  filter(POS!="P") %>%
  select(-POS) %>%
  arrange(desc(`2013`)) %>%
  select(nameFirst, nameLast, `2013`, `2014`)
two_years

# The code to see what happens to the worst performers of 2013:
arrange(two_years, `2013`)

# The code to see  the correlation for performance in two separate years:
qplot(`2013`, `2014`, data = two_years)

summarize(two_years, cor(`2013`,`2014`))

# Measurement Error Models ------------------------------------------------

# Up to now, all our linear regression examples have been applied to two or more random variables.
# We assume the pairs are bivariate normal and use this to motivate a linear model.

# Another use for linear regression is with measurement error models, where it is common to have a
# non-random covariate (such as time). Randomness is introduced from measurement error rather than
# sampling or natural variability.

#..Code..
# The code to use dslabs function rfalling_object to generate simulations of dropping balls:
library(dslabs)
falling_object <- rfalling_object()

# The code to draw the trajectory of the ball:
falling_object %>%
  ggplot(aes(time, observed_distance)) +
  geom_point() +
  ylab("Distance in meters") +
  xlab("Time in seconds")

# The code to use the lm() function to estimate the coefficients:
fit <- falling_object %>%
  mutate(time_sq = time^2) %>%
  lm(observed_distance~time+time_sq, data=.)

tidy(fit)

# The code to check if the estimated parabola fits the data:
augment(fit) %>%
  ggplot() +
  geom_point(aes(time, observed_distance)) +
  geom_line(aes(time, .fitted), col = "blue")

# The code to see the summary statistic of the regression:
tidy(fit, conf.int = TRUE)