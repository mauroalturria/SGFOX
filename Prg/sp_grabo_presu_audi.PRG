Lparameters mpaciente, mnroafiliado, mobs, mfechasolic, mfechaautopres, mestadoactual, musuario, mlidpre, ;
	mCondpago, mDesenti, mIdmodulo, mObsest, mPlant, mSectsol, mValmod, mValtot

mret = SQLExec(mcon1, "insert into TabpAuditoria ( " + ;
	"paciente, NroAfiliado, observaciones, fechasolic, " + ;
	"fechaautopres, estadoactual, usuario, idpres, "+;
	"Condpago, Entidad, Idmodulo, Observestado, " + ;
	"Plantilla, Sectorsol, Valormod, Valortotal )" + ;
	" values( " + ;
	"?mpaciente, ?mnroafiliado, ?mobs, ?mfechasolic, ?mfechaautopres, " + ;
	"?mestadoactual, ?musuario, ?mlidpre, " + ;
	"?mCondpago, ?mDesenti, ?mIdmodulo, ?mObsest, " + ;
	"?mPlant, ?mSectsol, ?mValmod, ?mValtot )")

If mret < 0
	Aerror(eros)
	Messagebox(eros(3))
	Messagebox("ERROR EN LA CARGA DE AUDITORIA ",48,"VALIDACION")
	Return .F.
Endif
