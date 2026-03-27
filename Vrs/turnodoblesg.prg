
mcon1 = SQLConnect("conec01")
Set ENGINEBEHAVIOR 70
*!*	*USE b_turno_doble AGAIN IN 0
*!*	mret = SQLExec(mcon1, "SELECT Turnos.ID, afiliado, codreserva, fechatomado,"+;
*!*		" fechatur, hhmmTur, usuario, codent, codesp, codprest, codserv, tipotomado,"+;
*!*		" usuario, Prestacions.PRE_descriprest, Prestacions.PRE_duracion,  usuariosector, codmed"+;
*!*		" FROM Turnos INNER JOIN Prestacions   ON  codprest = PRE_codprest"+;
*!*		" WHERE  fechatur >= {fn curdate()}  AND  usuariosector <> 33 "+;
*!*		" ORDER BY codmed, horatur, codreserva ","b_turno_doble")

*!*	Select * From b_turno_doble Group By codmed,fechatur, codreserva Having Count(Id)>1 Into Cursor dobles

*!*	*SELECT * FROM b_turno_doble WHERE codreserva in (SELECT codreserva FROM dobles) AND pa_duracion <pre_duracion

Select abajar
Go Top
Do While !Eof('abajar')
	mid = Id
	CODRE=CODRESERVA
	Do While !Eof('abajar') And CODRE=CODRESERVA
		midc = Transform(Id)
		midc = Substr(midc,2)
		If Val(midc)-Val(CODRESERVA)=0
			Skip
		Else
			mid = Id
			hd = Int(hhmmtur/100)*100
			hh = (Int(hhmmtur/100)+1)*100 -1
			Requery('turno')
			If Reccount('turno')<5
				mret = SQLExec(mcon1, "Update turnos Set afiliado = 0, usuario = '', codprest = 0, UsuarioSector =0"+;
					",  codreserva = '',codent = 0, codserv = 0, codesp = ''	, tipotomado =0 Where Id =?mid")
			Else
				mret = SQLExec(mcon1, "Update turnos Set afiliado = 1, usuario = '', codprest = 0, UsuarioSector =0"+;
					",  codreserva = '',codent = 0, codserv = 0, codesp = ''	, tipotomado =0 , tipoturno = 9,"+;
					"observa ='Anulado x 5 turnos' Where Id =?mid")

			Endif
			Select abajar
			Skip
		Endif

	Enddo
Enddo

Do sp_desconexion
