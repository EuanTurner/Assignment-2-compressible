import pandas as pd

df = pd.read_csv("throat-wall-ss.dat", 
                 sep="\s+", 
                 skiprows=1, 
                 names=['pos.x', 'pos.y', 'pos.z', 'volume', 'rho', 'vel.x', 'vel.y', 'vel.z', 'p', 'a', 'mu', 'k', 'mu_t', 'k_t', 'S', 'massf[0]-air', 'u', 'T', 'M_local', 'total_p'])

df2 = df["p"].mean()

print(df2)
