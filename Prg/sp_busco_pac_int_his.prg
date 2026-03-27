****
** Estadístico pacientes internados x fecha desde/hasta
****

Parameter mdesde, mhasta

Do sp_conexion
*
mdesde = ctod("01/10/2008")
mhasta = ctod("23/11/2008")
*
If used('mwkpacint2')
	Use in mwkpacint2
Endif
Create cursor mwkpacint2 (ladmi c(8), lfecha d, lentidad n(6), lsector c(3), ltipo n(1))
*
If used('mwkpacint1')
	Use in mwkpacint1
Endif
mret = sqlexec(mcon1,"select PIN_codadmision as codadm,PIN_codentidad as codent"+;
	" from PACINTERNAD"+;
	" order by PIN_codentidad,PIN_codadmision","mwkpacint1")
If mret < 0
	Messagebox("EN CONSULTA DE PACIENTES INTERNADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif
*
If used('mwkpacint0')
	Use in mwkpacint0
Endif
mret = sqlexec(mcon1,"select PAC_codadmision as codadm,COB_codentidad as codent,"+;
	"PAC_motivoalta,PAC_fechaalta,PAC_fechaadmision"+;
	" from pacientes, coberturas "+;
	" where PAC_codadmision = COB_pacientes and"+;
	" PAC_tipopac < 2 and" +;
	" PAC_fechaalta >= ?mdesde and" +;
	" PAC_fechaadmision <= ?mhasta","mwkpacint0")
If mret < 0
	Messagebox("EN CONSULTA DE PACIENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif
*
If used('mwkpacint')
	Use in mwkpacint
Endif

Select *,1  as PAC_motivoalta,date()+1 as PAC_fechaalta,date() as PAC_fechaadmision from mwkpacint1 ;
	union select * from mwkpacint0 ;
	group by codent,codadm into cursor mwkpacint
*
If reccount('mwkpacint')>0
	Select mwkpacint
	Scan
		If used('mwklugar')
			Use in mwklugar
		Endif
		mcda = mwkpacint.codadm
		ment = mwkpacint.codent
		mfalta = mwkpacint.PAC_fechaalta
		mfingr = mwkpacint.PAC_fechaadmision
		mobito = (mwkpacint.PAC_motivoalta = 6)
		mret = sqlexec(mcon1,"select * from LUGARINTERN where LUG_pacientes = ?mcda","mwklugar")
		If mret > 0
			If used('mwklugar')
				If reccount('mwklugar')>0
					Select * from mwklugar where mwklugar.LUG_fechaingreso <= mhasta and;
						mwklugar.LUG_fechaegreso >= mdesde into cursor mwklugar
					Select mwklugar
					Scan
						mfdesde = iif(mwklugar.LUG_fechaingreso >= mdesde, mwklugar.LUG_fechaingreso, mdesde)
						mfhasta = iif(mwklugar.LUG_fechaegreso <= mhasta, mwklugar.LUG_fechaegreso, mhasta)
						msector = mwklugar.LUG_codsector
						mveces  = mfhasta - mfdesde + 1
						For mndia = 1 to mveces
							mdia = mfdesde + mndia - 1
							If used('mwkpacint3')
								Use in mwkpacint3
							Endif
							mtipo = 2
							Select * from mwkpacint2 where lfecha = mdia and ladmi = mcda and lentidad = ment into cursor mwkpacint3
							If reccount('mwkpacint3')=0
								Insert into mwkpacint2 (ladmi,lfecha,lentidad,lsector,ltipo) values;
									(mcda,mdia,ment,msector,mtipo)
							Else
								Update mwkpacint2 set lsector=msector, ltipo=mtipo ;
									where lfecha = mdia and ladmi = mcda ;
									 and lentidad = ment
							Endif
						Endfor
							mfalta = mwkpacint.PAC_fechaalta
							mfingr = mwkpacint.PAC_fechaadmision
						If  !mobito and mfalta <= mhasta and mfalta # mfingr 
						 	Update mwkpacint2 set ltipo=1 ;
								where lfecha = mdia and ladmi = mcda ;
								and lentidad = ment and lsector=msector
						Endif
					Endscan
				Endif
			Endif
		Else
			Messagebox("EN CONSULTA DE LUGAR INTERNACION"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return
		Endif
	Endscan
	If used('mwkpacint3')
		Use in mwkpacint3
	Endif
	Select *,sum(iif(ltipo=2,1,0)) as cantf , count(*) as cantu from mwkpacint2 group by lentidad,lsector,lfecha order by lfecha into cursor mwkpacint3

	If reccount('mwkpacint3')>0
		Select mwkpacint3
		Scan
			mcantf = mwkpacint3.cantf
			mcantu = mwkpacint3.cantu
			menti = mwkpacint3.lentidad
			media = mwkpacint3.lfecha
			mhora = 0
			msect = mwkpacint3.lsector
			
			mret = sqlexec(mcon1,"select id from TabHistPacInt where Codentidad = ?menti  and Fecha = ?media "+;
				" and Sector = ?msect ","mwkctrl")
			If mret < 0
				=aerr(eros)
				Messagebox("EN ACTUALIZACION DE HISTORICO DE PACIENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*				Set step on
			Endif
			If reccount('mwkctrl') = 0
			
				mret = sqlexec(mcon1,"insert into TabHistPacInt (Cantidad,CantidadFact,Codentidad,Fecha,Hora,Sector)"+;
					" values (?mcantu,?mcantf,?menti,?media,?mhora,?msect)")
			Else
				mid = mwkctrl.id
				
				mret = sqlexec(mcon1,"update TabHistPacInt set Cantidad=?mcantu, CantidadFact=?mcantf"+;
					" where id=?mid")
			Endif
			If mret < 0
				=aerr(eros)
				Messagebox("EN ACTUALIZACION DE HISTORICO DE PACIENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*				Set step on
			Endif
		Endscan
	Endif
Endif
Do sp_desconexion

If used('mwklugar')
	Use in mwklugar
Endif

If used('mwkpacint')
	Use in mwkpacint
Endif

If used('mwkpacint0')
	Use in mwkpacint0
Endif

If used('mwkpacint1')
	Use in mwkpacint1
Endif

If used('mwkpacint2')
	Use in mwkpacint2
Endif

If used('mwkpacint3')
	Use in mwkpacint3
Endif

Return
