****
* Inserta o actualiza registro de mesa de entrada
*****
Parameters mpaciente,mmotivo,mobserva,mCodEntidad,mcodamision,mupdate,mids
Local lCierraCon

If Vartype(mconSql) = "U"
	Public mconSql
	mconSql = 0
Endif
If Vartype(mconSql) <> "N"
	mconSql = 0
Endif
If mconSql = 0
	If !sp_conecta_sqlserver(.F.,.T.) > 0
		Return .F.
	Endif
	lCierraCon = .T.
Endif
If Vartype(mupdate) <> "N"
	mupdate = 0
Endif
If mupdate = 1
***actualiza
	mnombre = Allt(mwkusuario.idusuario)
	maten   = Sys(0)
	mdtF    = sp_busco_fecha_serv('DT')
	mret =SQLExec(mcon1,"UPDATE Socio SET "+;
		"HoraFinalizacion=?mdtf, atendido=1, "+;
		"IdMotivoA=?mmotivo, ObservaA=?mobserva, PuestoAtencion=?maten,"+;
		"OperadoraA=?mnombre,Paciente=?mcodamision,prioridadat = ?0 "+;
		"WHERE IdSocio= ?mids")
	If mret<0
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

Else
	Go Top In mwkusuario
	mnombre = Allt(mwkusuario.idusuario)
	maten   = Sys(0)
	mdtF    = sp_busco_fecha_serv('DT')

	mret=SQLExec(mconSql,"SELECT MAX(IdSocio) as IdSocio FROM SQLUser.SOCIO","mwkrreg")

	If mret < 0
		=Aerr(eros)
		Messagebox("No se puede acceder a algunos Datos - SELECT SOCIOS" + Chr(10)+eros(3),0+64,"Usuario")
	Else
		midpers= Nvl(mwkrreg.IdSocio,0) + 1
		mret =SQLExec(mconSql,"INSERT INTO SQLUser.Socio(ApellidoNombre, Atendido, "+;
			"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad,paciente)"+;
			"VALUES (?mpaciente,0,?mdtF,?mmotivo,?midpers,?mobserva,?mnombre,?maten,0, ?mCodEntidad,?mcodamision)")
		If mret<0
			=Aerr(eros)
			Messagebox("No se puede acceder a algunos Datos - INSERT SOCIOS"+Chr(10)+eros(3),0+64,"Usuario")
		Endif
	Endif

Endif
If lCierraCon

	sp_desconecta_sqlserver()

Endif


