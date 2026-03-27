**Lparameters mIdDiagnostico

Define Class TInfectoDiag As Custom

	pstrDiagnostico = ""   &&El codigo de diagnostico.
	pintTipoInfecto = 0
	pIdDiagnostico = ""
	pCodAdmision = ""
	pCodMedico = 0
	pTipoPac = ""   &&AMB,GUA,INT
	pFechaHoy = sp_busco_fecha_srv2("DD")
	pPatologia = 0
	pRegistracion = 0
	pCodigoCie9 = ""
	pCodMedico = 0
	pNombreMedico = ""

**-------------------------------
	Function ProcesaTipoDiag()
	Lparameters mIdDiagnostico,mCie9,mRegistracio,mCodMedico,mTipo

	Local mFechaInf
	Local mMedicoInf

	This.pRegistracion = mRegistracio
	This.pTipoPac = mTipo
	This.pCodMedico = mMedico
	This.pCodigoCie9 = mCie9

SET STEP ON

	mret = SQLExec(mcon1,"SELECT Tabciaprel.CR_Fecpasiva, Tabciaprel.CR_IdCie9," +;
		"Tabciaprel.CR_diagnostico, Tabciaprel.CR_TipoRel, Tabciap2e.DescrAbrev,Tabciap2e.Codigo," +;
		"Zabmspat.MSP_patologia, Tabciaprel.ID, Zabmspat.MSP_codigo," +;
		"Zabmspat.MSP_tipo, Zabmspat.ID " +;
		"FROM TabCiapRel " +;
		"left join ZabMSpat on Tabciaprel.CR_diagnostico = Zabmspat.ID " +;
		"left join Tabciap2e on Tabciaprel.CR_IdCie9 = Tabciap2e.ID " +;
		"where Tabciaprel.CR_TipoRel = 2 and MSP_tipo in (1,3) and Tabciaprel.CR_IdCie9 = ?mDiagnostico and Tabciap2e.Codigo = ?mCie9","mwkciaprel")

	If mret<=0
		Messagebox("ERROR EN LA LECTURA DE DIAGNOSTICOS.",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

** El campo requerido es MSP_tipo. Si es tipo 1 o 3 ver de grabar. Solo en tipo 1 se envia mail.
** Vemos si ya hay cargado diagnositoc para el afiliado
	Select mwkciaprel
	Go Top

**   Este es el codigo se graba, igual que el CIE9.
	This.pPatologia = mwkciaprel.MSP_codigo

	If Reccount() > 0

		mret = SQLExec(mcon1,"select * from ZabRegENO " +;
			"where TRE_registracio = ?this.pRegistracion and TRE_codcie9 = ?mCie9 and TRE_fecpasiva = '1900-01-01' AND Tre_tipopac = ?this.pTipoPac ","mwkRegEno")

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE DIAGNOSTICOS REGISTRADOS.",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select mwkRegEno
		Go Top

		mFechaInf = mwkRegEno.TRE_fechaden
		This.pNombreMedico = This.NombreMedico(mwkRegEno.TRE_codmedico)

		Do Case
		Case MSP_tipo = 1
**   Grabar y enviar mail a grupo de infectologia

			If reccno() > 0
				If Messagebox("Ya se encuentra informado el diagnostico : "+ Alltrim(mwkciaprel.DescrAbrev)+ Chr(10)+ "en la fecha : " + Dtoc(mFechaInf) + Chr(10) + "por el medico : " + This.pNombreMedico + Chr(10) + "Desea volver a informar?",4,"Diagnostico") = 6
**This.InformaInfectoDiag(1)
					This.EnviaMailDiag()
				Endif
**Else
**This.InformaInfectoDiag(1)
				This.GrabaInfectoDiag()
			Endif

		Case MSP_tipo = 3
**   Solamente grabar.
			If reccno() > 0
				If Messagebox("Ya se encuentra registrado el diagnostico : "+ Alltrim(mwkciaprel.DescrAbrev)+ Chr(10)+ "en la fecha : " + Dtoc(mFechaInf) + Chr(10) + "por el medico : " + This.pNombreMedico + Chr(10) + "Desea volver a registrar?",4,"Diagnostico") = 6
**This.InformaInfectoDiag(3)
					This.GrabaInfectoDiag()
				Endif
			Else
**This.InformaInfectoDiag(3)
				This.GrabaInfectoDiag()
			Endif

		Endcase

	Endif

	Use In Select("mwkciaprel")
	Use In Select("mwkRegEno")

	Return .T.

	Endfunc


** -----------------------------
	Procedure InformaInfectoDiag()
	Lparameters mTipo

	Do Case
	Case mTipo = 1   &&Enviamos mail y grabamos
		This.EnviaMailDiag()
		This.GrabaInfectoDiag()
	Case mTipo = 3   &&Solo grabamos
		This.GrabaInfectoDiag()
	Endcase

	Endproc


** -----------------------------
	Procedure GrabaInfectoDiag()

	mret = SQLExec(mcon1,"insert into ZabRegEno (Tre_tipopac,Tre_fechaden,Tre_patologia,Tre_registracio,TRE_codmedico,TRE_codcie9) values " +;
		"(this.pTipoPac,this.pFechaHoy,this.pPatologia,this.pRegistracio,this.pCodMedico,this.pCodigoCie9) )"

	If mret<=0
		Messagebox("ERROR EN LA GRABACION DE DIAGNOSTICOS REGISTRADOS.",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

	Endproc

** -----------------------------
	Function NombreMedico(nMedico)

	Local cNombre

** Devuelve el cursor mwkMedicogua
	Do sp_busco_medrempzt With , , , , This.pTipoPac

	Select mwkMedicogua
	Go Top
	cNombre = Nombre

	Use In Select("mwkMedicogua")

	Return cNombre

	Endfunc

** -----------------------------
** Envio de mail a grupo de infectologia
	Procedure EnviaMailDiag()

    LOCAL cTo
	Local cAsunto
	Local cCuerpo
	Local cFrom

    cTo = "mTorres@sg.com.ar"
	cFrom = "mTorres@sg.com.ar"

	cAsunto = "Denuncia " + mwkciaprel.DescrAbrev
	cCuerpo = This.ArmaCuerpoMail()

**Do sp_enviamail_cdo2000 With matach,mdestino, cSubject, cBody, cFrom
	Do sp_enviamail_cdo2000 With , cTo, cAsunto , cCuerpo, cFrom

	Endproc

** -----------------------------
	Function ArmaCuerpoMail

	Local cCuerpo
	Local mfecnac

*!*	.TxtApel.value			= left(mwkveoproto.REG_nombrepac,at(",",mwkveoproto.REG_nombrepac)-1)
*!*	.TxtNomPila.value		= substr(mwkveoproto.REG_nombrepac,at(",",mwkveoproto.REG_nombrepac)+1)
*!*	.TxtApelMat.value		= mwkregdatos.TRDA_ApelMat
*!*	.TxtHClinica.value 		= mwkveoproto.reg_nrohclinica
*!*	.txtdomici.value 		= iif(isnull(mwkveoproto.reg_domicilio), '', mwkveoproto.reg_domicilio)
*!*	.txttel.value	 		= iif(isnull(mwkveoproto.reg_telefonos), '', mwkveoproto.reg_telefonos)
*!*	.txtfecnac.value		= iif(isnull(mwkveoproto.reg_fecnacimiento), ctod("01/01/1900"), mwkveoproto.reg_fecnacimiento)
	mfecnac = Iif(Isnull(mwkveoproto.reg_fecnacimiento), Ttod(mwkfecserv.fechahora), mwkveoproto.reg_fecnacimiento)
**.txtEdad.value = prg_edad(mfecnac)

	cCuerpo = "Nombre : " + Alltrim(mwkveoproto.REG_nombrepac) + Chr(10)
	cCuerpo = cCuerpo + "Edad : " + Transform(prg_edad(mfecnac),"999") + Chr(10)
	cCuerpo = cCuerpo + "Sexo : " + mwkveoproto.reg_sexo + Chr(10)
	cCuerpo = cCuerpo + "Documento : " + mwkveoproto.reg_tipodocumento + Transform(mwkveoproto.reg_numdocumento,"99999999999") + Chr(10)
	cCuerpo = cCuerpo + "Dirección : " + Nvl(mwkveoproto.reg_domicilio,"") + Chr(10)
	cCuerpo = cCuerpo + "Localidad : " + Nvl(mwkveoproto.reg_localidad,'') + Chr(10)

	Return cCuerpo

	Endproc


Enddefine

