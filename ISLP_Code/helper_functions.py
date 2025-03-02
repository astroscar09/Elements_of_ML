import statsmodels.api as sm
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from statsmodels .stats.anova import anova_lm
from ISLP.models import ( ModelSpec as MS ,
                          summarize ,
                          poly)
from statsmodels.stats.outliers_influence \
import variance_inflation_factor as VIF


def construct_X_array(df, features_cols):
    '''
    Function to construct the design matrix for the linear model, using the MS class

    Parameters:
    df: DataFrame of the data
    features_cols: List of column names to be used as features in the model

    Returns:
    design: MS class object
    X: DataFrame of the design matrix
    '''

    design = MS(features_cols)
    X = design.fit_transform(df)
    return design, X

def determine_collinearity(X):
    
    '''
    Function to detmeine if the transformed features have collinearity or not
    A value above 5-10 is considered to have collinearity

    Parameters:
    
    X: DataFrame of transformed features, must be passed through the MS class

    Returns:
    
    vif: DataFrame of the VIF values of the transformed features

    '''

    vals = [VIF(X, i) for i in range (1, X.shape [1])]
    vif = pd.DataFrame ({'vif ':vals}, index=X.columns [1:])
    return vif 

def run_linear_model(df, features_cols, target_col):
    _, X = construct_X_array(df, features_cols)
    y = df[target_col]
    model = sm.OLS(y, X)
    results = model.fit()

    return results

def run_multiple_linear_model(df, features_cols, target_col):
    
    design, X = construct_X_array(df, features_cols)
    y = df[target_col]
    model = sm.OLS(y, X)
    results = model.fit()

    df = anova_lm(*[sm.OLS(y, D).fit() for D in design.build_sequence(features_cols, anova_type='sequential')])
    df.index = design.names

    vif = determine_collinearity(X)

    return results, df, vif

def plot_residuals(results):
    
    residual = results.resid
    xaxis = results.fittedvalues
    
    fig, ax = plt.subplots(*args, **kwargs)
    ax.scatter(xaxis, residual, *args, **kwargs)
    ax.axhline(0, color='red', lw=2)
    ax.set_xlabel('Index', fontsize = 15)
    ax.set_ylabel('Residual', fontsize = 15)
    return fig, ax 

def abline(ax , b, m, *args , **kwargs):
    "Add a line with slope m and intercept b to ax"
    xlim = ax. get_xlim ()
    ylim = [m * xlim [0] + b, m * xlim [1] + b]
    ax.plot(xlim , ylim , *args , **kwargs)