****
** grabo medico reemplazante
****
parameter mnombre , mcodesp , mmatricula , mtipoMat 

mtefecha = sp_busco_fecha_serv('DT')

mret = sqlexec(mcon1, "insert into TabMedExterno ( codesp , fechaIngreso , gerenciadora "+;
		", matricula , nombre , tipoMat , usuarpas) " + ;
		"values(?mcodesp , ?mtefecha , 0, ?mmatricula , ?mnombre , ?mtipoMat,'' )")
							
if mret < 0
	=AERR(EROS)
	messagebox(eros(3))
endif					