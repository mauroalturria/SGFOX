
clear
Set Escape On

Public MCON1
MCON1 =Sqlconnect("172.16.1.2") && VER EN NOMBRE DE TU CONEXION

Set Step On 

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
*!*	mfechaFin = mfechaIni + 1 &&&&&&&&& SACAR PARA EL PROCESO FINAL

*!*	?"BUSCANDO PACIENTES ENTRE FECHAS "

*!*	mret =  Sqlexec(MCON1, "SELECT * FROM PACIENTES " + ;
*!*		"WHERE PAC_FECHAADMISION BETWEEN ?mfechaIni and ?mfechaFin and PAC_tipopac < 2", "mwkPac")
*!*	If mret <= 0
*!*		Set Step On
*!*	Endif
*------------------------------
*------------------------------
*------------------------------
&& PACIENTES INTERNADOS
mret = sqlexec(mcon1,"select PAC_codadmision as codadm, "+;
	"PAC_motivoalta,PAC_fechaalta,PAC_fechaadmision,PAC_horaalta, pac_categoria  "+;
	" from PACINTERNAD "+;
	" Inner Join Pacientes on pac_codadmision = PIN_codadmision " + ;
	" order by PIN_codadmision","mwkpacint1")

If mret < 0
	Messagebox("EN CONSULTA DE PACIENTES INTERNADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

&& PACIENTES 
mret = sqlexec(mcon1,"select PAC_codadmision as codadm, "+;
	"PAC_motivoalta,PAC_fechaalta,PAC_fechaadmision,PAC_horaalta, pac_categoria  "+;
	" from pacientes "+;
	" where "+;
	" PAC_tipopac = 1 and" +;
	" PAC_fechaalta >= ?mfechaIni  and" +;
	" PAC_fechaadmision <= ?mfechaFin","mwkpacint0")
	
If mret < 0
	Messagebox("EN CONSULTA DE PACIENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif
&& 

If used('mwkpacint')
	Use in mwkpacint
Endif

Select Codadm, Pac_motivoalta, Date() as Pac_fechaalta, ;
	Pac_fechaadmision, Datetime() as Pac_horaalta, Pac_categoria ;
	from mwkpacint1 ;
	union ;
	select * ;
	from mwkpacint0 ;
	group by codadm ;
	into cursor mwkPac


*------------------------------
*------------------------------
*------------------------------
*------------------------------


 
*!*	**************************
*!*	? "BUSCANDO HABITACIONES "

mret = Sqlexec(MCON1, "select * from Habitacions","mwkHabitacions")
If mret <= 0
	Set Step On
Endif 
		
*!*	?"***********************"
&& PROCESO DE A UN PACIENTE
Select mwkPac
Scan All

	mcodadm = codadm && Pac_codadmision
*	mnompac = Pac_nombrepaciente
	mfecadm = Pac_FechaAdmision
	mfecalt = pac_fechaalta
	mhoralt = pac_horaalta

*!*		? "BUSCANDO LUGARES DE INTERNACION - CODADM: " + mcodadm

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



