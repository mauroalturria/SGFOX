*
* Grabo / Actualizo, presupuestos
*

lparameters mabm, mNombre, mSectores, mEstado, mcondPago, mNroAfil, mEntidad, mobservaciones, mCab, mfechaAutoPres,;
	mEstadoActual, mValorMod, mvalorTotal, mRemitente, mIva, mTarea, mfechaProg, mIdPres, mSector, mregistrac, mpapel,;
	mSectorSol, mmoneda, mvalor1, mdesc1, mcod1, mvalor2, mdesc2, mmfecsolic,msectorautor,mdiasvto
&& OPCION 5,middetp ,mtipo,midap,mreg
if vartype(mvalor1)#"N"
	mvalor1 = 0
endif
if vartype(mdesc2)#"C"
	mdesc2 = ''
ENDIF
if vartype(mobservaciones)#"C"
	mobservaciones= ''
endif
if vartype(mvalor2)#"N"
	mvalor2 = 0
endif
mobserv1 = LEFT(mobservaciones,250)
mobserv2 = substr(mobservaciones,251,250)

if vartype(mmoneda)#"N"
	mmoneda = 0
endif

if mabm = 1
	mid = 0
	midpEst = 0
endif

mfechasolic   =  sp_busco_fecha_srv2('D')
mfechaautor1  = ctot("01/01/1900")
mfechaauto2   = ctot("01/01/1900")
mfecnull = ctod("01/01/1900")
mfecHoraDia   = ttoc(sp_busco_fecha_srv2('DT'))
mfechoy  = sp_busco_fecha_serv("DD")
mplantilla    =  ""
IF VARTYPE(msectorautor  )#"C"
	msectorautor  = ""
endif
msectorefec   =  mSector
middetp       = 0
middetpInsert = ''

if used('mwkmod')
	select mwkmod
	midmodulo = id
else
	select componentes
	go top
	locate for tipo = 2
	midmodulo = codigo
endif
if empty(midmodulo)
	select componentes
	go top
	locate for tipo = 2
	midmodulo = codigo
endif

