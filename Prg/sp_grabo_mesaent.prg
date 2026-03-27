****
* Inserta registro de mesa de entrada
*****
parameters mpaciente,mmotivo,mobserva,mCodEntidad,mcodamision

go top in mwkusuario
mnombre = allt(mwkusuario.idusuario)
maten   = sys(0)
mdtF    = sp_busco_fecha_serv('DT')

mret=SQLEXEC(mcon1,"SELECT	MAX(IdSocio) as IdSocio FROM SOCIO","mwkrreg")

if mret < 0
	=aerr(eros)
	messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
else
	midpers= nvl(mwkrreg.IdSocio,0) + 1
	mret =SQLEXEC(mcon1,"INSERT INTO Socio(ApellidoNombre, Atendido, "+;
		"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad,paciente)"+;
		"VALUES (?mpaciente,0,?mdtF,?mmotivo,?midpers,?mobserva,?mnombre,?maten,0, ?mCodEntidad,?mcodamision)")
	if mret<0
		=aerr(eros)
		messagebox("No se puede acceder a algunos Datos "+eros(3),0+64,"Usuario")
	endif
endif
