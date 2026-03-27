*do sp_conexion
select vista1
scan
	mAsignadoA = AsignadoA
	mAtendioRec = AtendioRec
	mAtendioSol =   AtendioSol
	mCodSector=CodSector
	mDetalle = Detalle
	mEstado =  Estado
	mFechaGraba = FechaGraba + iif(month(FechaGraba )<7,365,182)*24*3600
	mFechaPrevista = FechaPrevista + iif(month(FechaPrevista )<7,365,182)
	mFechaSolucion = FechaSolucion + iif(month(FechaSolucion )<7,365,182)*24*3600
	mIDPuesto = IDPuesto
	mInternoTE = InternoTE
	mMotivo =  Motivo
	mNroReclamo = NroReclamo
	mPrioridad = Prioridad
	mSector = Sector
	mSoluciones = Soluciones
	mUsuario = Usuario
	mSolucion  = '<>'

	mret = sqlexec(mcon1, "insert into TabReclamos(AtendioRec, CodSector,"+;
		" Estado, FechaGraba, FechaPrevista, FechaSolucion ,IDPuesto,"+;
		" InternoTE, NroReclamo, Prioridad, Detalle, Sector, Usuario" + ;
		" , AtendioSol, FechaSolucion, Soluciones, AsignadoA, Motivo )"+;
		" values(?mAtendioRec, ?mCodSector, ?mEstado, ?mFechaGraba,"+;
		"  ?mFechaPrevista, ?mFechaSolucion ,?mIDPuesto,?mInternoTE, ?mNroReclamo,"+;
		"  ?mPrioridad, ?mDetalle, ?mSector, ?mUsuario, " + ;
		" ?mAtendioSol, ?mFechaSolucion, ?mSoluciones,?AsignadoA, ?mmotivo )")
	if mret<1
		=aerr(eros)
		messagebox(eros(3))
		set step on
	endif
endscan
do sp_desconexion