do case
	case mabm = 1                && Alta Cabecera Presupuesto

		if mCab = 'C'

			public PultimoIdActual
			create cursor mkwIdActual(UltimoId n(8))
			mplantilla  = alltrim(sys(0)) + alltrim(mfecHoraDia)
			midmodulo = iif(midmodulo = 1,0,midmodulo )
			mret = sqlexec(mcon1, "insert into tabpresupuestos (paciente, sectorsol,Estado, condPago, NroAfiliado,Entidad,"+;
				"observaciones,observa2,plantilla,sectorautor,fechasolic,fechaAutoPres,EstadoActual,idmodulo,ValorMod"+;
				",valorTotal,Remitente,iva,tarea,ValorFechaprog,sectorefec,nroregistrac,estado,SectorSol,moneda,fecpasiva,diasvto)"+;
				" values( ?mNombre, ?mSectores, ?mEstado, ?mcondPago, ?mNroAfil, ?mEntidad,?mobserv1 ,?mobserv2,?mplantilla ,"+;
				"?msectorautor,"+;
				"?mfechasolic,?mfechaAutoPres,?mEstadoActual,?midmodulo,?mValorMod,?mvalorTotal,?mRemitente,?mIva,"+;
				"?mtarea,?mfechaprog,?mSector,?mregistrac,?mpapel,?mSectorSol,?mmoneda,?mfecnull,?mdiasvto  )")
			if mret < 0
				=aerr(eros)
				messagebox(eros(3))
				messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
			endif
			mret = sqlexec(mcon1, "select id from tabpresupuestos where plantilla = ?mplantilla","MwkUltimoId")
			if mret < 0
				=aerr(eros)
				messagebox(eros(3))
				messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
			endif
			PultimoIdActual = MwkUltimoId.id
			select mkwIdActual
			insert into mkwIdActual(UltimoId ) values(PultimoIdActual)

		else

			middetp = MwkUltimoId.id
			if used('mwkmod')
				select mwkmod
				midmodulo = id
			else
				midmodulo = 0
			endif
			select componentes
			scan
				if tipo # 4
					if componentes.TipoIng <>3
						midmodulo = 0
					endif
					mcodigo = componentes.codigo
					if type('pr') <> 'U'
						if componentes.tipo = 2
							if pr = 1
								mincluye = 1
								mexcluye = 0
							else
								mincluye = 0
								mexcluye = 1
							endif
						else
							if inc = 1
								mincluye = 1
								mexcluye = 0
							else
								mincluye = 0
								mexcluye = 1
							endif
							if inc = 0 and exc = 0
								mexcluye = 0
								mincluye = 0
							endif
						endif
					else
						mincluye = .null.
						mexcluye = .null.
					endif
					if componentes.tipo = 3
						mincluye = 0
						mexcluye = 0
					endif
					mdescrip = componentes.descrip
					mvalor   = componentes.valor
					mTipo    = componentes.tipo
					mdetalle = detalle
					midmodulo = iif(midmodulo = 1,0,midmodulo )
					mret = sqlexec(mcon1, "insert into TabPdetpresupuesto ( precio,tipopres,iddetp,"+;
						"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva )"+;
						" values(?mvalor,?mTipo,?middetp,?midmodulo,?mincluye,?mexcluye ,?mdetalle,?mcodigo,?mfecnull  )")
					if mret < 0
						=aerr(eros)
						messagebox(eros(3))
						messagebox("ERROR de Grabacion , Reintente", 48, "Validacion")
					endif

				endif
			endscan

			if mvalor1 > 0 and mcod1 > 1
				mvalor    = mvalor1
				mTipo     = 4
				mdetalle  = mdesc1
				midmodulo = iif(midmodulo = 1,0,midmodulo )
				mincluye  = 0
				mexcluye  = 0
				mcodigo   = mcod1

				mret = sqlexec(mcon1, "insert into TabPdetpresupuesto (precio,tipopres,iddetp,"+;
					"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
					" values(?mvalor,?mTipo,?middetp,?midmodulo,?mincluye,?mexcluye,?mdetalle,?mcodigo,?mfecnull  )")
				if mret < 0
					=aerr(eros)
					messagebox(eros(3))
					messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
				endif

			endif
			if mvalor2 > 0 and !empty(mdesc2)
				mvalor    = mvalor2
				mTipo     = 4
				mdetalle  = mdesc2
				midmodulo = iif(midmodulo = 1,0,midmodulo )
				mincluye  = 0
				mexcluye  = 0
				mcodigo   = 1

				mret = sqlexec(mcon1, "insert into TabPdetpresupuesto (precio,tipopres,iddetp,"+;
					"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
					" values(?mvalor,?mTipo,?middetp,?midmodulo,?mincluye,?mexcluye,?mdetalle,?mcodigo,?mfecnull  )")
				if mret < 0
					=aerr(eros)
					messagebox(eros(3))
					messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
				endif
			endif
		endif

	case mabm = 2  &&& actualiza

		midmodulo = iif(midmodulo = 1,0,midmodulo )

		if mCab = 'C'

			mret = sqlexec(mcon1, "UPDATE tabpresupuestos SET paciente=?mNombre,"+;
				"Estado=?mEstado,condPago = ?mcondPago,"+;
				"NroAfiliado = ?mNroAfil, Entidad = ?mEntidad,"+;
				"Observaciones=?mobserv1 ,Observa2=?mobserv2,plantilla=?mplantilla,"+;
				"fechaAutoPres = ?mfechaAutoPres,EstadoActual = ?mEstadoActual,"+;
				"idmodulo =?midmodulo  ,ValorMod =?mValorMod,valorTotal = ?mvalorTotal,Remitente = ?mRemitente,"+;
				"iva = ?mIva,tarea = ?mTarea ,nroregistrac = ?mregistrac,estado = ?mpapel,"+;
				"ValorFechaprog = ?mFechaProg,moneda=?mmoneda,diasvto= ?mdiasvto"+;
				iif(vartype(mmfecsolic)='D',", fechasolic = ?mmfecsolic","")+;
				" where id = ?mIdPres")

		else

			mret = sqlexec(mcon1, "select descserv from TabPdetpresupuesto where iddetp = ?middetp and fecpasiva = ?mfecnull","MWKHayReg")

			if used('mwkmod')
				select mwkmod
				midmodulo = id
			else
				midmodulo = 0
			endif 	&& Alta Detalle Presupuesto

			if reccount('componentes') = 0
				mret = SQLExec(mcon1, "Update tabpdetpresupuesto Set fecpasiva = ?mfechoy  where idDetp = ?mIdPres and fecpasiva = ?mfecnull ")
			else

				select componentes
				scan
					if tipo # 4
						mdescrip = descrip
						mmid = mid
						mTipo = tipo
						mdescrip = descrip
						mvalor = valor
						mcodigo = codigo
						midmodulo = iif(midmodulo = 1,0,midmodulo )

						if type('pr') <> 'U'
							if tipo = 2
								if pr = 1
									mincluye = 1
									mexcluye = 0
								else
									mincluye = 0
									mexcluye = 1
								endif
							else
								if inc = 1
									mincluye = 1
									mexcluye = 0
								else
									mincluye = 0
									mexcluye = 1
								endif
								if inc = 0 and exc = 0
									mexcluye = 0
									mincluye = 0
								endif
							endif
						else
							mincluye = .null.
							mexcluye = .null.
						endif

						mdetalle = detalle
						mret = sqlexec(mcon1,"select id from tabpdetpresupuesto where tipopres = ?mTipo and idpreocon = ?mcodigo and iddetp = ?mIdPres and fecpasiva = ?mfecnull  ","mwkValid")
						if midmodulo <> 1
							mret = sqlexec(mcon1,"select idmodulo from tabpdetpresupuesto where  iddetp = ?mIdPres and fecpasiva = ?mfecnull  ","mwkValidModulo")
							if reccount('mwkValidModulo') <> 0   && x si fue ya borrado
								sele mwkValidModulo
								go top
								if idmodulo <> midmodulo
									if !empty(mIdPres )
										mret = SQLExec(mcon1, "Update tabpdetpresupuesto Set fecpasiva = ?mfechoy  where idDetp = ?mIdPres and fecpasiva = ?mfecnull ")
									endif
								endif
							endif
						endif
						if reccount('mwkValid') = 0 &&!FOUND()
							select mwkPres
							middetp   = id

							select componentes
							mvalor = valor
							mdetalle = detalle
							mret = sqlexec(mcon1, "insert into TabPdetpresupuesto ( precio,tipopres,iddetp,"+;
								"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
								" values(?mvalor,?Tipo,?mIdPres,?midmodulo,?mincluye,?mexcluye ,?mDetalle,?mcodigo,?mfecnull )")
						else
							select mwkPres
							middetp   = id
							mret = sqlexec(mcon1,"UPDATE TabPdetpresupuesto  SET  precio =?mvalor ,tipopres =?mTipo ,fecpasiva = ?mfecnull,"+;
								"idmodulo =?midmodulo,incluye = ?mincluye,excluye = ?mexcluye,idpreocon = ?mcodigo where id = ?mmid ")
						endif
						if mret < 0
							=aerr(eros) 
							messagebox(eros(3))
							messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
						endif

					endif
				endscan
			endif

			if mvalor1 > 0 or mvalor2 > 0

				select mwkPres
				middetp   = id

				mvalor    = mvalor1
				mTipo     = 4
				mdetalle  = mdesc1
				midmodulo = iif(midmodulo = 1,0,midmodulo )
				mincluye  = 0
				mexcluye  = 0
				mcodigo   = mcod1

				mret = SQLExec(mcon1, "Update tabpdetpresupuesto Set fecpasiva = ?mfechoy  where iddetp = ?middetp and tipopres = ?mTipo and fecpasiva = ?mfecnull ")
				if mcod1 > 1 and mvalor1 > 0
					mret = sqlexec(mcon1, "insert into TabPdetpresupuesto (precio,tipopres,iddetp,"+;
						"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
						" values(?mvalor,?mTipo,?middetp,?midmodulo,?mincluye,?mexcluye,?mdetalle,?mcodigo,?mfecnull )")
					if mret < 0
						=aerr(eros)
						messagebox(eros(3))
						messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
					endif
				endif
				if mvalor2 > 0 and !empty(mdesc2)
					mvalor    = mvalor2
					mTipo     = 4
					mdetalle  = mdesc2
					midmodulo = iif(midmodulo = 1,0,midmodulo )
					mincluye  = 0
					mexcluye  = 0
					mcodigo   = 1

					mret = sqlexec(mcon1, "insert into TabPdetpresupuesto (precio,tipopres,iddetp,"+;
						"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
						" values(?mvalor,?mTipo,?middetp,?midmodulo,?mincluye,?mexcluye,?mdetalle,?mcodigo,?mfecnull )")
					if mret < 0
						=aerr(eros)
						messagebox(eros(3))
						messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
					endif
				endif
			endif
		endif

	case mabm = 3  && Baja

		if mCab = 'C'
			select mwkPres
			mid = id
			if used('mwkBuscaItem')
				select mwkBuscaItem
				use
			endif
			nDialogType = 4 + 32 + 256
			mret = sqlexec(mcon1,"select id from tabpdetpresupuesto where iddetp = ?mid and fecpasiva = ?mfecnull ","mwkBuscaItem")
			select mwkBuscaItem
			if reccount() = 0
				if messagebox("DESEA BORRAR EL PRESUPUESTO",nDialogType,"VALIDACIÒN") = 6
					mret = SQLExec(mcon1, "Update tabpresupuestos Set fecpasiva = ?mfechoy  where id = ?mid")
				endif
			else
				if messagebox("ESTE PRESUPUESTO TIENE ITEM RELACIONADOS, DESEA BORRARLO DE TODOS MODOS",nDialogType,"VALIDACIÒN") = 6
					mret = SQLExec(mcon1, "Update tabpdetpresupuesto Set fecpasiva = ?mfechoy  where iddetp  = ?mid and fecpasiva = ?mfecnull ")
					mret = SQLExec(mcon1, "Update tabpresupuestos Set fecpasiva = ?mfechoy  where id = ?mid")
				endif
			endif
		else
			select componentesBorrados

			scan
				mmid = mid
				mret = SQLExec(mcon1, "Update tabpdetpresupuesto Set fecpasiva = ?mfechoy  where id = ?mmid and fecpasiva = ?mfecnull")
			endscan
		endif

	case mabm = 4 && por si borra todos los item y quiere elegir un nuevo modulo

		middetp = mwkPres.id
		if used('mwkmod')
			select mwkmod
			midmodulo = id
		else
			midmodulo = 0
		endif 				&& Alta Detalle Presupuesto
		select componentes
		scan
			if tipo # 4
				if componentes.TipoIng<>3
					midmodulo = 0
				endif
				if tipo = 2
					if pr = 1
						mincluye = 1
						mexcluye = 0
					else
						mincluye = 0
						mexcluye = 1
					endif
				else
					if inc = 1
						mincluye = 1
						mexcluye = 0
					else
						mincluye = 0
						mexcluye = 1
					endif

				endif
				mdetalle  = detalle
				mret = sqlexec(mcon1, "insert into TabPdetpresupuesto ( precio,tipopres,iddetp,"+;
					"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
					" values(?valor,?Tipo,?middetp,?midmodulo,?mincluye,?mexcluye ,?mDetalle  ,?mcodigo,?mfecnull )")
				if mret < 0
					=aerr(eros)
					messagebox(eros(3))
					messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
				endif
			endif
		endscan

		if mvalor1 > 0 or mvalor2 > 0

			mvalor    = mvalor1
			mTipo     = 4
			mdetalle  = mdesc1
			midmodulo = iif(midmodulo = 1,0,midmodulo )
			mincluye  = 0
			mexcluye  = 0
			mcodigo   = mcod1

			mret = SQLExec(mcon1, "Update tabpdetpresupuesto Set fecpasiva = ?mfechoy  "+;
				" where iddetp = ?middetp and tipopres = ?mTipo and fecpasiva = ?mfecnull")
			if  mcod1 > 1 and mvalor1 > 0
				mret = sqlexec(mcon1, "insert into TabPdetpresupuesto (precio,tipopres,iddetp,"+;
					"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
					" values(?mvalor,?mTipo,?middetp,?midmodulo,?mincluye,?mexcluye,?mdetalle,?mcodigo,?mfecnull )")
				if mret < 0
					=aerr(eros)
					messagebox(eros(3))
					messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
				endif
			endif
			if mvalor2 > 0 and !empty(mdesc2)
				mvalor    = mvalor2
				mTipo     = 4
				mdetalle  = mdesc2
				midmodulo = iif(midmodulo = 1,0,midmodulo )
				mincluye  = 0
				mexcluye  = 0
				mcodigo   = 1

				mret = sqlexec(mcon1, "insert into TabPdetpresupuesto (precio,tipopres,iddetp,"+;
					"idmodulo,incluye,excluye,descserv,idpreocon,fecpasiva)"+;
					" values(?mvalor,?mTipo,?middetp,?midmodulo,?mincluye,?mexcluye,?mdetalle,?mcodigo,?mfecnull )")
				if mret < 0
					=aerr(eros)
					messagebox(eros(3))
					messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
				endif
			endif

		endif

	case mabm = 5 && graba relacion con alta complejidad
&& OPCION 5,middetp = mNombre  ,mtipo = mSectores,midap = mEstado ,mreg = mcondPago
		mPA_fechapas = ctod("01/01/1900")
		mPA_tipopac = mSectores
		mPA_idPresu = mNombre
		if mSectores="INT"
			mPA_idAutprevia = mEstado
			mPA_idTabautpre = 1
		else
			mPA_idAutprevia = 55
			mPA_idTabautpre = mEstado
		endif
		mret = sqlexec(mcon1, "insert into ZabPresuAut (PA_fechapas, PA_idAutprevia,PA_idPresu, PA_idTabautpre,PA_tipopac)"+;
			" values(?mPA_fechapas, ?mPA_idAutprevia,?mPA_idPresu, ?mPA_idTabautpre,?mPA_tipopac)")
		if mret < 0
			=aerr(eros)
			messagebox(eros(3))
			messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
		endif

endcase

if type('mret') <> 'U'
	if mret <1
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif
endif
