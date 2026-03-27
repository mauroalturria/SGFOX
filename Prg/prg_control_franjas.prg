Do sp_conexion

*mcon1 = SqlConnect("REAL_172_16_1_2")

mfecVigen = sp_Busco_fecha_serv('DD')

if used("mwkCtrl_Fran")
	use in mwkCtrl_Fran
endif	

Do sp_medicos

Select Mwkmedico
Scan All

 	mCodMed = Mwkmedico.id
	mbuscom = " and prestadores.id = " + transf( mcodmed, "9999" ) + " "
	do sp_busco_medprestam with mfecVigen, mbuscom 

	 if Reccount("mwkMPfecha") <= 1
	 	Select Mwkmedico
	 	Loop
	 Endif 
	
	Select Count(*) as cant, diasem, Duracion, sala ;
		from mwkMPfecha ;
		group by diasem, Duracion, sala ;
		Having Cant > 1 ;
		into cursor mwkControl1
	
	If Reccount("mwkControl1") = 0
	 	Select Mwkmedico
	 	Loop
	Endif 

	Select mwkMPfecha.Id, mwkMPfecha.DiaSem, mwkMPfecha.Duracion, ;
		mwkMPfecha.hhmmdes, mwkMPfecha.hhmmhas, mwkMPfecha.sala, fecvigend, fecvigenh ;
		from mwkMPfecha, mwkControl1 ;
		Where mwkMPfecha.diasem = mwkControl1.Diasem and  ;
		mwkMPfecha.Duracion = mwkControl1.Duracion ;
		Order by mwkMPfecha.sala, mwkMPfecha.hhmmdes, mwkMPfecha.hhmmhas  ;
		into cursor mwkControl2
	
	Use in mwkControl1

	If Used("mwkCtrl_Fran")

		Select mCodMed as codmed, Mwkmedico.nombre as nombre, a.*, ;
			b.Id as bId, b.Hhmmdes as bHhmmdes, b.Hhmmhas as bHhmmhas, ;
			b.fecvigend as bfecvigend, b.fecvigenh as bfecvigenh ;
			from mwkControl2 a, mwkControl2 b ;
			where a.Hhmmhas = b.Hhmmdes and ;
			a.DiaSem = b.DiaSem and ;
			a.Duracion = b.Duracion and ;
			a.Sala = b.Sala ;
			into cursor mwkControl3
		
		Select mwkCtrl_Fran
		Append from dbf("mwkControl3")

		use in mwkControl3	
	Else
		Select mCodMed as codmed, Mwkmedico.nombre as nombre, a.*, ;
			b.Id as bId, b.Hhmmdes as bHhmmdes, b.Hhmmhas as bHhmmhas, ;
			b.fecvigend as bfecvigend, b.fecvigenh as bfecvigenh ;
			from mwkControl2 a, mwkControl2 b ;
			where a.Hhmmhas = b.Hhmmdes and ;
			a.DiaSem = b.DiaSem and ;
			a.Duracion = b.Duracion and ;
			a.Sala = b.Sala ;
			into cursor mwkControl3
		
		Use dbf("mwkControl3") again alias mwkCtrl_Fran in 0
		use in mwkControl3	

	Endif 
	
	Use in mwkControl2

	Select Mwkmedico
EndScan

Use in Mwkmedico

Select Distinct nombre, DiaSem, Sala, duracion, ;
	hhmmdes, hhmmhas, fecvigend, iif(fecvigenh = ctod("01/01/2100"),ctod(""),fecvigenh) as fecvigenh, ;
	bhhmmdes, bhhmmhas, bfecvigend, iif(bfecvigenh = ctod("01/01/2100"),ctod(""),bfecvigenh) as bfecvigenh, ;
	iif(diasem = 2,'Lun',iif(diasem = 3,'Mar',;
	iif(diasem = 4,'Mie',iif(diasem = 5,'Jue',;
	iif(diasem = 6,'Vie',iif(diasem = 7, 'Sab', 'Dom')))))) as semana ;
	from mwkCtrl_Fran ;
	Order by nombre, Semana, Sala, duracion, hhmmdes, hhmmhas, fecvigend ;
	into cursor mwkListado

Use in mwkCtrl_Fran

Select mwkListado
do Buscadatos With "X"

Do sp_desconexion


*--------------------------------------------------------------------------------------
Procedure Buscadatos
lparameters mOpcion
*--------------------------------------------------------------------------------------
mcPathAct   = allt(sys(5))+sys(2003)
mcDir_Docs  = "C:\TempDoc\"
mwkopoffice = "mwkoffice_1"

If !Used("mwkListado")
	Return .f.
Endif 

	do while .t.

		if !reccount('mwkListado') > 0
			messagebox("NO HAY INFORMACION DISPONIBLE", 48,"Validación")
			exit
		endif

		do case
		
			case mOpcion = "O"

				do sp_control_aplicacion with "OpenOffice.org Calc"
				OOFICCE = newobject("cusopenoffice", "LIB_OPENOFFICE.VCX")
				if !OOFICCE.oooisinstalled()
					messagebox("No esta instalado el Open Office",48,"Validación")
					Exit
				endif

				copy file (alltrim(zzvolumen) + "\qepd1a1\xlt\ctrlfranjascont.XLT")to (mcDir_Docs + "ctrlfranjascont.XLT")
				OOFICCE.OOoOpenFile(mcDir_Docs + "ctrlfranjascont.XLT")
				OOFICCE.ActivoSheet()

				OOFICCE.Setvalue(3,2," Período : " + dtoc(mfecVigen ))

				i = 6

				select mwkListado
				scan
					wait "CARGANDO PLANILLA DE EXCEL"  + str(recno(), 5) windows nowait
					mian = alltrim(str(i,5,0))


					OOFICCE.Setvalue(i,2, alltrim(mwkListado.Nombre))
					OOFICCE.Setvalue(i,3, alltrim(mwkListado.Semana))
					OOFICCE.Setvalue(i,4, alltrim(mwkListado.Sala))
					OOFICCE.Setvalue(i,5, Substr(Ttoc(mwkListado.Duracion),11))
					lcDesde = padl(alltrim(Str(mwkListado.hhmmdes,4)),4,"0")
					OOFICCE.Setvalue(i,6, Substr(lcDesde,1,2) + ":" + Substr(lcDesde,3))
					lcHasta = padl(alltrim(Str(mwkListado.hhmmhas,4)),4,"0")
					OOFICCE.Setvalue(i,7, Substr(lcHasta,1,2) + ":" + Substr(lcHasta,3))
					OOFICCE.Setvalue(i,8, mwkListado.fecvigend)
					if !Empty(mwkListado.fecvigenh)
						OOFICCE.Setvalue(i,9, mwkListado.fecvigenh)
					Endif 	
					&&
					lcDesde = padl(alltrim(Str(mwkListado.bhhmmdes,4)),4,"0")
					OOFICCE.Setvalue(i,10,  Substr(lcDesde,1,2) + ":" + Substr(lcDesde,3))
					lcHasta = padl(alltrim(Str(mwkListado.bhhmmhas,4)),4,"0")
					OOFICCE.Setvalue(i,11, Substr(lcHasta,1,2) + ":" + Substr(lcHasta,3))
					OOFICCE.Setvalue(i,12, mwkListado.bfecvigend)
					if !Empty(mwkListado.bfecvigenh)
						OOFICCE.Setvalue(i,13, mwkListado.bfecvigenh)
					Endif 	

					i = i + 1
					select mwkListado
				endscan

				OOFICCE.activocell(6,2)

				wait clear

			case mOpcion = "X"

				lcErrorAnt = ON("ERROR")
				ON ERROR *
							
				do sp_control_aplicacion with "Microsoft Excel"
				oleapp = createobject("excel.application")

				ON ERROR &lcErrorAnt
				IF VARTYPE(oleapp) <> "O" 
					mOpcion = "O"
					Loop					
				Endif 

				oleapp.workbooks.open(alltrim(zzvolumen) + "\qepd1a1\xlt\ctrlfranjascont.xlt")

				oleapp.cells(3,2).Value = " Período : " + dtoc(mfecVigen) 
				
				i = 6
				mrecno = 1
				select mwkListado
				go top

				scan All

					wait "CARGANDO PLANILLA DE EXCEL"  + str(mrecno, 5) windows nowait
					oleapp.cells(i,2).value = mwkListado.Nombre
					oleapp.cells(i,3).value = mwkListado.Semana
					oleapp.cells(i,4).value = mwkListado.Sala
					oleapp.cells(i,5).value = Substr(Ttoc(mwkListado.Duracion),11)

					lcDesde = padl(alltrim(Str(mwkListado.hhmmdes,4)),4,"0")
					oleapp.cells(i,6).value = Substr(lcDesde,1,2) + ":" + Substr(lcDesde,3)
					lcHasta = padl(alltrim(Str(mwkListado.hhmmhas,4)),4,"0")
					oleapp.cells(i,7).value = Substr(lcHasta,1,2) + ":" + Substr(lcHasta,3)
					oleapp.cells(i,8).value = mwkListado.fecvigend
					if !Empty(mwkListado.fecvigenh)
						oleapp.cells(i,9).value = mwkListado.fecvigenh
					Endif 	
					&&
					lcDesde = padl(alltrim(Str(mwkListado.bhhmmdes,4)),4,"0")
					oleapp.cells(i,10).value = Substr(lcDesde,1,2) + ":" + Substr(lcDesde,3)
					lcHasta = padl(alltrim(Str(mwkListado.bhhmmhas,4)),4,"0")
					oleapp.cells(i,11).value = Substr(lcHasta,1,2) + ":" + Substr(lcHasta,3)
					oleapp.cells(i,12).value = mwkListado.bfecvigend
					if !Empty(mwkListado.bfecvigenh)
						oleapp.cells(i,13).value = mwkListado.bfecvigenh
					Endif 	

					i = i + 1
					mrecno = mrecno + 1
					select mwkListado
				endscan
				wait clear
				oleapp.cells(6,1).select
				oleapp.visible = .t.
		endcase
		exit
	enddo
*--------------------------------------------------------------------------------------