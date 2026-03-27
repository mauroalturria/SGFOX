Parameters olevism, madmision, mfechahora, mserv, msolic, mcod, mcanti, murg, mcoment, moper, mvale

Do sp_busco_estados With 7,' and tipo = 26 ','mwkHabSecICm'
Do sp_busco_estados With 7,' and tipo = 25 ','mwkHabMailIC'

*Do sp_busco_estados With 57,' and tipo = 19 ','mwkExcepcion'

If mwkHabMailIC.estado <> 1
	Return .T.
Endif
mantolevism = olevism
With mantolevism
	.mserver   = ''
	.namespace = ''
Endwith
*!*--111----------------------------------------------------------------------------------------------------------------------------
TEXT To lcsql Textmerge Noshow Pretext 7
	select Pac_SectorInternac, Pac_Nombrepaciente, PAC_habitacion, PAC_cama
	from Pacientes
	where Pac_CodAdmision = ?madmision
ENDTEXT

If !Prg_EjecutoSql(lcSql,"mwkPacGA")
	Return .F.
Endif
*---- Modificado 2020/07
*!*	Select mwkHabSecICm
*!*	Locate For Alltrim(mwkPacGA.Pac_SectorInternac) $ Alltrim(Nvl(mwkHabSecICm.Descrip,'')) And mwkHabSecICm.estado = 1
*!*	If !Found()
*!*		Return .T.
*!*	Endif
Select mwkHabSecICm
mSecIntValidos = ''
Scan All
	mSecIntValidos = mSecIntValidos + Alltrim(mwkHabSecICm.Descrip)
Endscan
mSecIntValidos = Left(mSecIntValidos,Len(mSecIntValidos)-1)
Locate For Alltrim(mwkPacGA.Pac_SectorInternac) $ Alltrim(Nvl(mSecIntValidos,''))
If !Found()
	Return .T.
Endif
*!*------------------------------------------------------------------------------------------------------------------------------

TEXT To lcsql Textmerge Noshow Pretext 7
	Select pre_especialidad From Prestacions Where pre_codprest = ?mcod
ENDTEXT

If !Prg_EjecutoSql(lcSql,"mwkEspe")
	Return .F.
Endif

*!*------------------------------------------------------------------------------------------------------------------------------

MESPE = Alltrim(mwkEspe.pre_especialidad)

Use In Select("mwkEspe")

TEXT To lcsql Textmerge Noshow Pretext 7
	select TabGuaAct.*, Prestadores.emailcorp, Prestadores.email
	from TabGuaAct
	inner join Prestadores on TabGuaAct.TGA_CodMed = Prestadores.ID
	where TGA_CodEsp = ?MESPE  AND GETDATE() BETWEEN TGA_FECHORINI AND TGA_FECHOFIN
ENDTEXT

If !Prg_EjecutoSql(lcSql,"mwkProfGA")
	Return .F.
Endif

*!*	If Reccount("mwkProfGA") = 0
*!*		Return .t.
*!*	Endif

*!*------------------------------------------------------------------------------------------------------------------------------
TEXT To lcsql Textmerge Noshow Pretext 7
	Select nombre From Prestadores Where id  = ?msolic
ENDTEXT

If !Prg_EjecutoSql(lcSql,"mwkMedGA")
	Return .F.
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
TEXT To lcsql Textmerge Noshow Pretext 7
	select *
	from PRESTACIONS
	where Pre_CodPrest = ?mcod
ENDTEXT

If !Prg_EjecutoSql(lcSql,"mwkPreGA")
	Return .F.
Endif

*!*------------------------------------------------------------------------------------------------------------------------------

*
* Entidad y Nro de afiliado
mEntidadPac =  ''
mNroAfiliado = ''
lcSql = "SELECT pacientes.PAC_codhci, afiliacion.AFI_codentidad,afiliacion.AFI_nroafiliado,"+;
	"entidades.ENT_codent,entidades.ENT_descrient,"+;
	"pacinternad.PIN_codadmision,pacinternad.PIN_codentidad "+;
	"from  PACINTERNAD "+;
	"inner join entidades on PACINTERNAD.PIN_codentidad = entidades.ENT_codent "+;
	"inner join pacientes on pacinternad.PIN_codadmision = pacientes.PAC_codadmision "+;
	"inner join afiliacion on pacientes.PAC_codhci = afiliacion.REGISTRACIO "+;
	"where PIN_codadmision = ?mAdmision and PIN_CODENTIDAD = AFI_CODENTIDAD "
mret = SQLExec(mcon1,lcSql,'mwkEntiPacPi')
If mret<0
	Messagebox('No se pudo encontrar la Entidad del paciente',48,'Aviso')
