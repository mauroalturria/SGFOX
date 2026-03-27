****
** Busco Cuentas
****

Parameter mnroreg,mtipo,mifechacto,micode
mfec = SUBSTR(DTOS(mifechacto),3,6)
micto = IIF(mtipo = 'AMB',"17",'170')+Alltrim(Transf(micode, "@L 999"))
mret = SQLExec(mcon1, "select  PAC_codadmision "+;
	" FROM histambgua join pacientes on pacientes.pacientes =  histambgua.HIS_codadmision "+ ;
	" where  HIS_nroregistrac= ?mnroreg and PAC_fechaadmision= ?mifechacto " +;
	" and HIS_codentidad= ?micode and HIS_fechaadmision= ?mfec and HIS_codcontrato = ?micto  "+;
	"  ","mwkctasamb")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return ('')
Else
	Return (mwkctasamb.PAC_codadmision )
Endif
