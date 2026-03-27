Lparameters lntipo, ldFechad, ldFechah, lnquiro

* (Viejo)

Create Cursor mwkpreagenda (estado N(1), fecha d(8), quirofano N(6), referencia N(1), turno N(1), servicio N(6))

*ldia = Ctod('20/12/2016')

If Vartype(ldFechad)#"D"
* Ver esta parte
Endif

If Vartype(ldFechah)#"D"
	ldFechah = ldFechad
Endif

Do Case

Case lntipo = 1

	Select mwkquirohab
	Go Top
	Scan All
		lnNroQuiro = mwkquirohab.Id
*Select * From mwktabpqfran Where pqf_quirofano = lnNroQuiro And Between(lcDia,pqf_fecvigend,pqf_fecvigenh) Into Cursor mwkAgenda1
		Select * From mwkTabPQfran Where mwkTabPQfran.pqf_quirofano = lnNroQuiro And Not (mwkTabPQfran.pqf_fecvigend = mwkTabPQfran.pqf_fecvigenh) And Between(ldFechad,mwkTabPQfran.pqf_fecvigend,mwkTabPQfran.pqf_fecvigenh) Into Cursor mwkAgenda1 Readwrite

		Select mwkAgenda1
		Go Top

		Scan All
			lnCantidad = mwkAgenda1.pqf_cantidad
			For nVar = 1 To lnCantidad
				Insert Into mwkpreagenda (estado,fecha,quirofano,referencia,turno,servicio) Values (0,ldFechad,lnNroQuiro,0,mwkAgenda1.pqf_turno,mwkAgenda1.pqf_servicio)
			Endfor
		Endscan

		Select mwkquirohab
	Endscan

Case lntipo = 2

	nVarFecha = ldFechad
	lnCont = 0
	Do While nVarFecha < ldFechah
*		nVarFecha = Date(Year(ldFechad),Month(ldFechad),Day(ldFechad))+lnCont
		nVarFecha = nVarFecha + lnCont
		lnCont = lnCont + 1

		Select mwkquirohab
		Go Top

		Scan All

			lnNroQuiro = mwkquirohab.Id

*Select * From mwktabpqfran Where pqf_quirofano = lnNroQuiro And Between(lcDia,pqf_fecvigend,pqf_fecvigenh) Into Cursor mwkAgenda1
			Select * From mwkTabPQfran Where mwkTabPQfran.pqf_quirofano = lnNroQuiro And Not (mwkTabPQfran.pqf_fecvigend = mwkTabPQfran.pqf_fecvigenh) And Between(nVarFecha,mwkTabPQfran.pqf_fecvigend,mwkTabPQfran.pqf_fecvigenh) Into Cursor mwkAgenda1 Readwrite

			Select mwkAgenda1
			Go Top

			Scan All
				lnCantidad = mwkAgenda1.pqf_cantidad
				For nVar = 1 To lnCantidad
					Insert Into mwkpreagenda (estado,fecha,quirofano,referencia,turno,servicio) Values (0,nVarFecha,lnNroQuiro,0,mwkAgenda1.pqf_turno,mwkAgenda1.pqf_servicio)
				Endfor
			Endscan

			Select mwkquirohab

		Endscan

	Enddo

Endcase