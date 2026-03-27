Parameters mbusco1, mNomCur

If Vartype(mNomCur)# "C"
	mNomCur = "mwkpacamb"
Endif

mbusco1 = Upper(Iif(Vartype(mbusco1)#"C",'',mbusco1))

If !Empty(mbusco1) And Not ("WHERE" $ mbusco1)
	mbusco1 = "WHERE " + mbusco1
Endif


msql =  "select TabAutPrevias.APV_registracio,APV_protocolo  " + ;
	"from TabAutPrevias " + ;
	"inner join registracio on TabAutPrevias.APV_registracio = REGISTRACIO.REG_nroregistrac " + ;
	mbusco1 
mret = SQLExec(mcon1,msql,mNomCur)
If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	Return .F.
Endif
