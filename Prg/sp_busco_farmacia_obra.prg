*
* Busqueda de Obra Social para Farmacia
*
Lparameters mbusca
*Function sp_busco_farmacia_Obra(mbusca)

If used('mwkdat')
	Use in mwkdat
Endif

mretorno = ''
mret = sqlexec(mcon1,"select ENT_descrient from Registracio"+;
	" join afiliacion on afiliacion.registracio = registracio.REG_nroregistrac"+;
	" join entidades on afiliacion.AFI_codentidad = entidades.ENT_codent"+;
	" where REG_nroregistrac = ?mbusca","mwkdat")

If mret < 0
	Messagebox("EN CONSULTA DE OBRAS SOCIALES PAC. REGISTRADOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else
	If used("mwkdat")
		If reccount("mwkdat")>0
			Select mwkdat
			Go top
			mretorno = mwkdat.ENT_descrient
		Else
			mret = sqlexec(mcon1,"select ENT_descrient from Preregistra"+;
				" join entidades on entidades.ENT_codent = Preregistra.codent"+;
				" where Id = ?mbusca","mwkdat")

			If mret > 0
				If used("mwkdat")
					If reccount("mwkdat")>0
						Select mwkdat
						Go top
						mretorno = mwkdat.ENT_descrient
					Endif
				Endif
			Else
				Messagebox("EN CONSULTA DE OBRAS SOCIALES PAC. PRE-REGISTRADOS"+chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Endif
		Endif
	Endif
Endif
Return mretorno
