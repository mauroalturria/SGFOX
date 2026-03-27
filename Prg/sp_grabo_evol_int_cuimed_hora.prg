************
*   grabacion de programa de medicamentos
**********
Lparameters midevolhce,mievol,mabm
mabm = Iif(Vartype(mabm)#"N",1,mabm )
If mabm = 0
	mievol = "Medicación " + Chr(13)
Endif

mfechoy = sp_busco_fecha_serv("DT")
If  Used('mwkusuarios')
	midusu = mwkusuarios.Id
	mcidusuario = mwkusuarios.idusuario
	mnom = mwkusuarios.nomape
Else
	midusu = mwkusuario.Id
	mcidusuario = mwkusuario.idusuario
	mnom = mwkusuario.nomape
Endif
If Reccount('mwkcuiconf')>0
	Select mwkcuiconf
	Scan

		If cest<>"S"
			midsol = idsol
			minsu = idins
			mdosis = Left(Alltrim(via)+" "+Alltrim(dosis),250)
			miest = 1
			For xih = 0 To 20 Step 2
				mcpo = "a"+Transform(xih,"@L 99")
				If &mcpo  = 1
					mhora = xih
					If abs(mhora-mwkcuiconf.horaini)=	1
						mhora =mwkcuiconf.horaini
					Endif

					If mabm = 1
						mret = SQLExec(mcon1, "insert into TabIntCuiIns " + ;
							"(ICI_detalle,ICI_fechaHora,ICI_idevol,ICI_insumo,ICI_usuario,ICI_horaIndica,ICI_idsol )"+;
							" values (?mdosis , ?mfechoy , ?midevolhce, ?minsu ,?midusu,?mhora,?midsol )")
						If mret < 0
							mret=Aerr(eros)
							Messagebox(eros(3),"Validacion")
						Endif
					Else
						mobserva  = Alltrim(medica)+ " Hora Indic: "+Transform(mhora*100,"@L 99:99")+" " + mdosis
						mievol = mievol + mobserva +Chr(10)
					Endif
				Endif
			Next xih
		Else
			minsu = idins
			mdosis = Left(Alltrim(via)+" "+Alltrim(dosis),250)
			mhora = Iif(Vartype(mhora)="N",mhora,9999)
			mobserva  = Alltrim(medica)+ " SUSPENDIDA Indic: "+Transform(mhora*100,"@L 99:99")+" " + mdosis
			mievol = mievol + mobserva +Chr(10)

		Endif
	Endscan
Else
	Messagebox("NO PUDO REGISTRARSE LA INDICACION DE MEDICAMENTOS, GRABE LOS CAMBIOS Y VUELVA A INDICAR LO ADMINISTRADO."+Chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	mmsgerr = "INDICACION SIN GRABAR"
	mievol = ''
	Do sp_insert_tabctrlerr With "idevol:"+Transform(midevolhce), mmsgerr ,mcidusuario, "PISOS03e"
Endif

