/* Data */
name('Rui Carapinha').
name('Luis Carapinha').
name('Vadson Culanda').
name('Antonio Carapinha').

age(20, 'Rui Carapinha').
age(24, 'Luis Carapinha').
age(21, 'Vadson Culanda').
age(47, 'Antonio Carapinha').

profession('Student', 'Rui Carapinha').
profession('3D Modeler', 'Luis Carapinha').
profession('Student', 'Vadson Culanda').
profession('Maintenance', 'Antonio Carapinha').

country('Portugal', 'Rui Carapinha').
country('Portugal', 'Luis Carapinha').
country('Angola', 'Vadson Culanda').
country('Portugal', 'Antonio Carapinha').

city('Ovar', 'Rui Carapinha').
city('Ovar', 'Luis Carapinha').
city('Aveiro', 'Vadson Culanda').
city('Ovar', 'Antonio Carapinha').

home_university('Universidade De Aveiro', 'Rui Carapinha').
home_university('Universidade De Aveiro', 'Vadson Culanda').
home_university('Universidade De Aveiro', 'Antonio Carapinha').

away_university('Politechnika Wroclawska', 'Rui Carapinha').
away_university('Politechnika Wroclawska', 'Vadson Culanda').

siblings(1, 'Rui Carapinha').
siblings(1, 'Luis Carapinha').
siblings(4, 'Antonio Carapinha').
siblings(5, 'Vadson Culanda').

current('Erasmus', 'Rui Carapinha').
current('Erasmus', 'Vadson Culanda').
current('Working', 'Luis Carapinha').
current('Working', 'Antonio Carapinha').

birthday('23', 'December', 'Rui Carapinha').
birthday('25', 'November', 'Vadson Culanda').
birthday('31', 'March', 'Luis Carapinha').
birthday('31', 'December', 'Antonio Carapinha').

/* Rules */
who(X,Y,Z):- name(X), age(Y, X), profession(Z, X).
whoInErasmus(X) :- name(X), current(Y,X), Y == 'Erasmus'.
older(X) :- age(S1,X), not(( age(S2,_), S2 > S1 )).
moreSiblings(X) :- siblings(S1,X), not(( siblings(S2,_), S2 > S1 )).
liveInOvar(X) :- city(X,Y), X == 'Ovar'.
birthdayInDecember(X) :- birthday(_,S1,X), S1 == 'December'.