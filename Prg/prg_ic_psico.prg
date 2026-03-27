*IC psico
Lparameters olevism,PacNombre,PacEdad,PacAdmision,nSec,SecInt,Cama,;
	Estudio,Estudiofec,Estudiohor,MedicoSolic,Diagnostico,Vale

mPacNombre = PacNombre
mPacEdad = PacEdad
mPacAdmision = Alltrim(PacAdmision)
mSecInt = SecInt
mCama = Cama
mEstudio = Estudio
mEstudiofec = Estudiofec
mEstudiohor = Estudiohor
mMedicoSolic = MedicoSolic
mDiagnostico = Diagnostico
mVale = Vale
mSec = nSec

Do sp_busco_estados With 7,' and tipo = 26 ','mwkHabSecICm'
Do sp_busco_estados With 7,' and tipo = 25 ','mwkHabMailIC'

If mwkHabMailIC.estado <> 1
	Return .T.
Endif

Select mwkHabSecICm
mSecIntValidos = ''
Scan All
	mSecIntValidos = mSecIntValidos + Alltrim(mwkHabSecICm.Descrip)
Endscan
mSecIntValidos = Left(mSecIntValidos,Len(mSecIntValidos)-1)
Locate For Alltrim(nSec) $ Alltrim(Nvl(mSecIntValidos,''))
If !Found()
	Return .T.
Endif

* Entidad y Nro de afiliado
mEntidadPac =  ''
mNroAfiliado = ''
lcsql = "SELECT pacientes.PAC_codhci, afiliacion.AFI_codentidad,afiliacion.AFI_nroafiliado,"+;
	"entidades.ENT_codent,entidades.ENT_descrient,"+;
	"pacinternad.PIN_codadmision,pacinternad.PIN_codentidad "+;
	"from  PACINTERNAD "+;
	"inner join entidades on PACINTERNAD.PIN_codentidad = entidades.ENT_codent "+;
	"inner join pacientes on pacinternad.PIN_codadmision = pacientes.PAC_codadmision "+;
	"inner join afiliacion on pacientes.PAC_codhci = afiliacion.REGISTRACIO "+;
	"where PIN_codadmision = ?mPacAdmision and PIN_CODENTIDAD = AFI_CODENTIDAD "
mret = SQLExec(mcon1,lcsql,'mwkEntiPac')
If mret<0
	Messagebox('No se pudo encontrar la Entidad del paciente',48,'Aviso')
Endif
If Used('mwkEntiPac')
	Select mwkEntiPac
	mEntidadPac = Nvl(mwkEntiPac.ENT_descrient,"")
	mNroAfiliado = Nvl(mwkEntiPac.AFI_nroafiliado,"")
Endif


MESPE = 'PSIC'
lcSep = Chr(10) + Chr(13)
masunto = "NUEVA INTERCONSULTA EN INTERNACION (PSIC-AC)"
lcSep = '<br>'
memomail = ""
memomail = memomail + "<b> Admisión : </b>" + Alltrim(mPacAdmision) + lcSep
memomail = memomail + "<b> Paciente : </b>" + Alltrim(mPacNombre) + lcSep
memomail = memomail + "<b> Entidad: </b> " + Alltrim(mEntidadPac) + lcSep
memomail = memomail + "<b> Nro de Afiliado: </b> " + Alltrim(mNroAfiliado) + lcSep
memomail = memomail + "<b> Ubicación: Sector </b>" + Alltrim(mSecInt) + " <b>- Hab./Cama: </b>" + Alltrim(mCama)+ lcSep
memomail = memomail + "<b> Nro.Vale : </b>"  + Transform(mVale) + lcSep
memomail = memomail + "<b> Fecha / Hora : </b>"  + Dtoc(mEstudiofec) + ' / ' + Ttoc(mEstudiohor,2) + lcSep
memomail = memomail + "<b> Consulta : </b>"  + Alltrim(mEstudio) + lcSep
memomail = memomail + "<b> Diagnóstico: </b>" + Alltrim(mDiagnostico) + lcSep
memomail = memomail + "<b> Solicitado por : </b>"  + Alltrim(mMedicoSolic) + lcSep

* Busco IC Psico y envío Mail
mfechahabilitada = Ctod('01/01/1900')
* Grupo psico = 12 en real
lcsql = 'select * from TabMsgGTV where TMV_fecha = ?mfechahabilitada and TMV_idgrupo = 12 and tmv_idserv = 1'
mret = SQLExec(mcon1,lcsql,'mwkGrupo')
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
	lcsql = 'select * from Tabusuario where id = ?mDestino'
	SQLExec(mcon1,lcsql,'mwkDestino')
	If Used('mwkDestino')
		If Reccount('mwkDestino')>0
			Select mwkDestino
			mrecibe = Alltrim(mwkDestino.email)

*!*				olevism.mserver   = Allt(mwktabcfg.OLEServer)
*!*				olevism.namespace = Allt(mwktabcfg.olespaces)
*!*				olevism.Code = "D SEND^%ZMAIL("+ '"'+mrecibe+'"' +',"'+ masunto + '","' + memomail+ '","","" )'
*!*				olevism.execflag = 1
*!*				mok = olevism.p0
*!*				mrespcose1 = olevism.p2
*!*				olevism.mserver   = ''
*!*				olevism.namespace = ''
*!*				prg_olevism_reset(olevism)

* Modificado 2021-08-17 Para que no use Zmail de Cache

			mdestinatario = mrecibe
			masunto = masunto
			mcuerpo = memomail

			Local loCfg, loMsg, lcFile, loErr
			Try
				loCfg = Createobject("CDO.Configuration")
				With loCfg.Fields
					.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
					.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 && ó 587
					.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
					.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
					.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
					.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "Dl380@sg.com.ar"
					.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") =  "servidor380"
					.Update
				Endwith
				loMsg = Createobject ("CDO.Message")
				With loMsg
					.Configuration = loCfg
*-- Remitenete y destinatarios
					.From = "Interconsultas SG (Dl380)<Dl380@sg.com.ar>"
					.To = "<"+mdestinatario+">"
					.Cc = ''
*- Prioridad
&& -1=Low, 0=Normal, 1=High
					.Fields("urn:schemas:httpmail:priority") = 1
					.Fields("urn:schemas:mailheader:X-Priority") = 1
					.Fields.Update
*- Importancia
&& 0=Low, 1=Normal, 2=High
					.Fields("urn:schemas:httpmail:importance") = 2
					.Fields.Update
*-- Tema
					.Subject = masunto
*-- Formato HTML desde la Web
*    .CreateMHTMLBody("Hola", 0)
					.textbody = mcuerpo
*-- Envio el mensaje
					.Send()
				Endwith
			Catch To loErr
*!*		Messagebox("No se pudo enviar el mensaje" + Chr(13) + ;
*!*			"Error: " + Transform(loErr.ErrorNo) + Chr(13) + ;
*!*			"Mensaje: " + loErr.Message , 16, "Error")
			Finally
				loMsg = Null
				loCfg = Null
			Endtry

		Endif
	Endif
	Select mwkGrupo
Endscan

Use In Select("mwkHabSecICm")
Use In Select("mwkHabMailIC")
