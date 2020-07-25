/* Royal Family of England 1900-2000 */
/* Based on http://ftp.cac.psu.edu/~saw/royal/r02.html */

female('Queen Victoria').
female('Princess Alexandra of Denmark').
female('Queen Mary').
female('Mrs Simpson').
female('Lady Elizabeth Bowes-Lyon').
female('Queen Elizabeth II').
female('Princess Margaret').
female('Lady Diana Spencer').
female('Princess Anne').

male('Prince Albert').
male('King Edward VII').
male('King Edward VIII').
male('King George V').
male('King George VI').
male('Prince Philip').
male('Prince Charles').
male('Prince Andrew').
male('Prince Edward').
male('Prince William').
male('Prince Henry').

married('Prince Albert', 'Queen Victoria').
married('King Edward VII', 'Princess Alexandra of Denmark').
married('King George V', 'Queen Mary').
married('King Edward VIII', 'Mrs Simpson').
married('King George VI', 'Lady Elizabeth Bowes-Lyon').
married('Queen Elizabeth II', 'Prince Philip').
married('Prince Charles', 'Lady Diana Spencer').

parent('Prince Albert', 'King Edward VII').
parent('Queen Victoria', 'King Edward VII').
parent('King Edward VII', 'King George V').
parent('Princess Alexandra of Denmark', 'King George V').
parent('King George V', 'King Edward VIII').
parent('Queen Mary', 'King Edward VIII'). 
parent('King George V', 'King George VI').
parent('Queen Mary', 'King George VI').
parent('King George VI', 'Queen Elizabeth II').
parent('Lady Elizabeth Bowes-Lyon', 'Queen Elizabeth II').
parent('King George VI', 'Princess Margaret').
parent('Lady Elizabeth Bowes-Lyon', 'Princess Margaret').
parent('Queen Elizabeth II', 'Prince Charles').
parent('Prince Philip', 'Prince Charles').
parent('Queen Elizabeth II', 'Princess Anne').
parent('Prince Philip', 'Princess Anne').
parent('Queen Elizabeth II', 'Prince Andrew').
parent('Prince Philip', 'Prince Andrew').
parent('Queen Elizabeth II', 'Prince Edward').
parent('Prince Philip', 'Prince Edward').
parent('Prince Charles', 'Prince William').
parent('Lady Diana Spencer', 'Prince William').
parent('Prince Charles', 'Prince Henry').
parent('Lady Diana Spencer', 'Prince Henry').

/*5*/
father(X, Someone) :- parent(X, Someone), male(X).
sons(X, Someone) :- parent(X, Someone), male(Someone).
daughters(X, Someone) :- parent(X, Someone), female(Someone).
grandfathers(X, Someone, GP) :- parent(X, Someone), parent(GP,X), male(GP).
grandmothers(X, Someone, GP) :- parent(X, Someone), parent(GP,X), female(GP).
great-great-grandparents(X, Someone, GP) :- parent(X, Someone), parent(GP,X), parent(GGP,GP), parent(GGGP,GGP).

/*6*/
sibling(X,Y):- parent(S1,Y),female(S1),parent(S2,Y),male(S2),parent(S1,X),parent(S2,X),X\==Y.
brother(X,Y) :- male(X), sibling(X,Y).
sister(X,Y) :- female(X), sibling(X,Y).
uncle(X,Y) :- male(X), sibling(X,Someone), parent(Someone, Y).
aunt(X,Y) :- female(X), sibling(X,Someone), parent(Someone, Y).
cousins(X,Y) :- parent(S1,X), parent(S2,Y), sibling(S1,S2).

/*7*/
blood_uncle(X,Y) :- male(X), parent(Someone, Y), brother(X,Someone).
blood_aunt(X,Y) :- female(X), parent(Someone, Y), sister(X,Someone).
marriage_uncle(X,Y) :- male(X), parent(Someone, Y), sister(W,Someone), married(X,W).
marriage_aunt(X,Y) :- female(X), parent(Someone, Y), brother(W,Someone), married(X,W).

/*8*/
grandparents(X,Y) :- parent(S1, X), parent(X, S2).
grandchild(X,Y) :- parent(S1, X), parent(Y, S2).

/*9*/
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).

/*10*/
descendant(X,Y):- parent(Y,S1),descendant(X,S1).