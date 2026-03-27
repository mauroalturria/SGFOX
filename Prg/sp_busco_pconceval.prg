****
** Busco Conceptos Valorizados
****
lparameters mbusco
if type ('mbusco')#"C"
	mbusco=""
ENDIF
mfpasiva = ctot("01/01/1900")
*mbusco = IIF(EMPTY(mbusco),"where fechapas = ?mfpasiva", mbusco +  " and  fechapass = ?mfpasiva ")
mret = sqlexec(mcon1, "SELECT ID,DescripExce,ValorExcede FROM TabPExcedente "+;
		mbusco , "mwkconceval")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif