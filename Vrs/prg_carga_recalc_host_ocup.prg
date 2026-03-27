Create cursor mwkpacint2 (ladmi c(8), lfecha d, lentidad n(6), lsector c(3), ltipo n(1),hora n (4) )

mret = Sqlexec(MCON1,"SELECT * FROM TabHistOcup WHERE CAMASLIBRES IS NULL AND (HORA = 1000 OR HORA = 1600)","mwkHistOcup")
If mret <= 0
	Set Step On 
Endif 

Select mwkHistOcup
Replace camaslibres With 0 all

Select Max(fecha) as maximo, Min(fecha) as minimo ;
	From mwkHistOcup ;
	Into Cursor mwkfechas

mfechaIni = mwkfechas.minimo
mfechaFin = mwkfechas.maximo

mfechaIni = ctod("10/02/2011")
mfechaFin = ctod("15/03/2011")
*!*	mfechaFin = mfechaIni + 1 &&&&&&&&& SACAR PARA EL PROCESO FINAL

	mfecdes		= ctod("10/02/2011")
	mfechas		= ctod("15/03/2011")

	mbusco1 	= " and pac_fechaadmision >= ?mfecdes and pac_fechaadmision <= ?mfechas and pac_fechaalta is not null "
	mbuscoa1 	= " and pac_fechaadmision >= ?mfecdes and pac_fechaadmision <= ?mfechas "

	do sp_busco_pac_admitidos with mbusco1, msql_pacact
	select * from mwkpacint into cursor mwkpacintact
	mfechatope = mfecdes - 30 && pacientes hasta 1 meses internados
		msql_pacant=''
		mbusco1	= " and pac_fechaalta >= ?mfecdes and pac_fechaadmision < ?mfecdes  "
		do sp_busco_pac_admitidos with mbusco1, msql_pacant
		select * from mwkpacintact;
			union select * from mwkpacint where  pac_fechaalta >= mfecdes ;
			into cursor mwkpacintt
		mbusco1 	= " "
		do sp_busco_pac_internados with mbusco1, msql_pacant

		select pac_nombrepaciente, sec_codsector, sec_descripsec, pac_habitacion, ;
			pac_cama, pac_categoria, ent_descrient,pac_excl,PAC_operadm ,operadmi ,   ;
			pac_sexo, pac_edad, pac_codadmision, pac_fechaadmision, ;
			pac_horaadmision, pac_codhce, afi_nroafiliado, ctod("  /  /  ") as pac_fechaalta,;
			operalta ,  pac_descripdiagn, ttoc(ctot("01/01/1900"),2) as pac_horaalta,;
			pac_domicilio,ent_codent,PAC_codhci,cob_codcontrato,nvl(tpv_estado,0) as tpv_estado  ;
			from mwkpacint where pac_fechaadmision <= mfechas;
			union select pac_nombrepaciente, sec_codsector, sec_descripsec, pac_habitacion, ;
			pac_cama, pac_categoria, ent_descrient,pac_excl,PAC_operadm , operadmi ,  ;
			pac_sexo, pac_edad, pac_codadmision, pac_fechaadmision, ;
			pac_horaadmision, pac_codhce, afi_nroafiliado, nvl(pac_fechaalta,ctod("  /  /  ")) as pac_fechaalta,;
			operalta ,  pac_descripdiagn, pac_horaalta,;
			pac_domicilio,ent_codent,PAC_codhci,cob_codcontrato,nvl(tpv_estado,0) as tpv_estado ;
			from mwkpacintt ;
			into cursor mwkpacint



mret = Sqlexec(MCON1, "select * from Habitacions","mwkHabitacions")
If mret <= 0
	Set Step On
Endif 
		
*!*	?"***********************"
&& PROCESO DE A UN PACIENTE
Select mwkpacint
Scan All

	mcodadm = Pac_codadmision
	mnompac = Pac_nombrepaciente
	mfecadm = Pac_FechaAdmision
	mfecalt = pac_fechaalta
	mhoralt = pac_horaalta

*!*		? "BUSCANDO LUGARES DE INTERNACION - CODADM: " + mcodadm

		If used('mwklugar')
			Use in mwklugar
		Endif
		mcda = mwkpacint.codadm
		mfalta = mwkpacint.PAC_fechaalta
		mfingr = mwkpacint.PAC_fechaadmision
		mret = sqlexec(mcon1,"select * from LUGARINTERN where LUG_pacientes = ?mcda","mwklugar")
		If mret > 0
			If used('mwklugar')
				If reccount('mwklugar')>0
					Select * from mwklugar where LUG_fechaingreso <= mfechas and;
						(LUG_fechaegreso >= mfecdes or isnull(LUG_fechaegreso)) into cursor mwklugar
					Select mwklugar
					Scan
						mfdesde = iif(mwklugar.LUG_fechaingreso >= mfecdes, mwklugar.LUG_fechaingreso, mfecdes)
						mfhasta = iif(mwklugar.LUG_fechaegreso <= mfechas, mwklugar.LUG_fechaegreso, mfechas)
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
						If  !mobito and mfalta <= mfechas and mfalta # mfingr 
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


	mret =  Sqlexec(MCON1, "SELECT * FROM LUGARINTERN WHERE lug_pacientes = ?mcodadm " + ;
		" and Lug_FechaIngreso >= ?mfechaIni and Lug_Fechaegreso <= ?mfecalt ", "mwkLugInt")

	If mret <= 0
		Set Step On
	Endif 

