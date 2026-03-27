************
*   grabacion de programa de medicamentos
**********

Lparameters midevolhce,mievol,mabm
mabm = Iif(Vartype(mabm)#"N",1,mabm )
If mabm = 0
	mievol = "Medicación " + Chr(13)
Endif
If myip='172.16.1.7'
	Set Step On
Endif
If Reccount('mwkcuiconf')>0
	mfechoy = sp_busco_fecha_serv("DT")
	If  Used('mwkusuarios')
		midusu = mwkusuarios.Id
		mnom = mwkusuarios.nomape
	Else
		midusu = mwkusuario.Id
		mnom = mwkusuario.nomape
	Endif
	Select mwkcuiconf
	Scan
		If idsol>0
			minsu = idins
			midsol = idsol
			mobserva = Left(Alltrim(via)+" "+Alltrim(guia)+" "+Alltrim(dosis)+" "+Alltrim(velocidad),250)
			miest = 1
			If mabm = 1
				Select medica,dosis From mwkcuisue Where idsol = midsol And cest<>"S" And sel = 0 And !habil Into Cursor mwkagregados  &&
				Select mwkagregados
				Scan
					mobserva  = Alltrim(mobserva) +"+"+  Alltrim(medica)
				Endscan
				mobserva  = Left(mobserva ,250)

				mret = SQLExec(mcon1, "insert into TabIntCuiIns " + ;
					"(ICI_detalle,ICI_fechaHora,ICI_idevol,ICI_insumo,ICI_usuario,ICI_idsol )"+;
					" values (?mobserva, ?mfechoy , ?midevolhce,?minsu ,?midusu,?midsol )")
			Else
				mobserva  = Alltrim(medica)+" " +mobserva
				Select medica,dosis From mwkcuisue Where idsol = midsol And cest<>"S" And sel = 0 Into Cursor mwkagregados  &&
				Select mwkagregados
				mobserva  = mobserva +  Chr(10)+ Iif(Reccount()>0,"AGREGADOS"+  Chr(10),'')
				Scan
					mobserva  = mobserva +  Alltrim(medica)+ " Dosis "+Alltrim(dosis)+Chr(10)
				Endscan
				mievol = mievol + mobserva +Chr(10)
			Endif
		Else
			minsu = idins
			mobserva = Left(Alltrim(via)+" "+Alltrim(dosis),250)
			miest = 1
			If mabm = 1
				mret = SQLExec(mcon1, "insert into TabIntCuiIns " + ;
					"(ICI_detalle,ICI_fechaHora,ICI_idevol,ICI_insumo,ICI_usuario,ICI_idsol )"+;
					" values (?mobserva, ?mfechoy , ?midevolhce, ?minsu ,?midusu,?midsol )")
				If mret < 0
					mret=Aerr(eros)
					Messagebox(eros(3),"Validacion")
				Endif
			Else
				mobserva  = Alltrim(medica)+" " +mobserva
				mievol = mievol + mobserva +Chr(10)
			Endif
		Endif
	Endscan
Endif

