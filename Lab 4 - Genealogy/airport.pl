/* flight(Company, Number of Flight) */
flight(ryanair,1).
flight(ryanair,2).
flight(ryanair,3).
flight(ryanair,4).
flight(tap,5).
flight(tap,6).
flight(tap,7).
flight(emirates,8).
flight(emirates,9).
flight(emirates,10).
flight(emirates,11).
flight(wizz,12).
flight(wizz,13).
flight(wizz,14).
flight(wizz,15).

/* city(Code, City, GMT Time) */
city(por,porto,0).
city(lis,lisbon,0).
city(wro,wroclaw,1).
city(prg,prague,1).
city(bud,budapest,1).
city(ist,istanbul,3).
city(osl,oslo,1).
city(lon,london,0).
city(bar,barcelona,1).
city(mad,madrid,1).

/* hop(flight(), Code, City, Time(Departure), Time(Arrival)) */
hop(flight(ryanair,1),por,lis,time(8,30),time(9,15)).
hop(flight(ryanair,2),lis,wro,time(10,15),time(12,35)).
hop(flight(ryanair,3),wro,prg,time(13,35),time(14,18)).
hop(flight(ryanair,4),prg,bud,time(15,18),time(16,21)).
hop(flight(tap,5),bud,lon,time(17,21),time(18,28)).
hop(flight(tap,6),ist,osl,time(19,28),time(21,47)).
hop(flight(tap,7),osl,lon,time(22,47),time(1,33)).
hop(flight(emirates,8),lon,bar,time(2,33),time(5,18)).
hop(flight(emirates,9),bar,mad,time(6,18),time(7,26)).
hop(flight(emirates,10),mad,por,time(8,26),time(8,27)).
hop(flight(emirates,11),bar,lis,time(9,27),time(10,3)).
hop(flight(wizz,12),lon,wro,time(11,3),time(13,52)).
hop(flight(wizz,13),osl,prg,time(14,52),time(16,36)).
hop(flight(wizz,14),ist,bud,time(17,36),time(18,16)).
hop(flight(wizz,15),bud,lon,time(19,16),time(22,23)).
hop(flight(ryanair,2),por,osl,time(23,23),time(2,44)).
hop(flight(tap,5),osl,wro,time(3,44),time(5,23)).
hop(flight(emirates,8),wro,bar,time(6,23),time(8,39)).
hop(flight(wizz,15),osl,mad,time(9,39),time(12,54)).
hop(flight(ryanair,1),ist,prg,time(13,54),time(15,6)).

airport_hop(A1, A2) :- hop(_,A1,A2,_,_).

city_hop(C1,C2):- hop(_,S1,S2,_,_), city(S1,C1,_),city(S2,C2,_).

two_hop(A1,A2) :- flight(_,A1,S1,_,_), flight(_,S1,A2,_,_), A1\==A2.

time_diff(T1,T2,T) :- T1 = time(X,Y), T2 = time(W,Z), T = time(K,I), I is Z-Y, K is W-X.

duration(A1,A2,T,F):- airport_hop(A1,A2), hop(S1,A1,A2,T1,T2), time_diff(T1,T2,T).

no_layover(A1,A2):- two_hop(A1,A2), hop(_,A1,S1,T1,_), hop(_,S1,A2,T2,_), time_diff(T1,T2,T), T = time(T3,_), T3 < 2.

direct(A1,A2,F):- hop(F,A1,A2,_,_).