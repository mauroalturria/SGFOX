*
* Log de Presupuesto AMB
*
Lparameters mconpag,mentida,mfechas,mmodulo,mbusidp,;
	mnroafi,mobsest,mobserv,mpacien,mplanti,msector,;
	musuari,mvalorm,mestact,mfechaA,mvaltot

mret = sqlexec(mcon1,"insert into TabPAuditoria "+;
	"(CondPago,Entidad,FechaSolic,IdModulo,IdPres,NroAfiliado,"+;
	"ObservEstado,Observaciones,Paciente,Plantilla,SectorSol,"+;
	"Usuario,ValorMod,estadoactual,fechaAutoPres,valorTotal)"+;
	" values "+;
	"(?mconpag,?mentida,?mfechas,?mmodulo,?mbusidp,"+;
	"?mnroafi,?mobsest,?mobserv,?mpacien,?mplanti,"+;
	"?msector,?musuari,?mvalorm,?mestact,?mfechaA,"+;
	"?mvaltot)")

If mret < 0
	Messagebox("EN INGRESO DE MOVIMIENTO DE LOG PARA EL PRESUPUESTO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
