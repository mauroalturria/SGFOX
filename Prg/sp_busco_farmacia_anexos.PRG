*
* busqueda de datos anexos
*
Lparameters mregistro, mmaestro

If used('mwkdatmae')
	Use in mwkdatmae
Endif

If mmaestro = 1
	mret = sqlexec(mcon1,"select TFP_institucion as institu,"+;
		" TFP_ubicacion as ubica,TFP_pisocama as pisocam,TFP_talla,TFP_peso,TFP_supcor,"+;
		" TabFarmIns.TFI_descripcion,TFP_medico,TFP_matricula,TFP_diagnos,TabFarmPlan.id as lid,"+;
		" TFP_formula,nvl(TabFarmEsq.TFE_esquema,'                                                            ')"+;
		" as TFE_esquema,TFP_esquema,TFP_diagnos,TFP_fecmov"+;
		" from TabFarmPlan "+;
		" join TabFarmIns on TabFarmIns.Id = TabFarmPlan.TFP_institucion"+;
		" and TabFarmIns.TFI_fechapasivo is NULL"+;
		" left join TabFarmEsq on TabFarmEsq.Id = TabFarmPlan.TFP_esquema"+;
		" where TFP_registracio=?mregistro and TFP_estado=1","mwkdatmae")
Else
	mret = sqlexec(mcon1,"select TCP_institucion as institu,"+;
		" TCP_ubicacion as ubica,TCP_pisocama as pisocam"+;
		" from TabFarmCitosP where TCP_registracio=?mregistro","mwkdatmae")
Endif

If mret < 0

	Messagebox("EN CONSULTA DE DATOS ANEXOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
