If !Used('mwkprestvac')
	Do sp_busco_estados With 49,' and tipo = 3 ','mwkprestvac'&&
Endif
Select mwkprestvac
mprest = " inlist(codprest"
mprestv = " inlist(vac_codprest"
Scan
	mprest = mprest +','+Alltrim(mwkprestvac.Descrip)
	mprestv = mprestv +','+Alltrim(mwkprestvac.Descrip)
Endscan
mprest = mprest+") "
mprestv = mprestv+") "
Select * From sepresta  Where &mprest  Into Cursor mwkvacu
If Reccount('mwkvacu')>0
	mnprest = mwkvacu.codprest
	Select * From mwkprestvac Where At(Transform(mnprest), Alltrim(mwkprestvac.Descrip))>0 ;
		INTO Cursor mwkprestvaca
	Select mwkprestvaca
	mpos = 0
	Scan
		mpos = At(Transform(mnprest), Alltrim(mwkprestvaca.Descrip))
		If mpos >0
			Exit
		Endif
	Endscan
	Do sp_busco_tabvacreg With mwkbuspacie1.REG_nroregistrac
	Select * From mwkRegVac Where &mprestv  And Nvl(var_cal,0)>0  Into Cursor mwkvaccov
	Select * From mwkvaccov Where VAC_Codprest=mnprest Into Cursor mwkestavac
	If Reccount('mwkestavac')>0
		Messagebox("ESTE PACIENTE YA TIENE APLICADA LA VACUNA "+mwkestavac.Vac_descripcion+;
			CHR(13)+"VERIFIQUE CON EL PACIENTE ESTA IRREGULARIDAD "+Chr(13);
			+"NO SE DEBERIA GENERAR ESTE VALE",16,"Control de vacunacion")
		mok=1
	Endif
	If mpos = 1
		Select * From mwkvaccov Where VAC_Codprest<>mnprest Into Cursor mwkotrasvac
		If Reccount('mwkotrasvac')>0
			Messagebox("ESTE PACIENTE YA TIENE APLICADA LA VACUNA "+mwkotrasvac.Vac_descripcion+;
				CHR(13)+"VERIFIQUE CON EL PACIENTE ESTA IRREGULARIDAD "+Chr(13);
				+"NO SE DEBERIA GENERAR ESTE VALE",16,"Control de vacunacion")
			mok=1
		Endif

	Else
		If mpos>1
			If Reccount('mwkprestvaca')=1
				mprest1d = Val(Left(mwkprestvaca.Descrip,At(",",mwkprestvaca.Descrip)-1))
				Select * From mwkvaccov Where VAC_Codprest=mprest1d Into Cursor mwkvac1d
			Else
				Select mwkprestvaca
				mp1d = ' INLIST(VAC_Codprest '
				Scan
					mp1d =mp1d +','+Left(mwkprestvaca.Descrip,At(",",mwkprestvaca.Descrip)-1)
				Endscan
				mp1d =mp1d +')'
				Select * From mwkvaccov Where &mp1d  Into Cursor mwkvac1d
			Endif
			If Reccount('mwkvac1d')=0
				Messagebox("ESTE PACIENTE NO TIENE APLICADA LA PRIMER DOSIS DE ESTA VACUNA "+mwkvac1d.Vac_descripcion+;
					CHR(13)+"VERIFIQUE CON EL PACIENTE ESTA IRREGULARIDAD "+Chr(13);
					+"NO SE DEBERIA CONFIRMAR EL TURNO",16,"Control de vacunacion")
				mok=1
			Endif
		Endif
	Endif
Endif
