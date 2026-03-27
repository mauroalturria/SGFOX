Parameters nadmision

* Busco Vales del paciente

Create Cursor mwkvalespami (tipopac c(3),codpun N, vale N, servicio c(50), fecha d, admision c(15), hora c(8), sel N,estado N, nroserv N)

madmision = Alltrim(nadmision)
lcsql = 'SELECT VAL_tipopaciente,VAL_CODPUN,VAL_codvaleasist,SERVICIOS.SER_descripserv,SERVICIOS.SER_codserv,VAL_fechasolicitud,VAL_horasolicitud,VAL_codadmision '+;
	'FROM VALESASIST LEFT JOIN SERVICIOS ON VALESASIST.VAL_codservvale = SERVICIOS.SER_codserv '+;
	'WHERE VALESASIST.VAL_codadmision = ?madmision and VALESASIST.VAL_estado in (2,3) and SERVICIOS.SER_codserv in (2200,8000,6400,7000,4402,5180,7100,7200,7300,7400,7700,7900,5163,4403,4100,9100)'
SQLExec(mcon1,lcsql,'mwkpamivales')
If Used('mwkpamivales')
	Select mwkpamivales
	If Reccount('mwkpamivales')>0
		Select mwkpamivales
		Scan All
			v0 = Alltrim(mwkpamivales.val_tipopaciente)
			v1 = mwkpamivales.val_codpun
			v2 = mwkpamivales.val_codvaleasist
			v3 = Alltrim(mwkpamivales.ser_descripserv)
			v4 = mwkpamivales.val_fechasolicitud
			v5 = Alltrim(mwkpamivales.val_codadmision)
			v6 = Alltrim(mwkpamivales.val_horasolicitud)
			v7 = 0
			v8 = mwkpamivales.ser_codserv
			Insert Into mwkvalespami (tipopac,codpun,vale,servicio,fecha,admision,hora,sel,estado,nroserv) Values (v0,v1,v2,v3,v4,v5,v6,v7,0,v8)
			Select mwkpamivales
		Endscan
	Endif
Endif

Use In Select('mwkpamivales')
Select * From mwkvalespami Into Cursor mwkpamivales Readwrite
Use In Select('mwkvalespami')