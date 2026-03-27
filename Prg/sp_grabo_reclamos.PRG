****
** inserto datos de reclamos
****
parameter mopcion, mAtendioRec, mCodSector, mEstado, ;
	mFechaPrevista, mIDPuesto, mInternoTE, mNroReclamo,;
	mPrioridad, mDetalle, mSector, mUsuario, ;
	mAtendioSol, mFechaSolucion, msolucion, mrespons,mmotivo ,mFechaAtendido,;
	mfactiva,mtipo, midPuestoST

mfechanula  = ctod('01/01/1900')
mfechagraba = sp_busco_fecha_srv2('DT')

if mopcion= 1		&& inserto nuevo registro
	mret = sqlexec(mcon1, "insert into TabReclamos(AtendioRec, CodSector,"+;
		" Estado, FechaGraba, FechaPrevista, IDPuesto,"+;
		" InternoTE, NroReclamo, Prioridad, Detalle, Sector, Usuario" + ;
		" ,AtendioSol, FechaSolucion, Soluciones, AsignadoA, Motivo,FechaAtendido"+;
		" ,FechaActiva,PrevCorrec )"+;
		" values(?mAtendioRec, ?mCodSector, ?mEstado, ?mFechaGraba,"+;
		"  ?mFechaPrevista, ?mIDPuesto,?mInternoTE, ?mNroReclamo,"+;
		"  ?mPrioridad, ?mDetalle, ?mSector, ?mUsuario, " + ;
		" '', ?mfechanula, '',?mrespons, ?mmotivo, ?mFechaAtendido,?mfactiva,?mtipo)")

	if mret < 1
		=aerr(eros)
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
	else
		if mrespons="EMONTOYA"
			messagebox('SE REGISTRO SU PEDIDO, SE PONDRAN EN CONTACTO CON USTED. GRACIAS', 64,'Registro de Pedidos')
		endif
	endif
	mret = sqlexec(mcon1,'select id from TabReclamos ' +;
		' where NroReclamo = ?mNroReclamo ' , 'mwkident')
	mNewNroReclamo = mwkident.id
	mret = sqlexec(mcon1, "update TabReclamos "+;
		" set NroReclamo = ?mNewNroReclamo "+;
		" where NroReclamo = ?mNroReclamo "  )

endif
if mopcion= 2		&& actualizo anulacion de ingreso
	mret = sqlexec(mcon1, "update TabReclamos set  Estado = ?mEstado "+;
		", AtendioSol = ?mAtendioSol, FechaSolucion = ?mFechaSolucion " + ;
		" where NroReclamo = ?mNroReclamo "  )

	if mret < 1
		=aerr(eros)
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
	endif

endif

if mopcion= 3		&& actualizo ingreso completo
	mret = sqlexec(mcon1, "update TabReclamos set IDPuesto = ?mIDPuesto " + ;
		", InternoTE = ?mInternoTE, Prioridad = ?mPrioridad " + ;
		", Sector = ?mSector, Usuario = ?mUsuario, FechaAtendido = ?mFechaAtendido " + ;
		", Estado = ?mEstado, Detalle = ?mDetalle, AtendioSol = ?mAtendioSol " +;
		", FechaSolucion = ?mFechaSolucion, Soluciones = ?mSolucion  " + ;
		", AsignadoA = ?mrespons, Motivo = ?mmotivo, PrevCorrec=?mtipo " +;
		", FechaPrevista = ?mFechaPrevista, idstpuesto = ?midPuestoST "+;
		" where NroReclamo = ?mNroReclamo "  )

	if mret < 1
		=aerr(eros)
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
	endif

endif
