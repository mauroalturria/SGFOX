Lparameters mCodEnt,mDocumento

Local lResult
Local cCodEnt
Local cDescrip
Local oIn
Local nPos
LOCAL mPlan

cCodEnt = Transform(mCodEnt)
lResult = .F.
cDescrip = ""
nPos = 0

* SET STEP ON

IF VARTYPE(mDocumento) <> "N"
   MESSAGEBOX("No se recibió DOCUMENTO del paciente." + CHR(10) + "Verificación de Paciente Concierge." + CHR(10) + "No se genera email." + CHR(10)+"(sp_busca_entconcierge)", 16,"Concierge")
   RETURN .f.
ENDIF 
   
*!*	mret = SQLExec(mcon1,"SELECT Entidexclu.codent, Entidexclu.tipoturno, Entidexclu.tpopac, " + ;
*!*		"Entidades.ENT_descrient, Entidexclu.ID, Entidexclu.fecpasiva, " +;
*!*		"Entidexclu.tpopamb, Entidexclu.tpopgua, Entidexclu.tpopint, " +;
*!*		"Entidades.ENT_fecpas, Entidades.ENT_codent, Entidexclu.fecvigend, " + ;
*!*		"Entidexclu.fecvigenh " + ;
*!*		"FROM " +;
*!*		"SQLUser.EntidExclu Entidexclu, " + ;
*!*		"SQLUser.ENTIDADES Entidades " +;
*!*		"WHERE Entidades.ENT_codent = Entidexclu.codent " +;
*!*		"AND (  Entidades.ENT_fecpas IS NULL " + ;
*!*		"AND Entidexclu.tpopac = 'ESP' ) " + ;
*!*		"and Entidexclu.fecpasiva = '1900-01-01' "  + ;
*!*		"and codent = ?mCodEnt ","mwkConcierge")
Do sp_busco_estados With 4, " and tipo = 61  ","mwkConcierge"

***"ORDER BY Entidexclu.codent, Entidexclu.tipoturno","mwkConcierge")


If Used("mwkConcierge")
	Select mwkConcierge
	Go Top

	Scan All

		cDescrip = cDescrip + Trim(mwkConcierge.Descrip) + ","


*!*			If At(cCodEnt,mwkConcierge.Descrip) > 0
*!*				lResult = .T.
*!*				Exit
*!*			Endif

	Endscan

*   --------------------------------
	Alines(aEntidades,cDescrip,",")
*   --------------------------------

	For Each oIn In aEntidades
		nPos = At("-",oIn)
		mPlan = 0
		
		If nPos > 0
		
*           El separador para Entidad+Plan es el guión medio (-)
			cEntidad = Trim(oIn)
			cEntidad = Left(cEntidad,nPos-1)
			mPlan = Val(Right(Trim(oIn),Len(Trim(oIn))-nPos))

			If Val(cEntidad) = mCodEnt

				lResult = BuscaPlanPaciente(1,mCodEnt,mDocumento,mPlan)
				If lResult
					Exit
				Endif
			Endif

		Else

*           Marcelo Torres, 09/02/2026
*           Pacientes Vip.
*           Comienzan con signo de pregunta (?)
*           Ej. "?13" para pacientes VIP establecidos por la dirección.

			nPos = At("?",oIn)
			If nPos = 1
				*cEntidad = Trim(oIn)
				*cEntidad = Left(cEntidad,nPos-1)
				mPlan = Val(Right(Trim(oIn),Len(Trim(oIn))-nPos))

				*If Val(cEntidad) = mCodEnt

					lResult = BuscaPlanPaciente(2,0,mDocumento,mPlan)
					If lResult
						Exit
					Endif
				*Endif
			Else
				If Trim(oIn) = cCodEnt
					lResult = .T.
					Exit
				Endif
			Endif
		Endif
	Next

Endif

Use In Select("mwkConcierge")

Return lResult


* mEntidad = código de entidad
* mDocumento = documento del paciente
* mPlan = código del plan del paciente
* ---------------------------------------
Function BuscaPlanPaciente(nOpcion,mEntidad,mDocumento,mPlan)

Local nAgrupa
Local lResult
Local dHoy

nAgrupa = 0
lResult = .F.

dHoy = sp_busco_fecha_serv("DD")

mret = SQLExec(mcon1,"select Ent_codagrup from Entidades where Ent_Codent = ?mEntidad","mwkEntConc")

Select mwkEntConc
Go Top

nAgrupa = mwkEntConc.Ent_codagrup

DO Case
Case nOpcion = 1

	mret = SQLExec(mcon1,"select * from PadCabe where documento = ?mDocumento and Entidad = ?nAgrupa and Plan = ?mPlan and FecEgreso = '2100-01-01' ","mwkAfiConc")

	Select mwkAfiConc
	Go Top

	If Reccount("mwkAfiConc") > 0
		lResult = .T.
	Endif

Case nOpcion = 2

*    Marcelo Torres, 09/02/2026
*    Busca en la tabla de CONDICIONES ESPECIALES DE PACIENTES : ZabRegCondesp
*    La descripción del tipo de plan se encuentra en TabEstados propietario = 51
*    Hablado con Carmen
	mret = SQLExec(mcon1,"select b.* " +;
		"from REGISTRACIO as a " +;
		"join Zabregcondesp as b on a.REG_nroregistrac = b.RCE_registracio " +;
		"where a.REG_numdocumento = ?mDocumento and b.RCE_tipoCondesp = ?mPlan and b.RCE_fechahasta >= ?dHoy","mwkregcondesp")

	If mret < 0
		lResult = .F.
	Else

		Select mwkregcondesp
		Go Top

		If Reccount("mwkregcondesp") > 0
			lResult = .T.
		Endif

	ENDIF
	
Endcase


Use In Select("mwkEntConc")
Use In Select("mwkAfiConc")
Use In Select("mwkregcondesp")

Return lResult
