Parameters toForm, tnRegi, tnCodHab, tnCodCam, tcCodSec, tcCodAdm, tnCodMed, tcNomMed, tcCurDatMa,;
tnCodEnt,tcHCE

mcodusu		= Alltrim(Str(mwkusuario.codigovax,6,0))
midusua     = mwkusuario_sec.idusuario && mwkusuario.idusuario
mfechaHora  = sp_busco_fecha_serv('DT') && FechaHora
mfecha      = Ttod(mfechaHora ) && Fecha

mhabita = Transform(tnCodHab)
mcama = Transform(tnCodCam)
mcodadm = ''

Local lbResu
lbResu = .F.

With toForm

	mgraba	    = '1'
	mfecadm		= Dtoc(mfecha) && Fecha de Admisión
	mhoradm		= Left(Ttoc(mfechaHora,2),5) && Hora de Admisión
	mnrohci     = Transform(tnRegi)

	mcodent		= Alltrim(Str(&tcCurDatMa..cob_codentidad)) && Código de Entidad

&& paso a fuera de padron
	If mcodent = "948"
		mcodent = "945"
	Endif
	If mcodent = "100"
		mcodent = "101"
	Endif
	If mcodent = "80"
		mcodent = "66"
	Endif
	Do sp_busco_contratos_int With mcodent
	mcontra		= Alltrim(Str(mwkcontratos.contrato)) && Contrato

	mcoddia		= '33222' && Código DX (Cie9) = allt(str(.cbocie9.value))
	mdiagno		= 'NACIDO VIVO NEOM' && Alltrim(mwkquiro2.Diagnostico) && Diagnóstico

	mcodmed		= ''
	mnommed		= ''

	If tnCodMed > 0 And tnCodMed < 10000
		mcodmed		= Alltrim(Str(tnCodMed)) && Médico Interno/Externo
	Else
		If tnCodMed > 0
			Do sp_busco_medico_dat With tnCodMed  && mwkbusmed
			mnommed = Alltrim(Nvl(mwkbusmed.nombre,''))
			mcodmed = "306"
			Use In Select("mwkbusmed")
		Else
			mnommed	= Alltrim(tcNomMed) && Nombre del Médico
		Endif
	Endif

	mcodint		= '1' && Motivo de Internación (4 = Obstetricia) = allt(str(mwkmotivoint.mti_codmotivo))
	mareain		= '15' && Alltrim(Str(mwkquiro2.servicio)) && Area de Internación (TabSectorInt) = 10 es Internación General
	mcodsec		= tcCodSec && IIF(mwkquirornadm.rna_deriva = 1,'NUR','NNT') && Código de Sector
*!*	-------------------------------------------------------------------------------------------------------------
	mcatego		= 'C' && Categoria = .abc.mcatego
*!*		murgpro		= Origen = iif(.optselec.value = 1 , 'G', iif(.optselec.value = 2 , 'P',  + ;
*!*	iif(.optselec.value = 3 , 'D', iif(.optselec.value = 4 , 'U', 'E'))))
	murgpro		= 'P'
	mhllego		= Left(Ttoc(mfechaHora, 2),5) && Llegada al Sanatorio
	mnacion		= 'ARGENTINA' && Nacionalidad
	mocupa		= '' && Ocupación
	mecivil		= '' && Estado Civil
	mrespon		= Alltrim(&tcCurDatMa..pac_nombrepaciente) && Responsable
	mtelres		= Nvl(&tcCurDatMa..pac_telefresponsab,'') && Teléfono = Allt(.txttele.Value)
	mdomici		= Allt(&tcCurDatMa..pac_domicilio) && Domicilio = Strtran(Allt(.txtdomi.Value),'"', ' ')
	mordint		= 'N' && Orden Médica = Iif(.chk1.Value = 0, 'N', 'S')
	mdenpol		= '0' && Denuncia Policial = str(.abc.mdenpol, 1)
	mfotrh		= 'N' && Recibo Sueldo
	mfotdni		= 'N' && DNI
	mfotcos		= 'N' && Carnet Afiliado
	mobser		= '' && Observación
	mnropro		= '' && Alltrim(Str(mwkquiro2.nroprotocolo)) && Protocolo VER PARA QUE ES ESTO

	Do While .T.
		.olevism.mserver = ''

		.olevism.mserver	= Allt(mwktabcfg.OLEServer)
		.olevism.namespace	= Allt(mwktabcfg.olespaces)
