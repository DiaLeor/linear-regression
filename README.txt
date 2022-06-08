Taking notes on the Data Science: Linear Regression course; practicing what I've learned during the previous Data Science Productivity Tools course.

Link to HarvardX Data Science: Productivity Tools:
  https://www.edx.org/course/data-science-productivity-tools

Link to HarvardX Data Science: Linear Regression:
  https://www.edx.org/course/data-science-linear-regression

For most effective navigation--In RStudio, document outine (Ctrl+Shift+O) aligns with the following .R contents:

--- Directory: intro_to_regression ---

-- intro-1.R
- Section 1.1 - Introduction to Regression: Baseball as a Motivating Example

    - Motivating Example: Moneyball - a brief history of statistics in baseball
    
    - Baseball Basics - the basics of baseball
    
    - Bases on Balls or Stolen Bases? - comparing several plots on team data
    
-- intro-2.R
- Section 1.2 - Introduction to Regression: Correlation

    - Correlation - Galton's data on the heights of fathers and sons in his family
    
    - Correlation Coefficient - understanding how two variables move together
    
    - Sample Correlation is a Random Variable - interpreting correlations as estimates containing uncertainty
    
-- intro-3.R
- Section 1.3 - Introduction to Regression: Stratification and Variance Explained
    
    - Anscombe's Quartet/Stratification - introducing the regression line
    
    - Bivariate Normal Distribution - understanding the bivariate normal distribution
    
    - Variance Explained - the standard deviation squared
    
    - There are Two Regression Lines - regression lines differ depending on expectations computed for a given y or given x
    
--- Directory: intro_to_regression/plots ---
- listed in order of appearance
    
-- HRs_wins.png
- scatter plot of the relationship between home runs and wins

-- SBs_wins.png
- scatter plot of the relationship between stolen bases and wins

-- BBs_wins.png
- scatter plot of the relationship between bases on balls and wins

-- fathers_sons_heights.png
- scatter plot of the relationship between fathers' and sons' heights

-- sample_correlation_distribution.png
- histogram of the distrubution of the sample correlation

-- sample_correlation_QQplot.png
- QQplot to evaluate whether N is large enough in the sample

-- fathers_sons_regression_line.png
- plot regression line on fathers' and sons' heights

-- stratified_heights.png
- plots stratifying son height by standardized father heights
.
..
.
--- Directory: linear_models ---