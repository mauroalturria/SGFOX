Parameters ldFechaI,ldFechaH,lnQuiro,ldiasem,lnservicio,lnsinferiado,lalertas

* Validación 2017-01-09
*
* Me Fjo Si está repetido
*
*

Create Cursor mwkpreagenda (estado N(1), fecha d(8), quirofano N(6), referencia N(1), turno N(1), servicio N(6), horas N(4))
Create Cursor mwkupdagenda (estado N(1), fecha d(8), quirofano N(6), referencia N(1), turno N(1), servicio N(6), horas N(4), Id Integer)
cmensa = ''
If Vartype(lnsinferiado)#"N"
	lnsinferiado = 0
Endif
If Vartype(lalertas)="U"
	lalertas = .T.
Endif

ldFechaH = ldFechaH + 1

Do Case

Case lnQuiro = 0 && Todos

	Do While ldFechaI < ldFechaH
		Do sp_busco_feriado With '',ldFechaI
		nVar = Dow(ldFechaI)
		If (ldiasem = 8 Or ldiasem = nVar) And (Reccount('MWKFeriados')= 0 Or lnsinferiado = 1)
			Select * From mwkTabPQfran Where pqf_dia = nVar And (pqf_fecvigend <> pqf_fecvigenh) And Between(ldFechaI,pqf_fecvigend,pqf_fecvigenh) Into Cursor mwkGenAgen Readwrite
			Select mwkGenAgen
			Go Top
			nVar = 0
			Scan All
				lhoraini = PQF_horaInicio/100
				lnEstado = 0
				ldFecha = ldFechaI
				lnQuiro = mwkGenAgen.pqf_quirofano
				lnRef = 0
				lnTurno = Iif(lhoraini<14,1,2) && mwkGenAgen.pqf_turno
				lnServ = mwkGenAgen.pqf_servicio
				lndura = mwkGenAgen.pqf_duracion
				If lnservicio = 0 Or lnservicio=lnServ
					lnmin = lhoraini *60
					For nVar = 1 To mwkGenAgen.pqf_cantidad
						lnHoras = Int(lnmin/60)*100+Mod(lnmin,60)
						lcSQL = "select id,pqq_referencia from tabpqquiro where pqq_fecha = ?ldFecha  and pqq_quirofano= ?lnQuiro  and  "+;
							"pqq_turno = ?lnTurno  and pqq_servicio =?lnServ  and PQQ_hora= ?lnHoras  "
						If !Prg_EjecutoSql(lcSQL,"mwkctrexis")
							Return .F.
						Endif
						If Reccount("mwkctrexis")=0
							Insert Into mwkpreagenda (estado,fecha,quirofano,referencia,turno,servicio,horas) ;
								Values (lnEstado,ldFecha,lnQuiro,lnRef,lnTurno,lnServ,lnHoras)
						Else
							If mwkctrexis.pqq_referencia =0
								Insert Into mwkupdagenda (estado,fecha,quirofano,referencia,turno,servicio,horas,Id) ;
									Values (lnEstado,ldFecha,lnQuiro,lnRef,lnTurno,lnServ,lnHoras,mwkctrexis.Id)
							Endif
						Endif

						lnmin = lnmin + lndura
					Endfor
				Endif
			Endscan
		Endif
		ldFechaI = ldFechaI + 1

	Enddo

