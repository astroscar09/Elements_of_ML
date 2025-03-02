import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sb

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
import statsmodels.api as sm



plt.rcParams.update({
    'axes.linewidth': 1.5,
    'font.family': 'serif',
    'xtick.labelsize': 15,
    'ytick.labelsize': 15
})
