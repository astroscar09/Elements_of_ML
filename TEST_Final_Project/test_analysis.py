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
import seaborn as sb
from itertools import combinations
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split


features_cols = ['burst',
                 'delayed:age',
                 'delayed:massformed',
                 'delayed:metallicity',
                 'delayed:tau',
                 'dust:Av',
                 'nebular:logU',
                 'stellar_mass',
                 'formed_mass',
                 'sfr',
                 'ssfr',
                 'mass_weighted_age',
                 'mass_weighted_zmet', 
                'redshift']



features = pd.read_csv('Features_with_Continuum.txt', sep = ' ', index_col = 0)

yval = pd.read_csv('Predictions_with_Continuum.txt', sep = ' ', index_col = 0)


good_chi2_mask = (features.chisq_phot.values < 100) & (features.chisq_phot.values > 0)
good_sn_mask = yval.sn.values > 5.5

mask = good_chi2_mask & good_sn_mask

good_data = features[mask]
good_yvals = yval[mask]


remove_bad_EW = good_yvals.EW_r < 1000

good_data = good_data[remove_bad_EW]
good_yvals = good_yvals[remove_bad_EW]

merge_df = good_data.join(good_yvals)


def remove_outliers_IQR(data):

    Q1 = np.percentile(data, 25)
    Q3 = np.percentile(data, 75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR
    outliers = (data < lower_bound) | (data > upper_bound)
    data_no_outliers = data[~outliers]
    
    return data_no_outliers, outliers


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


def construct_X_array_polynomial(df, features_cols, poly_order = 2):

    cols = [poly(f, degree = poly_order) for f in features_cols]
    
    design = MS(cols)
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


def run_multiple_linear_model(df, features_cols, target_col, add_interactions = False):
    
    if add_interactions:
        #interactions = []
        interaction_terms = [(p1, p2) for p1, p2 in combinations(features_cols, 2)]
        features_cols.extend(interaction_terms)
    print(features_cols)

    design, X = construct_X_array(df, features_cols)
    y = df[target_col]
    model = sm.OLS(y, X)
    results = model.fit()

    # #df = anova_lm(*[sm.OLS(y, D).fit() for D in design.build_sequence(features_cols, anova_type='sequential')])
    # #df.index = design.names

    # vif = determine_collinearity(X)

    return results



def main(df, add_interactions = False):

    results = run_multiple_linear_model(df, features_cols, 'EW_r', add_interactions=add_interactions)
    print(results.summary())
    #print(anova)
    #print(vif)

    return results

def plot_residual(results, *args, **kwargs):
    
    residual = results.resid
    xaxis = results.fittedvalues
    
    fig, ax = plt.subplots(*args, **kwargs)
    ax.scatter(xaxis, residual, alpha = 0.5, marker = '.', s = 1, color = 'purple')
    ax.axhline(0, color='red', lw=1, linestyle='--') 
    ax.set_xlabel('Index', fontsize = 15)
    ax.set_ylabel('Residual', fontsize = 15)
    
    return fig, ax 


if __name__ == '__main__':
    results = main(merge_df, add_interactions = True)

    fig, ax = plot_residual(results)

    fig.savefig('residuals.png', dpi = 150)
