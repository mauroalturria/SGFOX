

Select * From medprestavac,turnos_vacunas Where medprestavac.codmed = turnos_vacunas.codmed ;
	AND medprestavac.diasem = turnos_vacunas.diasem And medprestavac.hhmmdes <= turnos_vacunas.hhmmtur ;
	AND medprestavac.hhmmhas>= turnos_vacunas.hhmmtur And medprestavac.fecvigend <= turnos_vacunas.fechatur ;
	AND medprestavac.fecvigenh>= turnos_vacunas.fechatur Order By turnos_vacunas.Id Into Cursor cambio

Select * From cambio Where Nvl(codprest_b,0)=0 And codprest_a=20024 Into Cursor dosis1
Select * From cambio Where Nvl(codprest_b,0)=0 And codprest_a=20025 Into Cursor dosis2

Select * From cambio Where Nvl(codprest_b,0)=0 And codprest_a=20026 Into Cursor dosiscov1
Select * From cambio Where Nvl(codprest_b,0)=0 And codprest_a=20027 Into Cursor dosiscov2


Select * From dosis1,dosis2 Where dosis1.id_b = dosis2.id_b
Update turnos_vacunas Set codprest = 20024 Where Id In (Select id_b From dosis1)
Update turnos_vacunas Set codprest = 20025 Where Id In (Select id_b From dosis2)
Update turnos_vacunas Set codprest = 20026 Where Id In (Select id_b From dosiscov1)
Update turnos_vacunas Set codprest = 20027 Where Id In (Select id_b From dosiscov2)

Select * From turnos_vacunas  Where Nvl(codprest,0)=0

Select docutehc
Scan
	mireg =nreg
	mient = codent
	Select turnos_vacunas
	Locate For afiliado <=1  And hhmmtur =900
	If Found()
		mid =turnos_vacunas.Id
		mcodres =   Right(Strtran(Str((mid ), 8, 0), " ", "0") + '-' + '0', 9)
		mifecha = turnos_vacunas.fechatur
		Update turnos_vacunas Set afiliado = mireg,  codent=mient,;
			codmedsoli = 306,codreserva = mcodres ,codserv=3260, fechatomado=Datetime();
			, solicigia=1,tipotomado=4, usuario='CARMENA',  usuariosector = 36 ;
			WHERE Id = mid
*	nfecha = mifecha+29
*	Locate For afiliado =1 And codprest = 20027 And fechatur>= nfecha
	Else
		Set Step On
	Endif
*!*		If Found()
*!*			mid =turnos_vacunas.Id
*!*			mcodres =   Right(Strtran(Str((mid ), 8, 0), " ", "0") + '-' + '0', 9)

*!*			Update turnos_vacunas Set afiliado = mireg,  codent=mient,;
*!*				codmedsoli = 306,codreserva = mcodres ,codserv=3260, fechatomado=Datetime();
*!*				, solicigia=1,tipotomado=4, usuario='NMORGULIS',  usuariosector = 36 ;
*!*				WHERE Id = mid
*!*		Else
*!*			Set Step On
*!*		Endif
Endscan


Update turnos_vacunas Set afiliado = 0,  codent=0,;
	codmedsoli = 0,codreserva = '' ,codserv=0, fechatomado=Datetime();
	, solicigia=0,tipotomado=0, usuario='',  usuariosector = 0 ;
	WHERE Id In (Select Id From BAJAR)
Select * From turnos_vacunas Where codprest = 20026 Into Cursor uno

Select * From turnos_vacunas Where codprest = 20026 And (fechatur>=Date() Or ;
	(fechatur<Date() And confirmado = 1)) Into Cursor uno
Select * From turnos_vacunas Where codprest = 20027 Into Cursor Dos
Select * From uno Where afiliado Not In (Select afiliado From Dos) Into Cursor nuevos

Select * From Dos Where afiliado Not In (Select afiliado From uno) Into Cursor malto


Select nuevos
Set Step On
Scan
	mireg = afiliado
	mient = codent
	Select turnos_vacunas
	Locate For afiliado = mireg  And codprest = 20026
	If Found()
		mifecha = turnos_vacunas.fechatur
		miusu = usuario
		mihora = hhmmtur
		nfecha = mifecha+29
		Locate For afiliado = 0 And codprest = 20027 And fechatur>= nfecha And hhmmtur>=mihora
	Else
		Set Step On
	Endif
	If !Found()
		nfecha = mifecha+28
		Locate For afiliado = 0 And codprest = 20027 And fechatur>= nfecha  And hhmmtur>=mihora
	Endif
	If  Found()
		mid =turnos_vacunas.Id
		mcodres =   Right(Strtran(Str((mid ), 8, 0), " ", "0") + '-' + '0', 9)

		Update turnos_vacunas Set afiliado = mireg,  codent=mient,;
			codmedsoli = 306,codreserva = mcodres ,codserv=3260, fechatomado=Datetime();
			, solicigia=1,tipotomado=4, usuario=miusu ,  usuariosector = 36 ;
			WHERE Id = mid
	Else
		Set Step On
	Endif
Endscan
Select * From turnos_vacunas Where codprest = 20024 Into Cursor uno
Select * From turnos_vacunas Where codprest = 20025 Into Cursor Dos
Select * From uno Where afiliado In (Select afiliado From Dos) Into Cursor dosturnos

Select * From turnos_vacunas Where afiliado Not In (Select afiliado From dosturnos) Into Cursor unturno


Use c:\desaguemes\docutehc.Dbf In 0 Exclusive
Use c:\desaguemes\vacu.Dbf In 0 Exclusive
Select docutehc
Zap
Pack
Set Step On
Append From Dbf('vacu')

Select docutehc
Set Step On
Scan
	mnrodoc= Docu
IF docutehc.nreg = 0
	Requery('afiliados')
	mireg = afiliados.REG_nroregistrac
	mient = afiliados.AFI_codentidad
	Select docutehc
	Replace codent With mient,nreg With mireg
	endif
Endscan

Select docutehc
Set Step On
Scan
	mireg =nreg
	mient = codent
	mifecha = fecha
	mihora = hora
	ncodprest =   20024
	Select turnos_vacunas
	Locate For afiliado <=1  And hhmmtur >=mihora And fechatur = mifecha
	If Found()
		mid =turnos_vacunas.Id
		mcodres =   Right(Strtran(Str((mid ), 8, 0), " ", "0") + '-' + '0', 9)
		mifecha = turnos_vacunas.fechatur
		Update turnos_vacunas Set afiliado = mireg,  codent=mient,codprest = ncodprest,;
			codmedsoli = 306,codreserva = mcodres ,codserv=3260, fechatomado=Datetime();
			, solicigia=1,tipotomado=4, usuario='WHATSAPP',  usuariosector = 36 ;
			WHERE Id = mid
*	nfecha = mifecha+29
*	Locate For afiliado =1 And codprest = 20027 And fechatur>= nfecha
	Else
		Set Step On
	Endif

ENDSCAN



Select * From medprestabk,turno Where medprestabk.codmed = turno.codmed ;
	AND medprestabk.diasem = turno.diasem And medprestabk.hhmmdes <= turno.hhmmtur ;
	AND medprestabk.hhmmhas>= turno.hhmmtur And medprestabk.fecvigend <= turno.fechatur ;
	AND medprestabk.fecvigenh>= turno.fechatur group By turno.Id Into Cursor cambio
	
Update turno  Set afiliado = 0 Where Id In (Select id_b From cambio)



Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And BETWEEN(medprestabk.hhmmdes,franjadrive.hhmmdes,franjadrive.hhmmhas);
	AND BETWEEN(medprestabk.hhmmhas,franjadrive.hhmmdes,franjadrive.hhmmhas);
	GROUP BY medprestabk.id Into Cursor cambio