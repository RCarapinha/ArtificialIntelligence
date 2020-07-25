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
teams = list()

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

print(len(teams))
teams.sort()
print(*teams, sep = "\n")