**
**   ADMINT(GRABA, FECADM, HORADM, HCI, ENT, CON, DIAG, OBSDIAG, SOLIC, NOMSOLIC, MOT,
**         AREAINT, SEC, HAB, CAMA, CATEG, URGPRO, HORLLEG, NAC, OCUP, CIV, RESPON, TELRESP,
**         DOMRESP, ORDINT, DENUNC, FOTRH, FOTDNI, FOTCOS, COMENT, PROTOR)
**
		.olevism.Code = "D ADMINT^RTN005("  + mgraba  + ',"'  + mfecadm + '","' + mhoradm + '",'  + ;
		mnrohci + ','   + mcodent + ','  + mcontra + ','  + mcoddia + ',"' + ;
		mdiagno + '",'  + mcodmed + ',"'  + mnommed + '",'  + mcodint + ','   + ;
		mareain + ',"'  + mcodsec + '","' + mhabita + '","' + mcama   + '","' + ;
		mcatego + '","' + murgpro + '","' + mhllego + '","' + mnacion + '","' + ;
		mocupa  + '","' + mecivil + '","' + mrespon + '","' + mtelres + '","' + ;
		mdomici + '","' + mordint + '","' + mdenpol + '","' + mfotrh  + '","' + ;
		mfotdni + '","' + mfotcos + '","' + mobser  + '","' + mnropro + '","' + ;
		mcodadm + '",' + mcodusu + ')'

		.olevism.execflag = 1
		mmsgerr = .olevism.errorname
		If !Empty(mmsgerr)
			Do sp_insert_tabCtrlErr With .olevism.Code, mmsgerr , midusua, .Name
			Messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')

***************  LIBERO LA CAMA
			maccion = 'L'
			mnroad  = ''
			ltodook = .F.
			.olevism.Code = "D ACTCAMA^RTN005(" + mgraba + ',"'  + mcodsec + '","'+ ;
			mhabita + '","' + mcama  + '","' + mcatego + '","' + ;
			maccion + '","' + mnroad + '",' + mcodusu + ')'

			.olevism.execflag = 1
			mmsgerr = .olevism.errorname
			If !Empty(mmsgerr)
				Select mwkusuario
				Go Top
				midusua     = mwkusuario.idusuario
				Do sp_insert_tabCtrlErr With .olevism.Code, mmsgerr , midusua, .Name
			Else
				mok		= .olevism.p0		&& Codigo de error
				If .olevism.p0 <> ''
					mcoderr = Round(Val(.olevism.p0), 0)
					Do sp_busco_texto_error With mcoderr
					Messagebox(Alltrim(mwktaberror.textoerror), 48, 'Validacion')
					Messagebox('NO SE PUDO LIBERAR LA CAMA', 64,'Validacion')
				Else
					Messagebox('CAMA LIBERADA POR ERROR AL ADMITIR AL PACIENTE', 64,'Validacion')
				Endif
			Endif
			Exit
		Endif

		merror	= .olevism.errorname

		If !Empty(merror)
			mret = SQLExec(mcon1, "insert into tabdioerror values(?merror, ?mnrohci)")
			Messagebox("Por Favor tome nota de este mensaje de error " + Chr(13) + ;
			allt(merror) + Chr(13) + ;
			"Avise a Sistemas, Gracias", 48,"Validacion")
