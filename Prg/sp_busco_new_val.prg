****
** Busca si hay nuevos vales de Nutricion
****

do sp_busco_ultfechanut

fhlimite = nvl(mwkUfan.Fecha_UAct_Alim,dtot(ctod("01/01/1900")))
fechalimite =ttod(fhlimite )
horalimite =ttoc(fhlimite ,2)

mret =sqlexec(mcon1, "select VAL_codadmision"+;
	" from valesasist" + ;
	" where  VAL_fechasolicitud >= ?fechalimite and " + ;
	" VAL_horacargasolic > ?horalimite and VAL_codsector <> 'AMB' and VAL_codsector <> 'GUA' "+;
	" and VAL_codservvale = 9400 ", "mwktotval1")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DE CURSOR, AVISAR A SISTEMAS", 13,"Validacion")
endif