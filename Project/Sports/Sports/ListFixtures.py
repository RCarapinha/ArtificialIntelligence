#data is separated by commas
import csv

#open data and skip first row (only has the headers)
csv_file1 = csv.reader(open('20152016.csv'))
csv_file2 = csv.reader(open('20162017.csv'))
csv_file3 = csv.reader(open('20172018.csv'))
next(csv_file1)
next(csv_file2)
next(csv_file3)
#-----------

i = 0
j = 0
teams = list()
fixts = list()

for game1 in csv_file1:
	if game1[2] in teams:
		i = i
	else:
		teams.insert(i, game1[2])
		i = i+1

for game2 in csv_file2:
	if game2[2] in teams:
		i = i
	else:
		teams.insert(i, game2[2])
		i = i+1

for game3 in csv_file3:
	if game3[2] in teams:	
		i = i
	else:
		teams.insert(i, game3[2])
		i = i+1

print(*teams, sep = "\n")

print("\n")
t_id = int(input("Choose Team -> "))

print("\n")
team_c = teams[t_id]
print(team_c)
print("\n")

#go back to the beggining
csv_file1 = csv.reader(open('20152016.csv'))
csv_file2 = csv.reader(open('20162017.csv'))
csv_file3 = csv.reader(open('20172018.csv'))
next(csv_file1)
next(csv_file2)
next(csv_file3)
#-----------

for fixt1 in csv_file1:
	if (team_c == fixt1[2]):
		fixts.insert(j, fixt1[2] + " " + fixt1[4] + " - " + fixt1[5] + " " + fixt1[3])
		j = j + 1
	elif (team_c == fixt1[3]):
		fixts.insert(j, fixt1[2] + " " + fixt1[4] + " - " + fixt1[5] + " " + fixt1[3])
		j = j + 1

for fixt2 in csv_file2:
	if (team_c == fixt2[2]):
		fixts.insert(j, fixt2[2] + " " + fixt2[4] + " - " + fixt2[5] + " " + fixt2[3])
		j = j + 1
	elif (team_c == fixt2[3]):
		fixts.insert(j, fixt2[2] + " " + fixt2[4] + " - " + fixt2[5] + " " + fixt2[3])
		j = j + 1

for fixt3 in csv_file3:
	if (team_c == fixt3[2]):
		fixts.insert(j, fixt3[2] + " " + fixt3[4] + " - " + fixt3[5] + " " + fixt3[3])
		j = j + 1
	elif (team_c == fixt3[3]):
		fixts.insert(j, fixt3[2] + " " + fixt3[4] + " - " + fixt3[5] + " " + fixt3[3])
		j = j + 1

print(*fixts, sep = "\n")