***************  LIBERO LA CAMA
			maccion = 'L'
			mnroad  = ''
			ltodook = .F.
			.olevism.Code = "D ACTCAMA^RTN005(" + mgraba + ',"'  + mcodsec + '","'+ ;
			mhabita + '","' + mcama  + '","' + mcatego + '","' + ;
			maccion + '","' + mnroad + '",' + mcodusu + ')'

			.olevism.execflag = 1
			mmsgerr = .olevism.errorname
			If !Empty(mmsgerr)
				Select mwkusuario
				Go Top
				midusua     = mwkusuario.idusuario
				Do sp_insert_tabCtrlErr With .olevism.Code, mmsgerr , midusua, .Name
			Else
				mok		= .olevism.p0		&& Codigo de error
				If .olevism.p0 <> ''
					mcoderr = Round(Val(.olevism.p0), 0)
					Do sp_busco_texto_error With mcoderr
					Messagebox(Alltrim(mwktaberror.textoerror), 48, 'Validacion')
					Messagebox('NO SE PUDO LIBERAR LA CAMA', 64,'Validacion')
				Else
					Messagebox('CAMA LIBERADA POR ERROR AL ADMITIR AL PACIENTE', 64,'Validacion')
				Endif
			Endif
			Exit
		Endif

		mok		= .olevism.p0	&& codigo de error
		mcodadm = .olevism.P1	&& codigo de admision
		mobserv = .olevism.P3	&& Observa_SP1_Comen_SP1_Opera_SP1_Fecha_SP1_Hora
		mcodsec = .olevism.p4	&& codigo de secuencia

		If .olevism.p0 <> ''
			mcoderr = Round(Val(.olevism.p0), 0)
			Do sp_busco_texto_error With mcoderr
			mcoderr = mcoderr + 3000
			Messagebox(Alltrim(mwktaberror.textoerror), 48, 'Validacion')
			Do sp_insert_tabCtrlErr With .olevism.Code, .olevism.p0, midusua, .Name
***************  LIBERO LA CAMA
			maccion = 'L'
			mnroad  = ''
			ltodook = .F.
			.olevism.Code = "D ACTCAMA^RTN005(" + mgraba + ',"'  + mcodsec + '","'+ ;
			mhabita + '","' + mcama  + '","' + mcatego + '","' + ;
			maccion + '","' + mnroad + '",' + mcodusu + ')'

			.olevism.execflag = 1
			mmsgerr = .olevism.errorname
			If !Empty(mmsgerr)
				Select mwkusuario
				Go Top
				midusua     = mwkusuario.idusuario
				Do sp_insert_tabCtrlErr With .olevism.Code, mmsgerr , midusua, .Name
			Else
				mok		= .olevism.p0		&& Codigo de error
				If .olevism.p0 <> ''
					mcoderr = Round(Val(.olevism.p0), 0)
					Do sp_busco_texto_error With mcoderr
					Messagebox(Alltrim(mwktaberror.textoerror), 48, 'Validacion')
					Messagebox('NO SE PUDO LIBERAR LA CAMA', 64,'Validacion')
				Else
					Messagebox('CAMA LIBERADA POR ERROR AL ADMITIR AL PACIENTE', 64,'Validacion')
				Endif
			Endif
			Exit
		Endif

		tcCodAdm = mcodadm
		tnCodEnt = mcodent
		mcodadmision = mcodadm
		Do sp_busco_npac With mcodadm,0
		mnrohcbb = mwkpacnom.Pac_CodHce
		Use In mwkpacnom
		If Used('mwkbuspacie')
			Select * From mwkbuspacie Into Cursor mwkbuspacieBAX
			Use In mwkbuspacie
		Endif
		Do cws_admision With "INT",tcHCE,mcodadmision
		If Used('mwkbuspacieBAX')
			Select * From mwkbuspacieBAX Into Cursor mwkbuspacie
			Use In mwkbuspacieBAX
		Endif
		lbResu = .T.
		Exit
	Enddo
	.olevism.mserver = ''
Endwith


Return (lbResu)
