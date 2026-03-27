****
** grabo un movimiento cuando hay inconsistencia de datos
****

Parameter  mdtfecha,mnnroreg, mnfactura ,tncodent,tncodpun
mdfecha = Ttod(mdtfecha)
mdtfecha = sp_busco_fecha_serv("DT")
mmotivo = Val(dat_cose(1,19))
mmotdes = Left(dat_cose(1,18),50)
mcodpun = 0
musuario = mcodvax
micodent = tncodent
mimpcose= Val(dat_cose(20))
mimpbono=  Val(dat_cose(7))+ Val(dat_cose(8))
If mimpcose<>mimpbono
	mret = SQLExec(mcon1, "insert into TabCtrlCose ( factura, fechahora, motivoGlobal, "+;
		"nroregistracio, descripcion ,usuario ) " + ;
		"values(?mnfactura, ?mdtfecha, ?mmotivo, ?mnnroreg,?mmotdes, ?musuario )")
	If mret > 0
		mret = SQLExec(mcon1, "select id from TabCtrlCose  where usuario = ?musuario "+;
			"and fechahora = ?mdtfecha and nroregistracio = ?mnnroreg", "mwkcontrol")
	Endif
	If mret >0 And Reccount("mwkcontrol")>0

		mid = mwkcontrol.Id
		Select coseguro

		mret = SQLExec(mcon1, "insert into TabCtrlCoseDet ( idCab , codpun, "+;
			"importeBono , importeCose , motivoIndiv) " + ;
			"values(?mid, ?tncodpun, ?mimpbono,?mimpcose, ?micodent )")
		If mret < 0
			=Aerr(EROS)
			Messagebox(EROS(3))
		Endif
	Endif
Endif
