****
* Inserta o actualiza registro de mesa de entrada
*****
Local lCierraCon
mcon1 = SQLConnect("conec01")
*mcon1 = SQLConnect("cataqas")

If Vartype(mconSql) = "U"
	Public mconSql
	mconSql = 0
Endif
If Vartype(mconSql) <> "N"
	mconSql = 0
ENDIF
SET STEP ON 
If mconSql = 0
	If !sp_conecta_sqlserver(.F.,.T.) > 0
		Return .F.
	Endif
	lCierraCon = .T.
Endif

mret = SQLExec(mcon1,"select ApellidoNombre, Atendido,CodEntidad, HoraAtencion, HoraFinalizacion,"+;
	"HoraLLegada, IdMotivo, IdSocio,  ObservaA, Observacion, Operadora,"+;
	"OperadoraA, PrioridadAt, PuestoAtencion,  idMotivoA, paciente FROM Socioaux where id>1 ","newsocio")

Select newsocio
Scan
	mpaciente = ApellidoNombre
	mmotivo = IdMotivo
	mobserva = Observacion
	mCodEntidad = CodEntidad
	mcodamision = paciente
	mnombre = Operadora
	maten   = PuestoAtencion
	mdtF    = HoraLLegada
	mret=SQLExec(mconSql,"SELECT MAX(IdSocio) as IdSocio FROM SQLUser.SOCIO","mwkrreg")
	midpers= Nvl(mwkrreg.IdSocio,0) + 1
	mret =SQLExec(mconSql,"INSERT INTO SQLUser.Socio(ApellidoNombre, Atendido, "+;
		"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad,paciente)"+;
		"VALUES (?mpaciente,0,?mdtF,?mmotivo,?midpers,?mobserva,?mnombre,?maten,0, ?mCodEntidad,?mcodamision)")
	If mret<0
		=Aerr(eros)
		Messagebox("No se puede acceder a algunos Datos - INSERT SOCIOS"+Chr(10)+eros(3),0+64,"Usuario")
	Endif
Endscan
If lCierraCon
	sp_desconecta_sqlserver()
Endif
?LEN('537,540,541,764,938,1336,10003,10065,10095,10153,10318,10342,10358,10360,10361,10528,10533,10545,10666,10790,10799')
 


