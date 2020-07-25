import pyfootball as pf
from scipy.stats import poisson
from prettytable import PrettyTable

f=pf.Football("f5216301f58e44e09c87610737a249f8")
c_id=457
teams=f.get_competition_teams(c_id)
for t in teams:
	for p in f.get_team_players(t.id):
		if(p!=None):
			print(p.name)