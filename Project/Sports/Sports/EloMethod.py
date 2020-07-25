#this v1 defines an overall for all the teams than compares them

#Libraries
import csv
#--------

def ListAllTeams():
	csv_file1 = csv.reader(open('20152016.csv'))
	csv_file2 = csv.reader(open('20162017.csv'))
	csv_file3 = csv.reader(open('20172018.csv'))
	next(csv_file1)
	next(csv_file2)
	next(csv_file3)
	teams_l = list()
	i = 0
	for game1 in csv_file1:
		if game1[2] in teams_l:
			i = i
		else:
			teams_l.insert(i, game1[2])
			i = i+1

	for game2 in csv_file2:
		if game2[2] in teams_l:
			i = i
		else:
			teams_l.insert(i, game2[2])
			i = i+1

	for game3 in csv_file3:
		if game3[2] in teams_l:	
			i = i
		else:
			teams_l.insert(i, game3[2])
			i = i+1
	return teams_l

def EloFunction(teams):
	elo = list()
	for team_c in teams:
		csv_file1 = csv.reader(open('20152016.csv'))
		csv_file2 = csv.reader(open('20162017.csv'))
		csv_file3 = csv.reader(open('20172018.csv'))
		next(csv_file1)
		next(csv_file2)
		next(csv_file3)
		ForGoals = 0
		AgainstGoals = 0
		wins = 0
		losts = 0

		for fixt1 in csv_file1:	
			if (team_c == fixt1[2]):
				ForGoals += int(fixt1[4])
				AgainstGoals += int(fixt1[5])
				if (fixt1[4] > fixt1[5]):
					wins += 1
				elif (fixt1[4] < fixt1[5]):
					losts += 1
			elif (team_c == fixt1[3]):
				ForGoals += int(fixt1[5])
				AgainstGoals += int(fixt1[4])
				if (fixt1[4] > fixt1[5]):
					losts += 1
				elif (fixt1[4] < fixt1[5]):
					wins += 1
		
		for fixt2 in csv_file2:
			if (team_c == fixt2[2]):
				ForGoals += int(fixt2[4])
				AgainstGoals += int(fixt2[5])
				if (fixt2[4] > fixt2[5]):
					wins += 1
				elif (fixt2[4] < fixt2[5]):
					losts += 1
			elif (team_c == fixt2[3]):
				ForGoals += int(fixt2[5])
				AgainstGoals += int(fixt2[4])
				if (fixt2[4] > fixt2[5]):
					losts += 1
				elif (fixt2[4] < fixt2[5]):
					wins += 1
		
		for fixt3 in csv_file3:
			if (team_c == fixt3[2]):
				ForGoals += int(fixt3[4])
				AgainstGoals += int(fixt3[5])
				if (fixt3[4] > fixt3[5]):
					wins += 1
				elif (fixt3[4] < fixt3[5]):
					losts += 1
			elif (team_c == fixt3[3]):
				ForGoals += int(fixt3[5])
				AgainstGoals += int(fixt3[4])
				if (fixt3[4] > fixt3[5]):
					losts += 1
				elif(fixt3[4] < fixt3[5]):
					wins += 1
		elo.insert(teams.index(team_c), str(wins*0.5 - losts*0.2 + ForGoals*0.1 - AgainstGoals*0.2))
	return elo

team = ListAllTeams()
el = EloFunction(team)

print(*team, sep = "\n")
th_id = int(input("Choose Home Team -> "))
ta_id = int(input("Choose Away Team -> "))

if (el[th_id] > el[ta_id]):
	print("Home Team Win")
elif (el[ta_id] > el[th_id]):
	print("Away Team Win")
else:
	print("Draw")
