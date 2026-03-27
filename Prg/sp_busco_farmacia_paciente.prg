*
* Busqueda de Nombre Paciente para Farmacia
*
Lparameters mbusca

*Function sp_busco_farmacia_paciente(mbusca)

If used('mwkdat')
	Use in mwkdat
Endif

mretorno = ''
mret = sqlexec(mcon1,"select REG_nombrepac from Registracio"+;
	" where REG_nroregistrac=?mbusca","mwkdat")

If mret < 0
	Messagebox("EN CONSULTA DE PACIENTES REGISTRADOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else
	If used("mwkdat")
		If reccount("mwkdat")>0
			Select mwkdat
			Go top
			mretorno = mwkdat.Reg_nombrepac
		Else
			mret = sqlexec(mcon1,"select nombre from Preregistra where Id=?mbusca","mwkdat")
			If mret > 0
				If used("mwkdat")
					If reccount("mwkdat")>0
						Select mwkdat
						Go top
						mretorno = mwkdat.nombre
					Endif
				Endif
			Else
				Messagebox("EN CONSULTA DE PACIENTES PRE-REGISTRADOS"+chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Endif
		Endif
	Endif
Endif
Return mretorno
