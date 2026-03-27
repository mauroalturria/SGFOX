* Validación (Nuevo) 2017-01-05

Create Cursor mwkpreagenda (estado N(1), fecha d(8), quirofano N(6), referencia N(1), turno N(1), servicio N(6))

lnQuiro = 4
ldFechaI = Ctod("4/12/2016")
ldFechaH = Ctod("31/12/2016")

*Select * From mwkTabPQfran Where mwkTabPQfran.pqf_quirofano = lnQuiro ;
And Not (mwkTabPQfran.pqf_fecvigend = mwkTabPQfran.pqf_fecvigenh) ;
And Between(ldFecha,mwkTabPQfran.pqf_fecvigend,mwkTabPQfran.pqf_fecvigenh) Into Cursor prueba Readwrite

Do While ldFechaI < ldFechaH

	nVar = Dow(ldFechaI)

	Select * From mwkTabPQfran Where pqf_dia = nVar And (pqf_fecvigend <> pqf_fecvigenh) And Between(ldFechaI,pqf_fecvigend,pqf_fecvigenh) Into Cursor prueba Readwrite

	Select prueba
	Go Top
	Scan All
		lnEstado = 0
		ldFecha = ldFechaI
		lnQuiro = prueba.pqf_quirofano
		lnRef = 0
		lnTurno = prueba.pqf_turno
		lnServ = prueba.pqf_servicio
*				For nVar = 1 To prueba.pqf_cantidad
		Insert Into mwkpreagenda (estado,fecha,quirofano,referencia,turno,servicio) Values (lnEstado,ldFecha,lnQuiro,lnRef,lnTurno,lnServ)
*				endfor
	Endscan

	ldFechaI = ldFechaI + 1

Enddo