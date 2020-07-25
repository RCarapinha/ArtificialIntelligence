import pyfootball as pf
from scipy.stats import poisson
from prettytable import PrettyTable

f=pf.Football("491b353d4d534159a3e01983131925bd")
for c in f.get_all_competitions():
	print(c.name)
