Select * From cambio  Group By codmed,fechatur Into Cursor arreglo
Do sp_busco_estados With 109," and tipo = 1 order by subestado desc ","mwkttporc"
If Vartype(nrandom )<>"N"
	nrandom  =0
Endif
If Vartype(vr_ctipo)<>"C"
	vr_ctipo = ' and LEFT(observa,1)= "&"  '
Endif
Select arreglo
Set Step On
i=0
Scan
	i=i+1
	mimed = codmed
	mifec = fechatur
	Wait Windows Transform(Recno())+Transform(mimed)+Transform(mifec) Nowait

	Select mwkttporc
	Go Top
	Scan
		vr_porc = mwkttporc.subestado
		vr_tipo = mwkttporc.estado
		Requery('turnoidm')
		Select * From turnoidm  Into Cursor turnoidmn
		Select * From turnoidm Where tipoturno=vr_tipo  Into Cursor hayturno
		
			Update turnoidm Set tipoturno = 0
			Select turnoidm
			Go Top
	 
		Select * From turnoidm  Into Cursor turnoidmn
		mispe1 = Round(Reccount('turnoidmn') * vr_porc/100,0)
*	If Reccount('turnoidmn')>2
		Select turnoidmn
		If Mod(i,2)=0
			Go Top
			mipe1 = 0
			mipe2 = 0
			mipe3 = 0
			Do While !Eof() And mimed = codmed And mifec = fechatur
				If mipe1<mispe1 And  mimed = codmed And mifec = fechatur
					mid = turnoidmn.Id
					Requery('turnoid')
					Update turnoid Set  tipoturno= vr_tipo
					Requery('turnoid')
					mipe1 = mipe1+1
					Skip
				Else
					Skip
					If mimed = codmed And mifec = fechatur
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
					mid = turnoidmn.Id
					Requery('turnoid')
					Update turnoid Set  tipoturno= vr_tipo
					Requery('turnoid')
					mipe1 = mipe1+1
					Skip -1
				Else
					Skip -1

				Endif
			Enddo

		Endif
*Endif
	Endscan
	Select arreglo
Endscan
