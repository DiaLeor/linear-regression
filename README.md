<p>Taking notes on the <a href="https://www.edx.org/course/data-science-linear-regression">Data Science: Linear Regression</a> course; practicing what I've learned during the previous <a href="https://www.edx.org/course/data-science-productivity-tools">Data Science: Productivity Tools</a> course.<br>
<br>
For most effective navigation in RStudio, document outine (Ctrl+Shift+O) aligns with the following .R contents:<br></p>
<br>
<p>--- Directory: <a href="https://github.com/DiaLeor/linear-regression/blob/main/intro_to_regression">intro_to_regression</a> ---<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/intro_to_regression/intro-1.R">intro-1.R</a><br>
- Section 1.1 - Baseball as a Motivating Example<br>
<br>
&emsp;&emsp;- Motivating Example: Moneyball - a brief history of statistics in baseball<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Baseball Basics - the basics of baseball<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Bases on Balls or Stolen Bases? - comparing several plots on team data<br>
&emsp;&emsp;<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/intro_to_regression/intro-2.R">intro-2.R</a><br>
- Section 1.2 - Correlation<br>
<br>
&emsp;&emsp;- Correlation - Galton's data on the heights of fathers and sons in his family<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Correlation Coefficient - understanding how two variables move together<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Sample Correlation is a Random Variable - interpreting correlations as estimates containing uncertainty<br>
&emsp;&emsp;<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/intro_to_regression/intro-3.R">intro-3.R</a><br>
- Section 1.3 - Stratification and Variance Explained<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Anscombe's Quartet - correlation is not always a good summary<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Stratification - introducing the regression line<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Bivariate Normal Distribution - understanding the bivariate normal distribution<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Variance Explained - the standard deviation squared<br>
&emsp;&emsp;<br>
&emsp;&emsp;- There are Two Regression Lines - regression lines differ depending on expectations computed for a given y or given x<br>
&emsp;&emsp;<br></p>
<p>--- Directory: <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots">intro_to_regression/plots</a> ---<br>
(listed in order of appearance)<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/HRs_wins.png">HRs_wins.png</a><br>
- scatter plot of the relationship between home runs and wins<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/SBs_wins.png">SBs_wins.png</a><br>
- scatter plot of the relationship between stolen bases and wins<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/BBs_wins.png">BBs_wins.png</a><br>
- scatter plot of the relationship between bases on balls and wins<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/fathers_sons_heights.png">fathers_sons_heights.png</a><br>
- scatter plot of the relationship between fathers' and sons' heights<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/sample_correlation_distribution.png">sample_correlation_distribution.png</a><br>
- histogram of the distrubution of the sample correlation<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/sample_correlation_QQplot.png">sample_correlation_QQplot.png</a><br>
- QQplot to evaluate whether N is large enough in the sample<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/fathers_sons_regression_line.png">fathers_sons_regression_line.png</a><br>
- plot regression line on fathers' and sons' heights<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/stratified_heights.png">stratified_heights.png</a><br>
- plots stratifying son height by standardized father heights<br></p>
<p>.<br>
..<br>
.<br></p>
<p>--- Directory: <a href="https://github.com/DiaLeor/linear-regression/tree/main/intro_to_regression/plots/linear_models.png">linear_models</a> ---<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/linear_models/models-1.R">models-1.R</a><br>
- Section 2.1 - Introduction to Linear Models<br>
<br>
&emsp;&emsp;- Confounding: Are BBs More Predictive? - bases on balls are confounded with home runs<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Stratification and Multivariate Regression - using stratification to adjust for confounding<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Linear Models - simple linear models<br>
&emsp;&emsp;<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/linear_models/models-2.R">models-2.R</a><br>
- Section 2.2 - Least Squares Estimates<br>
<br>
&emsp;&emsp;- Least Squares Estimates (LSE) - short summary on LSE and RSS<br>
&emsp;&emsp;<br>
&emsp;&emsp;- The lm Function - how to obtain the LSE in r using the lm() funciton.<br>
&emsp;&emsp;<br>
&emsp;&emsp;- LSE are Random Variables - LSE are derived from samples<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Advanced Note on LSE - LSE can be strongly correlated<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Predicted Variables are Random Varialbes - denoting predicted values<br>
&emsp;&emsp;<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/linear_models/models-3.R">models-3.R</a><br>
- Section 2.3 - Advanced dplyr: Summarize with Functions and Broom<br>
<br>
&emsp;&emsp;- Advanced dplyr: Summarize with Functions and Broom - introducing the broom package<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/linear_models/models-4.R">models-4.R</a><br>
- Section 2.4 - Regression and Baseball<br>
<br>
&emsp;&emsp;- Building a Better Offensive Metric for Baseball - player metrics based on a multivariate model<br>
&emsp;&emsp;<br>
&emsp;&emsp;- On Base Plus Slugging (OPS) - the metric sabermetricians actually use<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Regression Fallacy - add plots below<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Measurement Error Models - add plots below<br>
&emsp;&emsp;<br></p>
<p>--- Directory: <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots">linear_models/plots</a> ---<br>
(listed in order of appearance)<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/stratified_HR_for_RvBB.png">stratified_HR_for_RvBB.png</a><br>
- Scatter plots for runs versus bases on balls, stratified by home runs<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/stratified_BB_for_RvHR.png">stratified_BB_for_RvHR.png</a><br>
- Scatter plots for runs versus home runs, stratified by bases on balls<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/RSS_of_beta1_when_beta0=25.png">RSS_of_beta1_when_beta0=25.png</a><br>
- Sample plot of RSS as a function of beta1 when beta0 = 25<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/variability_of_estimated_betas.png">variability_of_estimated_betas.png</a><br>
- Histograms of estimates of beta_0 and beta_1 regression slope coefficients<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/predictions_and_confidence_intervals.png">predictions_and_confidence_intervals.png</a><br>
- Scatter plot of predicted son heights (Y-hat) and confidence intervals<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/best_fit_line.png">best_fit_line.png</a><br>
- Plot of the line of best fit for predicted son heights (Y-hat)<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/visualization_of_slope_stability.png">visualization_of_slope_stability.png</a><br>
- Visual confirming the assumption that our slopes don't change<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/runs_prediction_2002.png">runs_prediction_2002.png</a><br>
- Plot that predicts the runs in 2002 using data from previous years<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/player_specific_runs_prediction_2002.png">player_specific_runs_prediction_2002.png</a><br>
- Histogram that predicts the player-specific runs in 2002<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/player_metrics_salaries.png">player_metrics_salaries.png</a><br>
- Plot showing the metrics and salaries of all players<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/player_metrics_salaries_debut_pre1998.png">player_metrics_salaries_debut_pre1998.png</a><br>
- Plot showing the metrics and salaries of players, exluding those that debuted after 1998<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/falling_object_trajectory.png">falling_object_trajectory.png</a><br>
- Plot of the trajectory of the falling object<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/tree/main/linear_models/plots/fit_line_falling_object_trajectory.png">fit_line_falling_object_trajectory.png</a><br>
- Plot of the estimated parabola against the trajectory of the falling object<br></p>
<p>.<br>
..<br>
.<br></p>
<p>--- Directory: <a href="https://github.com/DiaLeor/linear-regression/tree/main/confounding">confounding</a> ---<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/confounding/confounding-1.R">confounding-1.R</a><br>
- Section 3.1 - Correlation is Not Causation<br>
<br>
&emsp;&emsp;- Spurious Correlation -<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Outliers -<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Reversing Cause and Effect -<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Confounders -<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Simpson's Paradox -<br>
<br></p>
<p>--- Directory: <a href="https://github.com/DiaLeor/linear-regression/tree/main/confounding/plots">confounding/plots</a> ---<br>
(listed in order of appearance)<br>
<br>
--<a href=""><br></p>
-
