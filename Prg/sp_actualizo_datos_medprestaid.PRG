****
** Actualizo sala, demanda, duracion y generaagen en medpresta x por ID
****

Parameters mcsala,mndem,mtdura,mdate,midusua,midactu,mhominis, mfraninst

mgenera = iif(mndem = 0, 1, 0)

if vartype(mhominis)#"N"
	mhominis = 0
endif

if vartype(mfraninst) = "N"
	If mfraninst = 1
		mgenera = 0 
		mndem = 0
	Endif	
Endif 


mret = sqlexec(mcon1,"Update Medpresta set Sala=?mcsala,demanda=?mndem,"   +;
	"generaagen=?mgenera,duracion=?mtdura,fhgraba=?mdate,usuario=?midusua" +;
	",reservados = ?mhominis "+;
	" where Id=?midactu")

If mret < 0
	Messagebox('AL ACTUALIZAR ATRIBUTOS DE PRESTACIONES'+chr(10)+;
		"AVISE A SISTEMAS", 16, 'ERROR')
	lsigue = .f.
Endif
