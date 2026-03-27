date = ctod("01/02/2012")
mfecha = ctod("01/02/2012")
requery ("vales_real")
select * from vales_real where val_codsector = "AMB" into cursor algo
Use Dbf('algo') In 0 Again Alias vales

for i = 1 to 28
	date = mfecha + i
	requery ("vales_real")
	select * from vales_real where val_codsector = "AMB" into cursor nuevo
	select vales
	append from dbf("nuevo")
next