***
***  busqueda de las entidades
***
Parameter mafiliado,losactivos

If Vartype(losactivos)#"N"
	losactivos = ''
Else
	losactivos= " and AFI_fechabaja is null "
Endif
If Used('mwkbentid')
	Select mwkbentid
	Use
Endif

If mxambito >1
	If !Used('mwktabambito')
		mret = SQLExec(mcon1,"select * from TabAmbito", "mwktabambito")
	Endif
	Select mwktabambito
	Locate For Id = mxambito
	mccpoamb = " and ENT_codagrup  IN ("+Alltrim(mwktabambito.tipoent)+") "
Else
	mccpoamb = ''
Endif

mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient , ENT_fecpas, "+;
	"ENT_capita, ENT_tipo,ENT_nroprestadorexterno ,ENT_codagrup    " + ;
	"from entidades " + ;
	"where ENT_codent in (select AFI_codentidad from afiliacion " + ;
	"where registracio = ?mafiliado &losactivos) "+mccpoamb ,"mwkbentid")

**and AFI_fechabaja is null

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Endif