*!*		PASO LUGARINT A DATETIME PARA BUSQUEDA
	lnCant = Reccount("mwkLugInt") 
	mhoraant = ""

	Select mwkLugInt
	Scan All 
		Skip
		mhoraant = Substr(Ttoc(mwkLugInt.Lug_HoraIngreso),12)
		Skip -1
		If lnCant <> Recno()
			If Not Empty(mhoraant)
				Replace lug_horaegreso With Ctot(Dtoc(mwkLugInt.Lug_FechaEgreso) + " " + mhoraant)
			Endif 	
		Else
			Replace lug_horaegreso With Ctot(Dtoc(mwkLugInt.Lug_FechaEgreso) + " " + Substr(Ttoc(mhoralt),12)) 
		Endif   	

		Replace lug_horaingreso With Ctot(Dtoc(mwkLugInt.Lug_FechaIngreso) + " " + Substr(Ttoc(mwkLugInt.Lug_HoraIngreso),12)) 
			
		Select mwkLugInt
	Endscan 	

&& PROCESANDO LAS FECHAS DESDE LA ADMISION DEL PACIENTE
	For I = 0 To mfechaFin-mfecadm
		
		mfechaT = Dtot(mfecadm + I)
		mfechaC = Dtoc(mfecadm + I)
		mfechaD = mfecadm + I		
		
*!*			?"FECHA: " + mfechaC
		
		mFechaT1 = mfechaT + 1
		
		Select mwkLugInt && BUSQUEDA DE 10:00 PARA UNA FECHA
		Locate For Between(Ctot(mfechaC + " 10:00:00"),lug_horaingreso,lug_horaegreso)
		If Found()
			Select mwkHistOcup 
			Locate For mwkHistOcup.sector = mwkLugInt.Lug_CodSector And mwkHistOcup.hora = 1000 And mwkHistOcup.fecha = mfechaD
			If Found()
				Select mwkHistOcup
				replace CamasOcup With CamasOcup + 1 
				If mwkPac.pac_categoria = "A" Or mwkPac.pac_categoria = "I"
					
					Select * ;
						From mwkHabitacions ;
						Where mwkHabitacions.hab_sectores = mwkLugInt.Lug_CodSector and ;
							mwkHabitacions.hab_codhabitacion = mwkLugInt.lug_habitacion ;
							Into Cursor mwkdatcam
					
					If _Tally > 1		&& SI ES SOLO UNA CAMA NO DESCUENTO	
						Select mwkHistOcup
						replace camaslibres With camaslibres - 1 
					Endif 	
				Endif 
			Endif 
		Endif 

		Select mwkLugInt && BUSQUEDA DE 16:00 PARA UNA FECHA
		Locate For Between(Ctot(mfechaC + " 16:00:00"),lug_horaingreso,lug_horaegreso)  
		If Found()
			Select mwkHistOcup
			Locate For mwkHistOcup.sector = mwkLugInt.Lug_CodSector And mwkHistOcup.hora = 1600 And mwkHistOcup.fecha = mfechaD
			If Found()
				Select mwkHistOcup
				replace CamasOcup With CamasOcup + 1 
				If mwkPac.pac_categoria = "A" Or mwkPac.pac_categoria = "I"
					Select * ;
						From mwkHabitacions ;
						Where mwkHabitacions.hab_sectores = mwkLugInt.Lug_CodSector and ;
							mwkHabitacions.hab_codhabitacion = mwkLugInt.lug_habitacion ;
							Into Cursor mwkdatcam
					
					If _Tally > 1	&& SI ES SOLO UNA CAMA NO DESCUENTO	
						Select mwkHistOcup
						replace camaslibres With camaslibres - 1 
					Endif 	
				Endif 
			Endif 
		Endif 

		If mwkpac.pac_fechaalta =< mfechaT && SOLO HASTA LA FECHA DE ALTA 
			Exit
		Endif 	
	Next 
		
	Select mwkPac
Endscan 	

*!*	SACO DEL TOTAL DE CAMAS X SECTOR LAS DE BLOQUEO Y RESERV
Select Count(*) as Total, mwkHabitacions.hab_sectores ;
	From mwkHabitacions ;
	Where hab_codpaciente <> "BLOQUEO" and ;
		hab_codpaciente <> "RESERV" ;
		Group By mwkHabitacions.hab_sectores ;
		Into Cursor mwkTCamasxSect


Select mwkHistOcup.*, mwkTCamasxSect.Total ;
	From mwkHistOcup ;
	Left Join mwkTCamasxSect On mwkTCamasxSect.hab_sectores = mwkHistOcup.sector ;
	Into Cursor mwkResult
	
&&&&&&&&&&&& ACTUALIZACION
*!*		
*!*	Select mwkResult
*!*	Scan All
*!*		mlibres = mwkResult.CamasLibres
*!*		mOcupa  = mwkResult.camasocup
*!*		mTotal  = mwkResult.Total
*!*		
*!*		mResu   = mTotal + mlibres  &&&&&&&&&&&& CONTROLAR MRESU
*!*		
*!*		mret = Sqlexec(mcon1,"Update TabHistOcup Set camaslibres = ?mResu, camasocup = ?mOcupa Where TabHistOcup.Id = mwkResult.Id")
*!*		
*!*		If mret <= 0
*!*			Set Step On
*!*		Endif 
*!*		Select mwkResult
*!*	Endscan 	

?Sqldisconnect(MCON1)
Release MCON1




Return 



