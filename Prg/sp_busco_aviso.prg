*
* Busco avisos de entidades
*
Parameter mbusca, lbaja,lsinprest

mfechapas = Ctod("01/01/1900")
If Vartype(lsinprest)<>"N"
	lsinprest = 0
Endif
If Type('lbaja') # "N"
	cbaja = " av_fechapasiva = '1900-01-01' and "
Else
	cbaja = ' '
Endif
mbusca = STRTRAN(mbusca ,'(0,)','(0)')
mret = SQLExec(mcon1, "select TabAvisos.*, prestacions.PRE_descriprest as lpresta from TabAvisos "+;
	"left join prestacions on pre_codprest = AV_prestacion " +;
	"where    "+ cbaja + mbusca +;
	"", "mwkTabAvisospre")

If mret < 0
	Messagebox("EN BUSQUEDA DE AVISOS PARA ENTIDADES",16,"ERROR")
	Do Log_errores With Error(),+ ;
		"cbaja " + prg_saco_chrSql(cbaja) + Chr(13) + ;
		"mbusca " + prg_saco_chrSql(mbusca) + Chr(13), ;
		Message(1), Program(), Lineno()
	Return .F.
ELSE 
SELECT * FROM mwkTabAvisospre;
 order by AV_codent, AV_codcont ,AV_tipopaciente ,AV_fechapasiva ;
 INTO cursor mwkTabAvisos
 
Endif

Return .T.
