****
** Busco admision para modificar datos
****

Parameter mnroadm,lsinvales
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = " and pac_sectorinternac  in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif
 
mret = SQLExec(mcon1, "select pacientes.*, COB_codentidad, COB_codcontrato,COB_fechafincob " + ;
	", Observa, TipoPac, Urgencia, TPV_Estado, FirmaConsentimiento,TabProtQuir.Observado,COB_CondicImpositiva,TabProtQuir.quirofano  "+;
	"from pacientes left join coberturas on " + ;
	" pacientes.PAC_codadmision = coberturas.COB_pacientes  " + ;
	" left join TabProtQuir on pacientes.PAC_codadmision= TabProtQuir.Codadmision"+;
	" left outer join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
	" where PAC_codadmision = ?mnroadm"+;
	mwcm, "mwkadmi")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Select * From mwkadmi Where COB_fechafincob Is Null Into Cursor mwkbuspaciev
***COB_fechafincob is null
If !lsinvales
	mret  = SQLExec(mcon1, "select VAL_fechasolicitud, VAL_horasolicitud "+;
		"from Valesasist where VAL_codadmision = ?mnroadm and VAL_codservvale<>1200 ","mwkctrval0")


	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Select Ctot(Dtoc(VAL_fechasolicitud)+" "+Strtran(VAL_horasolicitud,".",":")) As hora ;
		from mwkctrval0 Into Cursor mwkctrval

	Select Min(hora) As horades,Max(hora) As horahas From mwkctrval Into Cursor mwkctrvales
Endif
