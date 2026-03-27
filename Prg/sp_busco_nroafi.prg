*
* Busqueda nro Afiliado y Entidad
*
Lparameters madmision, mtipo

If Vartype(mtipo) <> 'C'
	mtipo = 'A'
Endif

mretorno = 0

If mtipo = 'A'
	Use In Select("mwknroafi")
	mret = SQLExec(mcon1,"select AFI_nroafiliado, AFI_codentidad "+;
		" from PACIENTES"+;
		" join coberturas on COB_PACIENTES = PACIENTES.PAC_codadmision"+;
		" join AFILIACION on AFILIACION.AFI_codentidad = coberturas.COB_codentidad and AFILIACION.REGISTRACIO = PACIENTES.PAC_codhci"+;
		" where PAC_codadmision = ?madmision","mwknroafi")

	If mret < 0
		mltabla = "CONSULTA COBERTURA / NRO DE AFILIADO "
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla + Chr(10) + "AVISE A SISTEMAS", 16, "ERROR")
	Endif
Endif

If Used("mwknroafi")
	Select mwknroafi
	If mtipo = 'A' && Afiliado
		mretorno = mwknroafi.AFI_nroafiliado
	ELSE           && ID Entidad Trazable
		sp_busco_entraza(mwknroafi.AFI_codentidad)
		If Used("mwkcodent")
			mretorno = mwkcodent.TRAE_idobrasoc
		Endif
	Endif
Endif

Return mretorno
