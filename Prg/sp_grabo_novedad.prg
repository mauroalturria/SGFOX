**********
*	Libro de Pase de Guardia
**********
Parameters mFecha, mcodmed, mtipo, mdetalle

jj = int(len(alltrim(mdetalle))/250)
for i = 0 to jj
	clin = "linea"+padl(i,3,"0")
	public &clin 
next
mnove = prg_concat(alltrim(mdetalle))

mret = sqlexec(mcon1, "insert into TabGuaNov ( NOV_Fecha, NOV_CodMed , NOV_Tipo, NOV_Detalle ) "+;
		" values(?mFecha , ?mcodmed , ?mtipo, " + mnove + ")")
							
for i = 0 to jj
	clin = "linea"+padl(i,3,"0")
	release &clin 
next

if mret < 0
	messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'VALIDACION')
endif					