Endif
If Used('mwkEntiPacPi')
	Select mwkEntiPacPi
	mEntidadPac = Nvl(mwkEntiPacPi.ENT_descrient,"")
	mNroAfiliado = Nvl(mwkEntiPacPi.AFI_nroafiliado,"")
Endif
* --------------

lcSep = Chr(10) + Chr(13)
masunto = "NUEVA INTERCONSULTA"
memobeep = masunto + lcSep
memobeep = memobeep + "Paciente : " + Alltrim(mwkPacGA.Pac_Nombrepaciente) + lcSep
memobeep = memobeep + "Ubicación: Sec." + Alltrim(mwkPacGA.Pac_SectorInternac) + " - Hab." + Alltrim(mwkPacGA.PAC_habitacion) + " - Cama." + Alltrim(mwkPacGA.PAC_cama)+ lcSep
memobeep = Strtran(memobeep,lcSep," ")

* =ENVIOBEEP(olevism, MESPE, memobeep, "")
*!*------------------------------------------------------------------------------------------------------------------------------
lcSep = "<br>"
memomail = ""
memomail = memomail + "Admisión : " + madmision + lcSep
memomail = memomail + "Paciente : " + Alltrim(mwkPacGA.Pac_Nombrepaciente) + lcSep
memomail = memomail + "Entidad : " + Alltrim(mEntidadPac) + lcSep
memomail = memomail + "Nro Afiliado : " + Alltrim(mNroAfiliado) + lcSep
memomail = memomail + "Ubicación : Sec.: " + Alltrim(mwkPacGA.Pac_SectorInternac) + " - Hab.: " + Alltrim(mwkPacGA.PAC_habitacion) + " - Cama." + Alltrim(mwkPacGA.PAC_cama)+ lcSep
memomail = memomail + "Urgente : "  + Iif(Alltrim(Transform(murg)) = "1","SI","NO") + lcSep
memomail = memomail + "Nro. Vale : "  + Transform(mvale) + lcSep
memomail = memomail + "Fecha Hora : "  + Ttoc(mfechahora) + lcSep
memomail = memomail + "Consulta : "  + Alltrim(mwkPreGA.Pre_Descriprest) + lcSep
memomail = memomail + "Solicitado por : "  + Alltrim(mwkMedGA.nombre) + lcSep
If !Empty(Nvl(mcoment,''))
	memomail = memomail + "Observación : "  + Alltrim(mcoment) + lcSep
Endif
*!*------------------------------------------------------------------------------------------------------------------------------


* 2023-10-19 Se quita llamado a envío de beepers
* =ENVIOBEEP(olevism, MESPE, memobeep, "") 
* --------------------------------------------------------------------------------------------------------------------------------------------

*olevism = Createobject("VISM.VisMCtrl.1")

Select mwkProfGA

Scan All  && For !Empty(Nvl(emailcorp,''))

	mrecibe = Iif(Empty(Alltrim(Nvl(mwkProfGA.emailcorp,''))), Alltrim(Nvl(mwkProfGA.email,'')), Alltrim(Nvl(mwkProfGA.emailcorp,'')))
	If Alltrim(mwkusuario.sector) = "SISTEMAS"
		mrecibe = "calvarez@sg.com.ar" && mwkProfGA.alltrim(emailcorp)
	Endif

	If !Empty(Alltrim(Nvl(mrecibe,'')))

* Se debe enviar por CDO y no por Caché
* Modificado el 2021/08 a pedido de Rdodrigo.


* 2023-10-19 Se quita envío de mensajería de IC a personal de dirección
		lenviamsg = .t.
		If  Inlist(mwkProfGA.TGA_CodMed,1690,403,4827,2675)
		lenviamsg = .f.
		Endif
		
		If lenviamsg
			Do prg_interconsulta_mails With mrecibe,masunto,memomail
		Endif
		

*!*			olevism.mserver   = Allt(mwktabcfg.OLEServer) && 'CN_IPTCP:172.16.1.4[1972]'
*!*			olevism.namespace = Allt(mwktabcfg.olespaces) && 'CATALOGO'

*!*	*       ** -RLV (Rodrigo) 27/10/2016: Reemplazo linea subsiguiente (comentada) por la sig, por error alltrim e incorp. de email personal:
*!*	*	mrecibe = mwkProfGA.Alltrim(emailcorp)
*!*	*	mrecibe = "gfittipaldi@silver-cross.com.ar" && mwkProfGA.alltrim(emailcorp)

*!*			olevism.Code = "D SEND^%ZMAIL("+ '"'+mrecibe+'"' +',"'+ masunto + '","' + memomail+ '","","" )'
*!*			olevism.execflag = 1
*!*			mok	= olevism.p0
*!*			mrespcose1 = olevism.p2

*!*			olevism.execflag  = 1
*!*			olevism.mserver   = ''
*!*			olevism.namespace = ''

*!*			prg_olevism_reset(olevism)

	Endif

	Select mwkProfGA
Endscan

Use In Select("mwkProfGA")
Use In Select("mwkPacGA")
Use In Select("mwkPreGA")
Use In Select("mwkMedGA")

Use In Select("mwkHabSecICm")
Use In Select("mwkHabMailIC")
With mantolevism
	.mserver   = Allt(mwktabcfg.OLEServer) && 'CN_IPTCP:172.16.1.4[1972]'
	.namespace = Allt(mwktabcfg.olespaces) && 'CATALOGO'
Endwith

*!*	-------------------------------------------------------------------------------
Function ENVIOBEEP
Parameters olevism, MESPE, mMENSAJE, mREMITENTE
*!*	-------------------------------------------------------------------------------


*olevism = Createobject("VISM.VisMCtrl.1")
olevism.mserver   = Allt(mwktabcfg.OLEServer) && 'CN_IPTCP:172.16.1.4[1972]'
olevism.namespace = Allt(mwktabcfg.olespaces) && 'CATALOGO'
olevism.Code = "D GETIDGRUDEST^GGUAALERT(" + '"' + MESPE + '"' + ")"
olevism.execflag = 1

mp0 = olevism.p0

olevism.mserver   = ''
olevism.namespace = ''
=prg_olevism_reset(olevism)

If Empty( mp0 )
	Return .F.
Endif

mIDGRUPODEST = mp0

*olevism = Createobject("VISM.VisMCtrl.1")
If mIDGRUPODEST = "12" && Envío mail para Psicopatología formato completo (pedido del Dr. Castellucci 2020/09)

* Busco IC Psico y envío Mail
	mfechahabilitada = Ctod('01/01/1900')
* Grupo psico = 12 en real
	lcSql = 'select * from TabMsgGTV where TMV_fecha = ?mfechahabilitada and TMV_idgrupo = 12 and tmv_idserv = 1'
	mret = SQLExec(mcon1,lcSql,'mwkGrupo')
	If mret<0
		Messagebox('Error de Conexión',48,'Aviso')
		Return .F.
	Endif
	If !Reccount('mwkGrupo')>0
		Messagebox('No hay grupo definido de destinatarios.',48,'Aviso')
		Return .F.
	Endif
	Select mwkGrupo
	Scan All
		mDestino = Int(Val(mwkGrupo.tmv_valor))
		lcSql = 'select * from Tabusuario where id = ?mDestino'
		SQLExec(mcon1,lcSql,'mwkDestino')
		If Used('mwkDestino')
			If Reccount('mwkDestino')>0
				Select mwkDestino
				mrecibe = Alltrim(mwkDestino.email)
* Se debe enviar por CDO y no por Caché
* Modificado el 2021/08 a pedido de Rdodrigo.
				Do prg_interconsulta_mails With mrecibe,masunto,memomail
*!*				olevism.mserver   = Allt(mwktabcfg.OLEServer)
*!*				olevism.namespace = Allt(mwktabcfg.olespaces)
*!*				olevism.Code = "D SEND^%ZMAIL("+ '"'+mrecibe+'"' +',"'+ masunto + '","' + memomail+ '","","" )'
*!*				olevism.execflag = 1
*!*				mok = olevism.p0
*!*				mrespcose1 = olevism.p2
*!*				olevism.mserver   = ''
*!*				olevism.namespace = ''
*!*				prg_olevism_reset(olevism)

			Endif
		Endif
		Select mwkGrupo
	Endscan
Else
	olevism.mserver   = Allt(mwktabcfg.OLEServer) && 'CN_IPTCP:172.16.1.4[1972]'
	olevism.namespace = Allt(mwktabcfg.olespaces) && 'CATALOGO'
	olevism.Code = "D ENVIARMENS^DESPMENS(" + '"' + mMENSAJE + '" , "' + Transform(mIDGRUPODEST) + '" , "' + mREMITENTE +'")'
	olevism.execflag = 1
	mp0 = olevism.p0
	olevism.mserver   = ''
	olevism.namespace = ''
	=prg_olevism_reset(olevism)

	If mp0 <> ''
		mcoderr = Val(mp0)
		Do sp_busco_texto_error With mcoderr
		Messagebox(Transform(mp0) + " - " + Alltrim(mwktaberror.textoerror), 48, 'VALIDACION')
		Return .F.
	Endif

Endif


