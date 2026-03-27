Select * From b_turno Group By codambito,codmed,fechatur Into Cursor arreglo
*!*	Do sp_busco_estados With 109," and tipo = 1 order by subestado ","mwkttporc"
If Vartype(vr_ctipo)<>"C"
	vr_ctipo = ' and turnos.tipoturno in (0 ) '
Endif
Select arreglo
Set Step On
i=0
Scan

	mimed = codmed
	mifec = fechatur
	miamb = codambito
	Wait Windows Transform(Recno())+Transform(mimed)+Transform(mifec) Nowait

	Requery('b_turnoid')
	SELECT * from b_turnoid WHERE tipoturno =16 INTO CURSOR mwkyaesta
	mispe1 = Ceiling(Reccount('b_turnoid')*.3)
*	mispe2 = Ceiling(Reccount('b_turnoid')*.1)
	If Reccount('b_turnoid')>2 AND RECCOUNT('mwkyaesta')=0
		i=i+1
		Select b_turnoid
		If Mod(i,2)=0
			Go Top
			mipe1 = 0
			mipe2 = 0
			mipe3 = 0
			Do While !Eof() And mimed = codmed And mifec = fechatur
				If mipe1<mispe1 And  mimed = codmed And mifec = fechatur
					Replace tipoturno With 16
					mipe1 = mipe1+1
					Skip
				Else
					Skip
					If mimed = codmed And mifec = fechatur
*!*						If mipe2<mispe2 And  mimed = codmed And mifec = fechatur
*!*							Replace tipoturno With 5
*!*							mipe2 = mipe2+1
*!*							Skip
*!*						Else
*!*							If mimed = codmed And mifec = fechatur
*!*								If mipe3<mispe2 And  mimed = codmed And mifec = fechatur
*!*									Replace tipoturno With 16
*!*									mipe3 = mipe3+1
*!*									Skip
*!*								Else
*!*									Skip
*!*								Endif
*!*							Endif
*!*						Endif
					Endif
				Endif
			Enddo
		Else
			Go Bottom
			mipe1 = 0
			mipe2 = 0
			mipe3 = 0
			Do While !Bof() And mimed = codmed And mifec = fechatur
				If mipe1<mispe1 And  mimed = codmed And mifec = fechatur
					Replace tipoturno With 16
					mipe1 = mipe1+1
					Skip -1
				Else
					Skip -1
*!*
*!*					If mimed = codmed And mifec = fechatur
*!*						If mipe2<mispe2 And  mimed = codmed And mifec = fechatur
*!*							Replace tipoturno With 5
*!*							mipe2 = mipe2+1
*!*							Skip -1
*!*						Else
*!*							If mimed = codmed And mifec = fechatur
*!*								If mipe3<mispe2 And  mimed = codmed And mifec = fechatur
*!*									Replace tipoturno With 16
*!*									mipe3 = mipe3+1
*!*									Skip -1
*!*								Else
*!*									Skip -1
*!*								Endif
*!*							Endif
*!*						Endif
*!*					Endif
				Endif
			Enddo

		Endif
	Endif
	Select arreglo
Endscan
