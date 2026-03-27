Use In Select('reserva')
Use In Select('turnomal')
Select Diasem,codesp, codmed,TipoTurno,nombre,fecvigend, fecvigenh,;
	Strtran(Left(Ttoc(HoraDesde,2),5),':','') As hd, Strtran(Left(Ttoc(HoraHasta,2),5),':','') As hh,;
	Strtran(Left(Ttoc(HorarDesde ,2),5),':','') As hrd, Strtran(Left(Ttoc(HoraRHasta,2),5),':','') As hrh,;
	Strtran(Left(Ttoc(HoraRes1,2),5),':','') As hr1, Strtran(Left(Ttoc(HoraRes2,2),5),':','') As hr2,;
	Strtran(Left(Ttoc(HoraRes3,2),5),':','') As hr3, Strtran(Left(Ttoc(HoraRes4,2),5),':','') As hr4,;
	Strtran(Left(Ttoc(HoraRes5,2),5),':','') As hr5, Strtran(Left(Ttoc(HoraRes6,2),5),':','') As hr6,;
	Strtran(Left(Ttoc(HoraRes7,2),5),':','') As hr7, Strtran(Left(Ttoc(HoraRes8,2),5),':','') As hr8,;
	Strtran(Left(Ttoc(HoraRes9,2),5),':','') As hr9, Strtran(Left(Ttoc(HoraRes10,2),5),':','') As hr10,0 As cambio;
	,grupo,liberable;
	FROM Tabreservados Where Nvl(codmed,1)>1   ;
	AND (TipoTurno = 6 Or grupo = 3) ;
	Order By codmed,Diasem,hrd,hd Into Cursor Reserva Readwrite
a=0
b=0
c=0
d=0
e=0
F=0
Select Reserva
Scan
	midia = Reserva.Diasem
	mimed = Reserva.codmed
	mitipo = Reserva.TipoTurno
	mfd= Reserva.fecvigend
	mfh = Reserva.fecvigenh
	Do Case
	Case  Val(Nvl(Reserva.hr1,''))>0

		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur=Val(Reserva.hr1) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh Into Cursor controlad
		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur=Val(reserva.hr1) AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
		If Reccount('controla')>Reccount('controlad')
			If a=0
				Set Step On
				a=a+1
			Endif
*!*				If Used('turnomal')
*!*					Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*				Else
*!*					Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*				Endif
			Select Reserva
			Replace cambio With 1
*			Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)

		Endif
		If  Val(Nvl(Reserva.hr2,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr2) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr2) AND fechatur>=mfd AND fechatur<=mfh    Into Cursor controla
			If Reccount('controla')>Reccount('controlad')

*	Set Step On
				If b=0
					Set Step On
					b=b+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				Select Reserva
				Replace cambio With 1
				*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
			Endif
		Endif
		If  Val(Nvl(Reserva.hr3,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr3) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr3) AND fechatur>=mfd AND fechatur<=mfh   Into Cursor controla
				If Reccount('controla')>Reccount('controlad')

				Select Reserva
				Replace cambio With 1
*	Set Step On
				If c=0
					Set Step On
					c=c+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
			Endif
		Endif
		If  Val(Nvl(Reserva.hr4,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr4) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh   Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr4) AND fechatur>=mfd AND fechatur<=mfh    Into Cursor controla
					If Reccount('controla')>Reccount('controlad')

				Select Reserva
				Replace cambio With 1
*	Set Step On
				If F=0
					Set Step On
					F=F+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				*Update turnoid Set observa = "~"+Alltrim(observa) Where Id In (Select Id From controlad)
			Endif
		Endif
		If  Val(Nvl(Reserva.hr5,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr5) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr5)  AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
					If Reccount('controla')>Reccount('controlad')

				Select Reserva
				Replace cambio With 1
*	Set Step On
				If c=0
					Set Step On
					c=c+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
			Endif
		Endif
		If  Val(Nvl(Reserva.hr6,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr6) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr6)  AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
				If Reccount('controla')>Reccount('controlad')

				Select Reserva
				Replace cambio With 1
*	Set Step On
				If c=0
					Set Step On
					c=c+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
			Endif
		Endif
		If  Val(Nvl(Reserva.hr7,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr7) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr7)  AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
		If Reccount('controla')>Reccount('controlad')
				Select Reserva
				Replace cambio With 1
*	Set Step On
				If c=0
					Set Step On
					c=c+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
			Endif

			If  Val(Nvl(Reserva.hr8,''))>0
				Select * From turnoid Where codmed = mimed And Diasem = midia And ;
					hhmmtur=Val(Reserva.hr8) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr8)  AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
		If Reccount('controla')>Reccount('controlad')
					Select Reserva
					Replace cambio With 1
*	Set Step On
					If c=0
						Set Step On
						c=c+1
					Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
					*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
				Endif
			Endif
		Endif
		If  Val(Nvl(Reserva.hr9,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr9) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr9)  AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
		If Reccount('controla')>Reccount('controlad')
				Select Reserva
				Replace cambio With 1
*	Set Step On
				If c=0
					Set Step On
					c=c+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
			Endif
		Endif
		If  Val(Nvl(Reserva.hr10,''))>0
			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(Reserva.hr10) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

			Select * From turnoid Where codmed = mimed And Diasem = midia And ;
				hhmmtur=Val(reserva.hr10)  AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
		If Reccount('controla')>Reccount('controlad')
				Select Reserva
				Replace cambio With 1
*	Set Step On
				If c=0
					Set Step On
					c=c+1
				Endif
*!*					If Used('turnomal')
*!*						Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Else
*!*						Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*					Endif
				*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
			Endif
		Endif
	Case  Val(Nvl(Reserva.hrd,''))>0
		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			BETWEEN(hhmmtur,Val(Reserva.hrd),Val(Reserva.hrh)) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur>=Val(reserva.hrd) And hhmmtur<Val(reserva.hrh)   AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla

		If Reccount('controla')>Reccount('controlad')
*	Set Step On
			If d=0
				Set Step On
				d=d+1
			Endif
*!*				If Used('turnomal')
*!*					Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*				Else
*!*					Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*				Endif
			Select Reserva
			Replace cambio With 1
			*Update turnoid Set observa = "~"+Alltrim(observa) Where Id In (Select Id From controlad)
		Endif

	Case Val(Nvl(Reserva.hd,''))>0
		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			BETWEEN(hhmmtur,Val(Reserva.hd),Val(Reserva.hh)) And TipoTurno = mitipo AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controlad

		Select * From turnoid Where codmed = mimed And Diasem = midia And ;
			hhmmtur>=Val(reserva.hd) And hhmmtur<Val(reserva.hh)    AND fechatur>=mfd AND fechatur<=mfh  Into Cursor controla
		If Reccount('controla')>Reccount('controlad')
			Select Reserva
			Replace cambio With 1
*!*				If Used('turnomal')
*!*					Select * From turnomal Union All Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*				Else
*!*					Select * From controlad Where afiliado>1 Into Cursor turnomal
*!*				Endif
			If e=0
				Set Step On
				e=e+1
			Endif
*	Set Step On
			*Update turnoid Set observa = "~"+Alltrim(observa)  Where Id In (Select Id From controlad)
		Endif


	Endcase
Endscan
