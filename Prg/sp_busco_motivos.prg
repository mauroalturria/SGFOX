*****
**  busco motivos
*****
lparameters msect
if type('msect') # "N"
	msect = 0
endif
mret = sqlexec(mcon1,"select id, descrip, sector from tabmotivos " + ;
	" where sector = ?msect and id <100000 order by descrip", "mwkmotivos")

