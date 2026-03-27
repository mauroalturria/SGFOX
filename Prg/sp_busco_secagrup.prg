****
** busco sectores agrupados
****
Parameter mgrupo

mfecpas = ctod('01/01/1900')

mret = sqlexec(mcon1, "SELECT TH_codserv "+;
	"FROM TabHorarios "+;
	"where TH_funcion = 8 and TH_codserv>0 ", "mwksecagrup")

If mret < 0
	=aerror(err)
	Messagebox('ERROR '+err(3), 16,'Validacion')
Endif
