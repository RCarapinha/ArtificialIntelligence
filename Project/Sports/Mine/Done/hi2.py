import pyfootball as pf
from scipy.stats import poisson
from prettytable import PrettyTable

class Team:
	def __init__(self):
		self.id=None
		self.name=None
		self.aGames=0
		self.hGames=0
		self.hScored=0
		self.aScored=0
		self.hConced=0
		self.aConced=0
		self.nextF=None
	def hGame(self,x,y):
		self.hGames+=1
		self.hScored+=x
		self.hConced+=y
	def aGame(self,x,y):
		self.aGames+=1
		self.aScored+=y
		self.aConced+=x
	def h_a(self,liga):
		return (self.hScored/1.0/self.hGames)/(liga.hScored*1.0/liga.hGames)
	def h_d(self,liga):
		return (self.hConced/1.0/self.hGames)/(liga.hConced*1.0/liga.hGames)
	def a_a(self,liga):
		return (self.aScored/1.0/self.aGames)/(liga.aScored*1.0/liga.hGames)
	def a_d(self,liga):
		return (self.hConced/1.0/self.hGames)/(liga.hConced*1.0/liga.hGames)

def findTeam_byid(id,lista):
	for t in lista:
		if(t.id==id):
			return t
	else:
		return None

def findTeam(name,lista):
	for t in lista:
		if(t.name==name):
			return t
	else:
		return None
def prob1x2(hProb,aProb,result):
	prob=0;
	for h in range(0,6):
		for a in range(0,6):
			if(result>0 and h>a):
				prob+=hProb[h]*aProb[a]
			elif(result<0 and h<a):
				prob+=hProb[h]*aProb[a]
			elif(result==0 and h==a):
				prob+=hProb[h]*aProb[a]
	return prob


f=pf.Football("f5216301f58e44e09c87610737a249f8")
#Campeonato Brasileiro da Serie A   444
#Premier League 2017/18   445
#Championship 2017/18   446
#League One 2017/18   447
#League Two 2017/18   448
#Eredivisie 2017/18   449
#Ligue 1 2017/18   450
#Ligue 2 2017/18   451
#1. Bundesliga 2017/18   452
#2. Bundesliga 2017/18   453
#Primera Division 2017   455
#Serie A 2017/18   456
#Primeira Liga 2017/18   457
#DFB-Pokal 2017/18   458
#Serie B 2017/18   459
#Champions League 2017/18   464
#Australian A-League   466

c_id=446
teams=f.get_competition_teams(c_id)
liga=Team()
lista=[]
for t in teams:
	fixt=f.get_team_fixtures(t.id)
	team=Team()
	team.id=t.id
	team.name=t.name
	for fi in fixt:
		if(fi.competition_id==c_id):
			if(fi.status=="FINISHED"):
				if(t.id==fi.home_team_id):
					team.hGame(fi.result["home_team_goals"],fi.result["away_team_goals"])
					liga.hGame(fi.result["home_team_goals"],fi.result["away_team_goals"])
				if(t.id==fi.away_team_id):
					team.aGame(fi.result["home_team_goals"],fi.result["away_team_goals"])
					liga.aGame(fi.result["home_team_goals"],fi.result["away_team_goals"])
			elif(fi.status=="TIMED"):
				if(team.nextF==None):
					team.nextF=fi
	lista.append(team)
t=PrettyTable(['HomeTeam','HomeGoals','AwayGoals','AwayTeam','1','x','2'])
for x in lista:
	if(x.nextF!=None):
		h=findTeam(x.nextF.home_team,lista)
		a=findTeam(x.nextF.away_team,lista)
		ho='c'
		do='d'
		ao='a'
		if(x.nextF.odds!=None):
			ho='a'
			do='b'
			ao='c'
		if(x.nextF.competition_id==c_id):
			if(x==h):
				hScore=poisson(h.h_a(liga)*a.a_d(liga)*(liga.hScored+liga.aScored)/(liga.hGames+liga.aGames))
				aScore=poisson(a.a_a(liga)*h.h_d(liga)*(liga.hScored+liga.aScored)/(liga.hGames+liga.aGames))
				hProb=[]
				aProb=[]
				for num in range(0,6):
					hProb.append(hScore.pmf(num))
					aProb.append(aScore.pmf(num))
				hProb_max=max(hProb)
				aProb_max=max(aProb)
				hGoals=hProb.index(hProb_max)
				aGoals=aProb.index(aProb_max)
				hWin=0.0
				aWin=0.0
				draw=0.0
				for hg in range(0,6):
					for ag in range(0,6):
						if(hg==ag):
							draw+=hProb[hg]*aProb[ag]
						elif(hg>ag):
							hWin+=hProb[hg]*aProb[ag]
						else:
							aWin+=hProb[hg]*aProb[ag]
				t.add_row([str(h.name),str(hGoals),str(aGoals),str(a.name),str(ho),str(do),str(ao)])
print(t)
