*
* Busqueda de datos ( Nombre/HC de Pacientes ) x Cod. Adm.
*
Parameters mcodigo, mltipo

If Vartype(mltipo) # "N"
	mltipo = 1
Endif

mretorno = ''

If Used('mwkpacnom')
	Use In mwkpacnom
Endif

Do Case
Case mltipo = 8  && 2020-01-14 -nroregistrac
	Use In Select("mwkpacdocu")

	mret = SQLExec(mcon1,"select REG_nombrepac,REG_numdocumento,REG_fecnacimiento "+;
		" from  REGISTRACIO "+;
		" Where REG_nroregistrac = ?mcodigo", "mwkpacdocu")

	If mret < 0
		Messagebox("ERROR EN BUSQUEDA DEL DOCUMENTO DEL PACIENTE",48,"Validacion")
	Else

		If Reccount('mwkpacdocu') > 0
			Select mwkpacdocu
			Go Top
			mretorno =  mwkpacdocu.REG_nombrepac
		Endif

	Endif

	Use In Select("mwkpacdocu")
Case mltipo = 9  && 2020-01-14 -nroregistrac
	Use In Select("mwkpacdocu")

	mret = SQLExec(mcon1,"select REG_nombrepac,REG_nrohclinica,REG_numdocumento,REG_fecnacimiento "+;
		" from  REGISTRACIO "+;
		" Where REG_nroregistrac = ?mcodigo", "mwkpacdocu")

	If mret < 0
		Messagebox("ERROR EN BUSQUEDA DEL DOCUMENTO DEL PACIENTE",48,"Validacion")
	Else

		If Reccount('mwkpacdocu') > 0
			Select mwkpacdocu
			Go Top
			mretorno =  mwkpacdocu.REG_nrohclinica
		Endif

	Endif

	Use In Select("mwkpacdocu")
	Case mltipo = 10  && 2020-01-14 -nroregistrac
	Use In Select("mwkpacdocu")

	mret = SQLExec(mcon1,"select REG_nombrepac,REG_nrohclinica,REG_numdocumento,REG_fecnacimiento "+;
		" from  REGISTRACIO "+;
		" Where REG_nroregistrac = ?mcodigo", "mwkpacdocu")

	If mret < 0
		Messagebox("ERROR EN BUSQUEDA DEL DOCUMENTO DEL PACIENTE",48,"Validacion")
	Else

		If Reccount('mwkpacdocu') > 0
			Select mwkpacdocu
			Go Top
			mretorno =   mwkpacdocu.REG_fecnacimiento 
		Endif

	Endif

	Use In Select("mwkpacdocu")
Case mltipo < 3 Or mltipo >= 5

	mret = SQLExec(mcon1,"select PAC_nombrepaciente, PAC_codhci, Pac_CodHce, Pac_edad,"+;
		"Pacientes.PAC_sectorinternac, Pacientes.PAC_habitacion, Pacientes.PAC_cama,PAC_CentroMedico "+;
		" from pacientes where PAC_codadmision = ?mcodigo","mwkpacnom")

	If mret < 0
		Messagebox("ERROR EN BUSQUEDA DEL NOMBRE DEL PACIENTE",48,"Validacion")
	Else

		If Reccount('mwkpacnom') > 0
			Select mwkpacnom
			Go Top

			Do Case
			Case mltipo = 0
				mretorno = mwkpacnom.PAC_nombrepaciente + '*' + Space(3-Len(Alltrim(Str(mwkpacnom.Pac_edad)))) + Alltrim(Str(mwkpacnom.Pac_edad))
			Case mltipo = 1
				mretorno = mwkpacnom.PAC_nombrepaciente
			Case mltipo = 2
				mretorno = (mwkpacnom.PAC_nombrepaciente + Str(mwkpacnom.PAC_codhci))
			Case mltipo = 5
				mretorno = mwkpacnom.PAC_sectorinternac+" " +Alltrim(PAC_habitacion)+" " +Alltrim(PAC_cama )
			Case mltipo = 6
				mretorno =   mwkpacnom.PAC_codhci
			Case mltipo = 7
				mretorno =   Nvl(mwkpacnom.PAC_CentroMedico,1)
			Endcase
*!*         mretorno = iif(mltipo = 1, mwkpacnom.PAC_nombrepaciente, mwkpacnom.PAC_nombrepaciente + str(mwkpacnom.PAC_codhci))
		Endif

	Endif

Case mltipo = 3

	mret = SQLExec(mcon1,"select ENT_descrient,ENT_codent from entidades"+;
		" join HISTAMBGUA on HIS_codadmision = ?mcodigo","mwkpacnom")

	If mret < 0
		Messagebox("EN CONSULTA DE ENTIDAD"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else
		If Used("mwkpacnom")
			If Reccount("mwkpacnom")>0
				mretorno = mwkpacnom.ENT_descrient
			Endif
		Endif
	Endif

Case mltipo = 4  && 2020-01-14 - Documento

	Use In Select("mwkpacdocu")

	mret = SQLExec(mcon1,"select REGISTRACIO.REG_numdocumento, PAC_codhci"+;
		" From pacientes"+;
		" Join REGISTRACIO On REGISTRACIO.REG_nroregistrac = pacientes.PAC_codhci"+;
		" Where PAC_codadmision = ?mcodigo", "mwkpacdocu")

	If mret < 0
		Messagebox("ERROR EN BUSQUEDA DEL DOCUMENTO DEL PACIENTE",48,"Validacion")
	Else

		If Reccount('mwkpacdocu') > 0
			Select mwkpacdocu
			Go Top
			mretorno = Alltrim(Transform(mwkpacdocu.REG_numdocumento))
		Endif

	Endif

	Use In Select("mwkpacdocu")


Endcase


If Used('mwkpacnom') And mltipo > 0 &&& si le mando 0 no quiero que me borre el cursor
	Use In mwkpacnom
Endif

Return mretorno

