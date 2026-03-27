Lparameters tnfecdesde,tnfechasta,tcpaciente,tnnumeval
*!* ------------------ ASIGNACIÓN DE VALORES A VARIABLES -----------------------------------------------
LFECHOY = sp_busco_fecha_serv('DD')
mwhere = " "

If Vartype(tnfecdesde) # 'D'
	tnfecdesde = LFECHOY
Endif

If Vartype(tnfechasta) # 'D'
	tnfechasta = LFECHOY
Endif

If Vartype(tcpaciente) # 'C'
	tcpaciente= ""
Endif

If Vartype(tnnumeval) # 'N'
	tnnumeval = 0
Endif

*!* ------------------------------------------------------------------------------------------------------

*!* ------------------------  CREACIÓN DE LA RESTRICCIÓN DE LA CONSULTA ----------------------------------
If tnnumeval > 0
	mwhere = "TabAuditEval.id = ?tnnumeval"
Else
	If Empty(tcpaciente)
		mwhere = " tae_fechaeval >= ?tnfecdesde and tae_fechaeval <= ?tnfechasta"
	Else
		mwhere = " REG_nombrepac LIKE '&tcpaciente%' "
		mret = SQLExec(mcon1,"select PAC_codhci from pacientes "+;
			" inner join TabAuditEval on PAC_codadmision = tae_codadmision "+;
			" inner join REGISTRACIO  on pac_codhci 	 = REGISTRACIO.REG_nroregistrac"+;
			" where "+ mwhere +" group by PAC_codhci ","mwkbuscopaciente")

&&" inner join registracio on "
		If mret<1
			Do Log_errores With Error(), Message(), Message(1)
			Return .F.
		Endif

		If Reccount('mwkbuscopaciente')<= 0
			Messagebox("PACIENTE INEXISTENTE",48,"VALIDACIÓN")
			Return .F.
		Endif
		If Reccount("mwkbuscopaciente") = 1
			lncodhci = mwkbuscopaciente.PAC_codhci
			mwhere   = "PAC_codhci =?lncodhci"
		Else
			Select mwkbuscopaciente
			Scan All
				lncodhci = mwkbuscopaciente.PAC_codhci
				mwhere   = "PAC_codhci in (" + lncodhci
			Endscan
			mwhere = mwhere + ")"
		Endif
	Endif
Endif

*!* -------------------------------------------------------------------------------------------------------

*!* --------------------- REALIZACIÓN DE LA CONSULTA ------------------------------------------------------
mret   = SQLExec(mcon1,"select TabAuditEval.*,TabAuditDemoIC.*,TabAuditDemoras.*,"+;
	" TabAuditDetalle.*,TabAuditHis.*,TabAuditIACRel.*,"+;
	" tai_descripcion,TabAuditIACRel.id as num,nomape,pac_nombrepaciente as nombrepac, "+;
	" pre_descriprest,PAC_codhci,tabestados.descrip as estadoeval "+;
	" from TabAuditEval "+;
	" inner join tabusuario      on codigovax            = tae_codigovax "+;
	" left  join TabAuditDemoIC  on tadi_idTabAuditEval  = TabAuditEval.id "+;
	" inner join pacientes       on PAC_codadmision 	 = tae_codadmision " +;
	" inner join TabAuditDemoras on taud_idTabAuditEval  = TabAuditEval.id "+;
	" inner join TabAuditDetalle on tad_idTabAuditEval   = TabAuditEval.id "+;
	" inner join TabAuditHis     on tah_idTabAuditEval   = TabAuditEval.id "+;
	" inner join tabestados		 on tae_estado = tabestados.estado and propietario=15 and tipo=8"+;
	" left  join TabAuditIACRel  on tair_idTabAuditEval  = TabAuditEval.id "+;
	" left  join TabAuditIACS    on TabAuditIACS.id      = tair_idTabAuditIACS "+;
	" LEFT  join PRESTACIONS     on pre_codprest         = TabAuditDemoIC.tadi_codprest "+;
	" where tabestados.descrip = 'FINALIZADA' AND "+ mwhere+;
	" order by TabAuditEval.tae_fechaeval asc","mwkevaluaciones")

If mret < 1
*!*	=AERROR(eros)
*!*	MESSAGEBOX(eros(3))
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
ENDIF
*!*-----------------------------------------------------------------------------------------------------------
*!* -------------- ANÁLISIS DEL RESULTADO OBTENIDO EN LA CONSULTA --------------------------------------------
If Reccount('mwkevaluaciones') <= 0
	Use In mwkevaluaciones
	Messagebox("NO EXISTE EVALUACIONES",64,"SISTEMAS")
	Return .F.
Endif
*!* ------------ CURSOR QUE UTILIZA EL FORMULARIO PARA MOSTRAR LOS DATOS ------------------------------------
Select Count(Distinct(Id)) As cantidad,* From mwkevaluaciones;
	group By Id;
	order By Id Asc;
	into Cursor mwkevaluaciones1
*!* ----------------------------------------------------------------------------------------------------------
If Used('mwkbuscopaciente')
	Use In mwkbuscopaciente
Endif
If Used('mwkevaluaciones')
	Use In mwkevaluaciones
Endif

*!* ----------------------- FIN DE CÓDIGO --------------------------------------------------------------------