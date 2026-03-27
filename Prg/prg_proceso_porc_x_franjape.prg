Parameters vr_ctipo,nrandom

Do sp_busco_estados With 109," and tipo = "+ Transform(mxambito )+" order by subestado desc ","mwkttporc"
Do sp_busco_estados With 56,' and estado = 1 and tipo = 2  ','mwknoTO'
Select mwknoTO
Go Top
mimed = Alltrim(mwknoTO.Descrip)
mitipono = mwknoTO.subestado
If Vartype(nrandom )<>"N"
	nrandom  =0
Endif
If Vartype(vr_ctipo)<>"C"
	vr_ctipo = ' and turnos.tipoturno in (0 ) '
Endif
If Used('mwkmedpresta1')
	Select * From mwkmedpresta1 Group By codmed,horadesde,horahasta,diasem,codprest Into Cursor mwkmedpresta12
Endif
If Used('mwkmedprestanom')
	Select * From mwkmedprestanom Group By codmed,horadesde,horahasta,diasem,codprest Into Cursor mwkmedpresta12
Endif
Select Distinct codesp From mwkmedpresta12 Into Cursor mwkespemed
Select *  From mwkmedpresta12 Group By codmed,horadesde,horahasta,diasem,codprest Into Cursor mwkpresmed
Select mwkmedpresta12
Go Top

Do While !Eof('mwkmedpresta12')

* variables que necesito para el proceso genero turnos

	vr_horad= mwkmedpresta12.horadesde
	vr_horah= mwkmedpresta12.horahasta
	vr_med = mwkmedpresta12.codmed
	Select *  From mwkpresmed Where hhmmdes = mwkmedpresta12.hhmmdes Group By codmed,horadesde,horahasta,diasem,codprest Into Cursor mwkpresmedhora
	Select * From mwkpresmedhora Where codmed =vr_med   Into Cursor mwkmpmed

*!*	mnporc    = mcantidad
	vr_fecha = mdmasX
	vr_diasem = Dow(vr_fecha )
	vr_codesp = mwkmedpresta12.codesp

	Do sp_cantidad_turnos_generados With vr_med, vr_fecha, vr_diasem, vr_horad, vr_horah,vr_ctipo

	lesprime = 0
	Select MwkturnosxFranja
	Use In Select('mwkturnosxf')
	Use Dbf('MwkturnosxFranja') Again In 0 Alias mwkturnosxf
	Select mwkturnosxf
	Go Top
	Scan
		mid = mwkturnosxf.Id
		mret=SQLExec(mcon1,"update turnos set tipoturno=0 where id = ?mid   ")
		Replace tipoturno With 0
	Endscan

	Select mwkttporc
	Go Top
	Scan
		Select * From mwkturnosxf Where tipoturno=0  Into Cursor MwkturnosxFranjaOS
		vr_porc = mwkttporc.subestado
		vr_tipo = mwkttporc.estado
		Select * From mwkentnoTipoturno Where tipoturno = vr_tipo And EXE_CodEspecialidad = vr_codesp Into Cursor mwksaltotipo
		If Reccount('mwksaltotipo')= 0
			lsigue = .T.
			Select * From mwknoto Where subestado = vr_tipo Into Cursor mwknocambiaxmed
			Select mwknocambiaxmed
			mcmed = alltrim(mwknocambiaxmed.Descrip)
			Scan
				If INLIST(vr_med,&mcmed)
					lsigue =.F.
					Exit
				Endif
			Endscan
			If lsigue
				Select * From mwkentnoTpoturPres,mwkpresmedhora Where PXE_CodPrestacion = codprest And hhmmdes = mwkmedpresta12.hhmmdes And codmed = vr_med ;
				GROUP By PXE_CodPrestacion Into Cursor mwksaltotipo
				If Reccount('mwksaltotipo') <> Reccount('mwkmpmed')
					lesprime =lesprime +1
					nrandom = nrandom +1
					If Used('MwkCantxFranja')
						If MwkCantxFranja.totalturnos > 0
							If  mxambito =1
								mncant   = Round((MwkCantxFranja.totalturnos * vr_porc/100),0)
							Else
								mncant   = Int((MwkCantxFranja.totalturnos * vr_porc/100))
							Endif
							nstep = Int(MwkCantxFranja.totalturnos/mncant)
							If  mxambito =1 And vr_codesp <>"LABO"
								nstep = 1
							Endif
							If Mod(nrandom ,2)=0 Or mxambito > 1
								Select MwkturnosxFranjaOS
								Go Top
								i = 1
								tt = 0
								Do While !Eof('MwkturnosxFranjaOS')
									mid = MwkturnosxFranjaOS.Id
									If   tt<mncant
										tt= tt+1
										mret=SQLExec(mcon1,"update turnos set tipoturno=?vr_tipo where id = ?mid   ")
										i= i+1
										Update mwkturnosxf Set tipoturno = vr_tipo Where Id = mid
										Select MwkturnosxFranjaOS
										Skip nstep

									Else
										Exit
									Endif
								Enddo
							Else
								Select MwkturnosxFranjaOS
								Go Bottom
								i = 1
								tt = 0
								Do While !Bof('MwkturnosxFranjaOS')
									mid = MwkturnosxFranjaOS.Id
									If   tt<mncant
										tt= tt+1
										mret=SQLExec(mcon1,"update turnos set tipoturno=?vr_tipo where id = ?mid    ")
										i= i+1
										Update mwkturnosxf Set tipoturno = vr_tipo Where Id = mid
										Select MwkturnosxFranjaOS
										Skip -1

									Else
										Exit
									Endif
								Enddo

							Endif

						Endif
					Endif
				Endif
			Endif
		Endif
	Endscan
	Select mwkmedpresta12
	Skip 1 In mwkmedpresta12
	If Eof('mwkmedpresta12')
		Exit
	Endif
Enddo
