import pandas as pd
import numpy as np

df = pd.read_csv("2-ramp-inlet-blk-2-cell-1639.dat.0", 
                 sep="\s+", 
                 skiprows=1, 
                 names=['t', 'pos.x', 'pos.y', 'pos.z', 'volume', 'rho', 'vel.x', 'vel.y', 'vel.z', 'p', 'a', 'mu', 'k', 'mu_t', 'k_t', 'S', 'massf[0]-air', 'u', 'T'])
tol = 1e-3
for index, cur_val in enumerate(df['p']):
    if index > 0:
        prev_val = df['p'].iloc[index - 1]
        err = abs(cur_val - prev_val)
        if err < tol:
            print(f"The steady state value of p is {cur_val:.6e}, this occurs at time {df['t'].iloc[index]:.6e}")
