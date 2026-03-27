****
* Solicitud de Cambio de Cama
*****
Parameters mopcion,mxorigen,mxestado, mxcodmed,mxcodcie,mxobs,mxhclin,mxadmis ,mxsecagr ,mxservicio,mxproto
* MOPCION 1-ALTA-2 MODIFICACION
*morigen 1- guardia 2-pisos

mdtF    = sp_busco_fecha_serv('DT')
mfecnul = Ctod("01/01/1900")
musu = Iif(Used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
midusu = Iif(Used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)
Do Case
Case mopcion=1 && alta
	If mxorigen = 2 && internados
		TEXT To lcsql Textmerge Noshow Pretext 7
			SELECT id,SC_Admision , SC_Estado , SC_fechaSol , SC_Observa , SC_Protocolo ,
				 SC_SecAgrup ,SC_SecOrigen , SC_Servicio from ZabIntSolCama inner join pacientes  on SC_Admision = pac_codadmision
				where (pac_codhce = ?mxhclin or SC_Admision = ?mxadmis)
				and SC_estado = 1
		ENDTEXT
		=Prg_EjecutoSql(lcSql,"mwkctrlsolserv")
		If Reccount("mwkctrlsolserv")>0
			Select mwkctrlsolserv
			Scan
				mid = mwkctrlsolserv.Id
				mret = SQLExec(mcon1, "update ZabIntSolCama set SC_estado = 3 where id=?mid ")
			Endscan
		Endif
		Select mwkpacint1
		mxadmis	= pac_codadmision
		mxsec 	= sec_codsector
	Else &&Guardia
		TEXT To lcsql Textmerge Noshow Pretext 7
			SELECT id,SC_Admision , SC_Estado , SC_fechaSol , SC_Observa , SC_Protocolo ,
				 SC_SecAgrup ,SC_SecOrigen , SC_Servicio from ZabIntSolCama
				where   SC_Admision = ?mxadmis
				and SC_estado = 1
		ENDTEXT
		=Prg_EjecutoSql(lcSql,"mwkctrlsolserv")
		If Reccount("mwkctrlsolserv")>0
			Select mwkctrlsolserv
			Scan
				mid = mwkctrlsolserv.Id
				mret = SQLExec(mcon1, "update ZabIntSolCama set SC_estado = 3 where id=?mid ")
			Endscan
		Endif
		mxsec 	= 'GUA'
	Endif
	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabIntSolCama
		( SC_Admision ,SC_CodMed , SC_Codcie10 , SC_Estado , SC_fechaSol , SC_Observa , SC_Protocolo ,
		 SC_SecAgrup ,SC_SecOrigen , SC_Servicio  )
		 Values
		( ?mxadmis, ?mxcodmed, ?mxcodcie, ?mxestado, ?mdtF ,?mxobs, ?mxproto, ?mxsecagr , ?mxsec , ?mxservicio)
	ENDTEXT
	If !Prg_EjecutoSql(lcSql,"mwk")
		Messagebox("ERROR AL GUARDAR",16,"ERROR")
		Return .F.
	Endif
Case mopcion=2 && cambia estado
	If mxorigen = 2 && internados
		TEXT To lcsql Textmerge Noshow Pretext 7
			SELECT id,SC_Admision , SC_Estado , SC_fechaSol , SC_Observa , SC_Protocolo ,
				 SC_SecAgrup ,SC_SecOrigen , SC_Servicio from ZabIntSolCama inner join pacientes  on SC_Admision = pac_codadmision
				where (pac_codhce = ?mxhclin or SC_Admision = ?mxadmis)
				and SC_estado = 1
		ENDTEXT
		=Prg_EjecutoSql(lcSql,"mwkctrlsolserv")
		If Reccount("mwkctrlsolserv")>0
			Select mwkctrlsolserv
			Scan
				mid = mwkctrlsolserv.Id
				mret = SQLExec(mcon1, "update ZabIntSolCama set SC_estado = ?mxestado where id=?mid ")
			Endscan
		Endif

	Endif
Endcase
