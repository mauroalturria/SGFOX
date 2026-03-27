*
* Asentar en campo FechaPrevTecConf el valor = 0 (confirmado) para valor = 1 (p/confirmar), siendo fecha > 24 hs.
*
If used("mwkfptec")
	Use in mwkfptec
Endif

mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"select fechaAsig,idot"+;
	" from TabMantenimiento,TabMantAudit"+;
	" where FechaPrevTecConf=1 and TabMantenimiento.id=TabMantAudit.idot"+;
	" and fechaprevtec<>?mfecnull"+;
	" order by fechaasig asc","mwkfptec")

If mret > 0
	If used('mwkfptec')
		If reccount('mwkfptec') > 0
			Select * from mwkfptec group by idot into cursor mwkfptec
			Select mwkfptec
			Scan
				mhora = right(ttoc(mwkfptec.fechaAsig),8)
				mfech = ttod(mwkfptec.fechaAsig)
				midot = mwkfptec.idot
				mlok  = .t.
				mfech = sp_busco_fecha_serv("DD")
				Do while mlok
					mdia  = day(mfech) &&day(mfech)
					mmes  = month(mfech)
					mpas  = .t.
					If !inlist(dow(mfech),7,1)
						If used('MWKFeriados')
							Use in MWKFeriados
						Endif
						mret = sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia = ?mfech","MWKFeriados")
						If ( reccount("MWKFeriados") > 0 ) or ( ( mdia = 24 or mdia = 31 ) and mmes = 12 )
							mpas = .f.
						Endif
					Else
						mpas = .f.
					Endif
					If mpas
						mfechaVS = mfech + 1 && Busco Viernes Santo si es que estoy en Jueves Santo
						mret = sqlexec(mcon1,"SELECT dia,Motivo FROM feriaturnosA,Tabferiados "+;
							"WHERE dia =?mfechaVS  and Motivo = Tabferiados.ID and motivo = 10 ",'MWKFeriados')
						If reccount('MWKFeriados') > 0
							mpas = .f.
						Endif
					Endif
					mlok = !mpas
					If mlok
						mfech = mfech - 1
					Endif
				Enddo
				mfctrl = ctot(dtoc(mfech)+' '+mhora)
				If mfctrl >= (mwkfptec.fechaAsig + 86400)
					mret = 0
					Do sp_actua_mant_fecpconf with 0,midot
					If mret > 0
						mFechaAsig  = sp_busco_fecha_srv2('DT')
						mComentario1 = 'Fecha Tecnico Prevista - Conformidad -, automático x superar límite'
						Do sp_Grabo_MantAudit with  mFechaAsig,midot,5,mComentario1
					Endif
				Endif
			Endscan
		Endif
	Endif
Else
	Messagebox("EN CONSULTA DE ORDENES DE TRABAJO A CONFIRMAR"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif



