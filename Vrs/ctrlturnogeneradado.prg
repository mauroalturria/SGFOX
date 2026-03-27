Use In Select('reser')
Use In Select('turnomal')
Select Diasem,codesp, codmed,TipoTurno,;
	Strtran(Left(Ttoc(HoraDesde,2),5),':','') As hd, Strtran(Left(Ttoc(HoraHasta,2),5),':','') As hh,;
	Strtran(Left(Ttoc(HorarDesde ,2),5),':','') As hrd, Strtran(Left(Ttoc(HoraRHasta,2),5),':','') As hrh,;
	Strtran(Left(Ttoc(HoraRes1,2),5),':','') As hr1, Strtran(Left(Ttoc(HoraRes2,2),5),':','') As hr2,;
	Strtran(Left(Ttoc(HoraRes3,2),5),':','') As hr3, Strtran(Left(Ttoc(HoraRes4,2),5),':','') As hr4,;
	Strtran(Left(Ttoc(HoraRes5,2),5),':','') As hr5, Strtran(Left(Ttoc(HoraRes6,2),5),':','') As hr6,0 As cambio;
	FROM Tabreservados Where Nvl(codmed,1)>1 Order By codmed,Diasem,hrd,hd Into Cursor Reser Readwrite
a=0
b=0
c=0
d=0
e=0
F=0
Select Reser
Scan
	midia = Reser.Diasem
	mimed = Reser.codmed
	mitipo = Reser.TipoTurno
	Do Case
	Case  Val(Nvl(Reser.hr1,''))>0

		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur=Val(Reser.hr1) And TipoTurno = mitipo Into Cursor controla

		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur=Val(Reser.hr1)   Into Cursor controlad
		If Reccount('controlad')>Reccount('controla')
			If a=0
				Set Step On
				a=a+1
			Endif
			If Used('turnomal')
				Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
			Else
				Select * From controlad Where afiliado>1 Into Cursor turnomal
			Endif
			Select Reser
			Replace cambio With 1
			Update turnoid Set TipoTurno = mitipo  Where Id In (Select Id From controlad)

		Endif
		If  Val(Nvl(Reser.hr2,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reser.hr2) And TipoTurno = mitipo Into Cursor controla

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reser.hr2)   Into Cursor controlad
			If  Reccount('controlad')>Reccount('controla')
*	Set Step On
				If b=0
					Set Step On
					b=b+1
				Endif
				If Used('turnomal')
					Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
				Else
					Select * From controlad Where afiliado>1 Into Cursor turnomal
				Endif
				Select Reser
				Replace cambio With 1
				Update turnoid Set TipoTurno = mitipo  Where Id In (Select Id From controlad)
			Endif
		Endif
		If  Val(Nvl(Reser.hr3,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reser.hr3) And TipoTurno = mitipo Into Cursor controla

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reser.hr3)  Into Cursor controlad
			If  Reccount('controlad')>Reccount('controla')
				Select Reser
				Replace cambio With 1
*	Set Step On
				If c=0
					Set Step On
					c=c+1
				Endif
				If Used('turnomal')
					Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
				Else
					Select * From controlad Where afiliado>1 Into Cursor turnomal
				Endif
				Update turnoid Set TipoTurno = mitipo  Where Id In (Select Id From controlad)
			Endif
		ENDIF
			If  Val(Nvl(Reser.hr4,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reser.hr4) And TipoTurno = mitipo Into Cursor controla

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reser.hr4)  Into Cursor controlad
			If  Reccount('controlad')>Reccount('controla')
				Select Reser
				Replace cambio With 1
*	Set Step On
				If f=0
					Set Step On
					f=f+1
				Endif
				If Used('turnomal')
					Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
				Else
					Select * From controlad Where afiliado>1 Into Cursor turnomal
				Endif
				Update turnoid Set TipoTurno = mitipo  Where Id In (Select Id From controlad)
			Endif
		Endif

	Case  Val(Nvl(Reser.hrd,''))>0
		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			BETWEEN(hhmmtur,Val(Reser.hrd),Val(Reser.hrh)) And TipoTurno = mitipo Into Cursor controla

		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur>=Val(Reser.hrd) And hhmmtur<Val(Reser.hrh)   Into Cursor controlad

		If  Reccount('controlad')>Reccount('controla')
*	Set Step On
			If d=0
				Set Step On
				d=d+1
			Endif
			If Used('turnomal')
				Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
			Else
				Select * From controlad Where afiliado>1 Into Cursor turnomal
			Endif
			Select Reser
			Replace cambio With 1
			Update turnoid Set TipoTurno = mitipo  Where Id In (Select Id From controlad)
		Endif

	Case Val(Nvl(Reser.hd,''))>0
		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			BETWEEN(hhmmtur,Val(Reser.hd),Val(Reser.hh)) And TipoTurno = mitipo Into Cursor controla

		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur>=Val(Reser.hd) And hhmmtur<Val(Reser.hh)    Into Cursor controlad
		If  Reccount('controlad')>Reccount('controla')
			Select Reser
			Replace cambio With 1
			If Used('turnomal')
				Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
			Else
				Select * From controlad Where afiliado>1 Into Cursor turnomal
			Endif
			If e=0
				Set Step On
				e=e+1
			Endif
*	Set Step On
			Update turnoid Set TipoTurno = mitipo  Where Id In (Select Id From controlad)
		Endif


	Endcase
Endscan
