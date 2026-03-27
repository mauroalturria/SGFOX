*!*	------------------------------------------------------------
*!*	CONCENTRAMOS TODOS LOS MSG DE ERROR -> SQLEXEC
*!*	Y DECIDIMOS QUE HACER DEACUERDO AL EXE
*!*	Do prg_error_sql With "NO PUDO ACTUALIZAR CURSOR"
*!*	------------------------------------------------------------
Parameters tcmsg, tnIcon, tcTitle

If Vartype(tcmsg) <> "C"
	tcmsg = ""
Endif 
If Vartype(tnIcon) <> "N"
	tnIcon = 48
Endif 
If Vartype(tcTitle) <> "C"
	tcTitle = "VALIDACION"
Endif 

#DEFINE LF_CR CHR(10)+CHR(13)

If Aerror(eros)> 0
	tcmsg = tcmsg + LF_CR + "Programa : " + Transform(Program(1)) + LF_CR
	tcmsg = tcmsg + "Error Nro : " + Transform(eros(1)) + LF_CR
	tcmsg = tcmsg + "Detalle : " + Alltrim(Transform(eros(2))) + LF_CR
Endif 

Do Case
	Case mwkexe.nomexe = "LLAMADOR"
		do prg_error_llamador With tcmsg 

	Otherwise 
		Messagebox(tcmsg, tnIcon, tcTitle)
Endcase

 
 