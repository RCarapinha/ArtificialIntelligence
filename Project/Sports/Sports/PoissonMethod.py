#Libraries
import csv
import math
import ast
import numpy as np
#---------

#Functions
def poisson(actual, mean):
    return math.pow(mean, actual) * math.exp(-mean) / math.factorial(actual)

def ListAllTeams():
	csv_file = csv.reader(open('E0.csv'))
	next(csv_file)

	teams_l = list()
	i = 0
	for game in csv_file:
		if game[2] in teams_l:
			i = i
		else:
			teams_l.insert(i, game[2])
			i = i+1
	return teams_l

def ListStats(teams):
	ForGoals_l = list()
	AwayGoals_l = list()

	home_team_a = list()
	home_team_d = list()
	away_team_a = list()
	away_team_d = list()

	homegames_l = list()
	awaygames_l = list()
	avg_for_home_goals_l = list()
	avg_against_home_goals_l = list()
	avg_for_away_goals_l = list()
	avg_against_away_goals_l = list()

	for team_c in teams:
		csv_file = csv.reader(open('E0.csv'))
		next(csv_file)

		HomeForGoals = 0
		HomeAgainstGoals = 0
		AwayForGoals = 0
		AwayAgainstGoals = 0
		ForGoals = 0
		AgainstGoals = 0
		HomeGames = 0
		AwayGames = 0

		for fixt in csv_file:	
			if (team_c == fixt[2]):
				HomeGames += 1
				HomeForGoals += int(fixt[4])
				HomeAgainstGoals += int(fixt[5])
			elif (team_c == fixt[3]):
				AwayGames += 1
				AwayForGoals += int(fixt[5])
				AwayAgainstGoals += int(fixt[4])

		ind = teams.index(team_c)

		homegames_l.insert(ind, HomeGames)
		awaygames_l.insert(ind, AwayGames)

		avg_for_home_goals_l.insert(ind, HomeForGoals / HomeGames)
		avg_against_home_goals_l.insert(ind, HomeAgainstGoals / HomeGames)
		avg_for_away_goals_l.insert(ind, AwayForGoals / AwayGames)
		avg_against_away_goals_l.insert(ind, AwayAgainstGoals / AwayGames)

		home_team_a.insert(ind, HomeForGoals/HomeGames)
		home_team_d.insert(ind, HomeAgainstGoals/HomeGames)
		away_team_a.insert(ind, AwayForGoals/AwayGames)
		away_team_d.insert(ind, AwayAgainstGoals/AwayGames)

	return home_team_a, home_team_d, away_team_a, away_team_d, avg_for_home_goals_l, avg_for_away_goals_l
#---------

def main(): 
	All_teams = ListAllTeams()

	HomeTeam_A, HomeTeam_D, AwayTeam_A, AwayTeam_D, AvgForHomeGoals, AvgForAwayGoals = ListStats(All_teams)
	
	HomeExp = list()
	AwayExp = list()

	k = 0

	while k < len(All_teams):
		AFHG = float(AvgForHomeGoals[k])
		AFAG = float(AvgForAwayGoals[k])


		HomeExp.insert(k, AFHG * float(HomeTeam_A[k]) * float(HomeTeam_D[k]))
		AwayExp.insert(k, AFAG * float(AwayTeam_A[k]) * float(AwayTeam_D[k]))
		k += 1

	j = 0
	while j < len(All_teams):
		print(str(j) + " - "+ All_teams[j])
		j += 1

	th_id = int(input("Choose Home Team -> "))
	ta_id = int(input("Choose Away Team -> "))

	csv_file = csv.reader(open('E0.csv'))
	next(csv_file)

	home_win_prob = 0
	draw_prob = 0
	away_win_prob = 0

	for row in csv_file:
		if row[2] == All_teams[th_id]:
			if row[3] == All_teams[ta_id]:
				HomeG = row[4]
				AwayG = row[5]
				for i in range(10):
					for j in range(10):
						prob = poisson(i, HomeExp[th_id]) * poisson(j, AwayExp[ta_id])
						if i > j:
							home_win_prob += prob
						elif i == j:
							draw_prob += prob
						elif i < j:
							away_win_prob += prob
						
				print("Home Win Probability: " + str(home_win_prob))
				print("Away Win Probability: " + str(away_win_prob))
				print("Draw Win Probability: " + str(draw_prob))

				if (draw_prob > away_win_prob):
					if (draw_prob > home_win_prob):
						print("Draw")

				if (away_win_prob > home_win_prob):
					print("Away Team Win")
				elif (away_win_prob < home_win_prob):
					print("Home Team Win")

				print("Last Real Result: " + HomeG + " - " + AwayG)

				break

main()