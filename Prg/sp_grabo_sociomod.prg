parameters mape, midA, mobA,mdtF,mpac,midI,mobI,mdtll,mdtA,mopA,maten,mopI,mprio

mret =sqlexec(mcon1," INSERT INTO SocioMod(ApellidoNombre, Atendido, "+;
	" HoraAtencion, HoraFinalizacion, HoraLLegada, "+;
	" IdMotivo, IdSocio, ObservaA, Observacion, "+;
	" OperadoraA, Operadora, puestoAtencion, IdMotivoA, "+;
	" Paciente,PrioridadAt )"+;
	" VALUES (?mape,1,?mdtA,?mdtF,?mdtll,?midI,?midsocio,"+;
	" ?mobA,?mobI,?mopA,?mopI,?maten,?midA,?mpac,?mprio)")

if mret < 0
	do log_errores with error(), message(), message(1), program(), lineno()
	return .t.
else
	return .f.
endif


