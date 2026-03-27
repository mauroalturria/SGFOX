*
* Actualización de Polizas, aseguradoras
*
Lparameters mid,mf1,mf2,mpo

If used('mwkpolizas')
	Use in mwkpolizas
Endif

mret = sqlexec(mcon1,"select *,id as lid from TabLGPoliza"+;
	" where TLP_idasegura=?mid and TLP_poliza=?mpo","mwkpolizas")

If mret>0
	If used('mwkpolizas')
		If reccount('mwkpolizas')>0
			mres = messagebox("EXISTE UNA POLIZA CARGADA, ACTUALIZA ?",4+32,"Validación")
			If mres = 6
				mbusca = mwkpolizas.lid
				mret = sqlexec(mcon1,"update TabLGPoliza set TLP_fecdesde=?mf1,TLP_fechasta=?mf2"+;
					" where id = ?mbusca")
				If mret < 0
					Messagebox("EN ACTUALIZACION DE POLIZA"+chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
				Endif
			Endif
		Else
			mret = sqlexec(mcon1,"insert into TabLGPoliza (TLP_idasegura,TLP_fecdesde,TLP_fechasta,TLP_poliza)"+;
				" values (?mid,?mf1,?mf2,?mpo)")
			If mret < 0
				Messagebox("EN ACTUALIZACION DE POLIZA"+chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Endif
		Endif
	Endif
Else
	Messagebox("EN CONSULTA DE POLIZA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif



