****
* Inserta registro de mesa de entrada
*****
Parameters mpaciente,mmotivo,mobserva,mCodEntidad,mcodamision
mret=SQLExec(mcon1,"SELECT HoraLLegada, HoraFinalizacion FROM SOCIOaux where id = 1","mwksocaux")

Go Top In mwkusuario
mnombre = Allt(mwkusuario.idusuario)
maten   = Sys(0)
mdtF    = sp_busco_fecha_serv('DT')
If Between(mdtF,mwksocaux.HoraLLegada ,mwksocaux.HoraFinalizacion )
	mret=SQLExec(mcon1,"SELECT	MAX(IdSocio) as IdSocio FROM SOCIO","mwkrreg")

	If mret < 0
		=Aerr(eros)
		Messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
	Else
		midpers= Nvl(mwkrreg.IdSocio,0) + 1
		mret =SQLExec(mcon1,"INSERT INTO Socioaux(ApellidoNombre, Atendido, "+;
			"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad,paciente)"+;
			"VALUES (?mpaciente,0,?mdtF,?mmotivo,?midpers,?mobserva,?mnombre,?maten,0, ?mCodEntidad,?mcodamision)")
		If mret<0
			=Aerr(eros)
			Messagebox("No se puede acceder a algunos Datos "+eros(3),0+64,"Usuario")
		Endif
	Endif
Endif
