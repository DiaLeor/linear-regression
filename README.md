<p>Taking notes on the <a href="https://www.edx.org/course/data-science-linear-regression">Data Science: Linear Regression</a> course; practicing what I've learned during the previous <a href="https://www.edx.org/course/data-science-productivity-tools">Data Science: Productivity Tools</a> course. For most effective navigation in RStudio, document outine (Ctrl+Shift+O) aligns with the following .R contents:<br></p>
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
&emsp;&emsp;- There are Two Regression Lines - regression lines differ depending on expectations computed for a given y or given x<br></p>
<p><br>
<br></p>
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
&emsp;&emsp;- Regression Fallacy - errors in reasoning brought about by regression<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Measurement Error Models - a linear regression model with a non-random covariate<br></p>
<p><br>
<br></p>
<p>--- Directory: <a href="https://github.com/DiaLeor/linear-regression/tree/main/confounding">confounding</a> ---<br>
<br>
-- <a href="https://github.com/DiaLeor/linear-regression/blob/main/confounding/confounding-1.R">confounding-1.R</a><br>
- Section 3.1 - Correlation is Not Causation<br>
<br>
&emsp;&emsp;- Spurious Correlation - correlations among variables that are theoretically uncorrelated<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Outliers -<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Reversing Cause and Effect -<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Confounders -<br>
&emsp;&emsp;<br>
&emsp;&emsp;- Simpson's Paradox -<br></p>
