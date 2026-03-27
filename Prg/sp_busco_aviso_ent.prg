*
* Busco avisos de entidades
*
Parameter mbusca, lbaja

mfechapas = Ctod("01/01/1900")
If Vartype(mbusca)<>"C"
	mbusca =''
Endif
If Type('lbaja') # "N"
	cbaja = ' and av_fechapasiva = ?mfechapas  and  '
Else
	cbaja = ' and '
Endif

mret = SQLExec(mcon1, "select TabAvisos.*,ENT_descrient,prestacions.PRE_descriprest,"+;
	" prestacions.PRE_codservicio, CON_descricont, CON_fecpasiva "+;
	" from TabAvisos,entidades "+;
	" left join prestacions on pre_codprest = AV_prestacion " +;
	" left outer join  Contratos ON  AV_codcont = Contratos.CON_codcont "+;
	" where Tabavisos.AV_codent = Entidades.ENT_codent and ENT_fecpas IS NULL "+ cbaja + mbusca +;
	"", "mwkTabAvisospre")

If mret < 0
	Messagebox("EN BUSQUEDA DE AVISOS PARA ENTIDADES",16,"ERROR")
	Do Log_errores With Error(),+ ;
		"cbaja " + prg_saco_chrSql(cbaja) + Chr(13) + ;
		"mbusca " + prg_saco_chrSql(mbusca) + Chr(13), ;
		Message(1), Program(), Lineno()
	Return .F.
Else
	Select * From mwkTabAvisospre WHERE ISNULL(CON_fecpasiva);
		order By AV_codent, AV_codcont ,AV_tipopaciente ,AV_fechapasiva ;
		INTO Cursor mwkTabAvisos

Endif

Return .T.