Case lnQuiro > 0

	Do While ldFechaI < ldFechaH

		Do sp_busco_feriado With '',ldFechaI
		nVar = Dow(ldFechaI)
		If (ldiasem = 8 Or ldiasem = nVar) And (Reccount('MWKFeriados')= 0 Or lnsinferiado = 1)
			Select * From mwkTabPQfran Where pqf_quirofano = lnQuiro And pqf_dia = nVar And (pqf_fecvigend <> pqf_fecvigenh) ;
				And Between(ldFechaI,pqf_fecvigend,pqf_fecvigenh) Into Cursor mwkGenAgen Readwrite
			Select mwkGenAgen
			Go Top
			nVar = 0
			Scan All
				lnEstado = 0
				ldFecha = ldFechaI
				lnRef = 0
				lnServ = mwkGenAgen.pqf_servicio
				lndura = mwkGenAgen.pqf_duracion
				lhoraini = mwkGenAgen.PQF_horaInicio/100
				lnTurno = Iif(lhoraini<14,1,2) && mwkGenAgen.pqf_turno
				lnmin = lhoraini *60
				If lnservicio = 0 Or lnservicio=lnServ
					For nVar = 1 To mwkGenAgen.pqf_cantidad
						lnHoras = Int(lnmin/60)*100+Mod(lnmin,60)
						lcSQL = "select id,pqq_referencia from tabpqquiro where pqq_fecha = ?ldFecha  and pqq_quirofano= ?lnQuiro  and  "+;
							"pqq_turno = ?lnTurno  and pqq_servicio = ?lnServ  and pqq_hora= ?lnHoras  "

						If !Prg_EjecutoSql(lcSQL,"mwkctrexis")
							Return .F.
						Endif

						If Reccount("mwkctrexis")=0
							Insert Into mwkpreagenda (estado,fecha,quirofano,referencia,turno,servicio,horas) ;
								Values (lnEstado,ldFecha,lnQuiro,lnRef,lnTurno,lnServ,lnHoras)
						Else
							If mwkctrexis.pqq_referencia =0
								Insert Into mwkupdagenda (estado,fecha,quirofano,referencia,turno,servicio,horas,Id) ;
									Values (lnEstado,ldFecha,lnQuiro,lnRef,lnTurno,lnServ,lnHoras,mwkctrexis.Id)
							Endif
						Endif
						lnmin = lnmin + lndura
					Endfor
				Endif
			Endscan
		Endif
		ldFechaI = ldFechaI + 1

	Enddo

Endcase

* Grabo en la tabla TabPQQuiro

Select mwkpreagenda
Go Top
If Reccount("mwkpreagenda")>0
	Go Top
	Scan All
		lcSQL = "insert into tabpqquiro (pqq_estado,pqq_fecha,pqq_quirofano,pqq_referencia,pqq_turno,pqq_servicio,PQQ_hora) "+;
			" values (?mwkpreagenda.estado,?mwkpreagenda.fecha,?mwkpreagenda.quirofano"+;
			",?mwkpreagenda.referencia,?mwkpreagenda.turno,?mwkpreagenda.servicio,?mwkpreagenda.horas)"
		mret = SQLExec(mcon1,lcSQL)
		If mret < 0 And lalertas
			cmensa = cmensa + "ERROR AL GENERAR LA AGENDA"
		Endif
	Endscan
Else
	cmensa =  cmensa +"NO HAY DATOS. NO SE CREO LA AGENDA"

Endif
Select mwkupdagenda
Go Top
If Reccount("mwkupdagenda")>0
	Go Top
	Scan All
		mid = mwkupdagenda.Id
		lcSQL = "update tabpqquiro set pqq_estado = ?mwkupdagenda.estado  ,pqq_fecha = ?mwkupdagenda.fecha  ,pqq_quirofano = ?mwkupdagenda.quirofano"+;
			",pqq_referencia = ?mwkupdagenda.referencia  ,pqq_turno = ?mwkupdagenda.turno ,pqq_servicio = ?mwkupdagenda.servicio  ,PQQ_hora = ?mwkupdagenda.horas) "
		mret = SQLExec(mcon1,lcSQL)
		If mret < 0
			cmensa = cmensa + Chr(10)+"ERROR AL ACTUALIZAR SERVICIOS"
		Endif
	Endscan
	If lalertas
		cmensa = cmensa + Chr(10)+"LA AGENDA SE ACTUALIZO CON EXITO"
	Endif
Else
Endif

If lalertas
	Messagebox(cmensa,0,"")
Endif
