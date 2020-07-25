import pyfootball as pf

f=pf.Football("491b353d4d534159a3e01983131925bd")
comps=f.get_all_competitions()
for c in comps:
	print (str(c.name) + "   " +str(c.id))
