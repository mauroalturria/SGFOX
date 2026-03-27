*!*	-----------------------------------------------
*!*	busco pacientes para nutricion
*!*	-----------------------------------------------
Parameter mProto, nserv, ltodos, mfecdia

*!*	mProto = '1029141-11 '
*!*	nserv  = 1

Local cbaja, mfechanull

cbaja = ''
mfechanull = "1900-01-01 00:00:00"

*!*	-----------------------------------------------
If Type ('ltodos') # "N"
	ltodos = 0
Endif

If ltodos = 0
	cbaja = " and tnd_fecbaja = ?mfechanull "
Endif

If Type ('mfecdia') # "D"
	mfecdia = sp_busco_fecha_serv('DD')
Endif

*!*	-----------------------------------------------
mret = SQLExec(mcon1, "Select pre_codprest, PRE_descriprest " + ;
	"from prestacions " + ;
	"where pre_codservicio = 9400 and PRE_fechapasiva is null ", "mwkpres")

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
*!*	-----------------------------------------------
*!*	Nutricion
*!*	-----------------------------------------------
*!*		"PAC_descripdiagn, PAC_fechaadmision, pin_codentidad, " + ;
*!*		"PAC_edad, PAC_codadmision, PAC_fecnacimiento, " + ;
	
mret = SQLExec(mcon1, "Select Guardia.Id as IdGuardia, Registracio.REG_nombrepac, " + ;
	"TabNutPacAmb.*, " + ;
	"TabNutDetAmb.*, " + ;
	"TabNutPrest.TNP_codfactu, TabNutPrest.TNP_factura, TabNutPrest.TNP_dieta " + ;
	"from Guardia " + ;
	"Inner Join Registracio on Guardia.nroregistrac = Registracio.REG_nroregistrac " + ;
	"left join TabNutPacAmb on Guardia.Protocolo = TabNutPacAmb.TNP_protocolo " + ;
	"left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id and tnd_fecbaja = ?mfechanull " + ;
	"left join TabNutPrest on TabNutPrest.TNP_codPrest = TabNutDetAmb.TND_codPrest " + ;
	"where Guardia.protocolo = ?mProto and TNP_Fecha = ?mfecdia " + cbaja , "mwknutcam1")

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
*!*	-----------------------------------------------
*!*	FIN DE CONSULTAS AL SERVIDOR
*!*	-----------------------------------------------

Select TNP_protocolo, Nvl(TNP_Fecha,mfecdia) As TNP_Fecha, Nvl(TNP_CodServ,0) As TNP_CodServ, ;
	Nvl(TNP_CodFact,'') As TNP_CodFact,Nvl(TNP_Observaciones,'') As TNP_Observaciones, ;
	Nvl(TNP_Usuario, 0) As TNP_Usuario,Nvl(TND_observa,Space(50)) As TND_observa, ;
	TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, TND_cantidad, pre_descriprest, ;
	TNP_factura, TNP_codfactu, TNP_dieta, tnd_fecbaja, Nvl(TND_Usuario, 00000) As TND_Usuario ;
	From mwknutcam1 ;
	Left Join mwkpres On TND_codPrest = pre_codprest ;
	Order By TNP_Fecha, TNP_protocolo, TNP_CodServ, TND_NroVale ;
	Into Cursor mwknutcd1
