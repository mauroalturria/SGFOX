Parameters mfecdes, mfechas,mbusco  && se reutiliza para buscar por una prestacion o una especialidad

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
If Vartype(mbusco)<>"C"
	mbusco = " and tipoturno = 5 "
Endif
mret = SQLExec(mcon1,"select turnos.codprest,PRE_descriprest,turnos.codesp,turnos.fechatur, turnos.horatur,turnos.confirmado, " + ;
	"prestadores.Nombre,turnos.codreserva, " + ;
	"turnos.usuario, turnos.fechatomado, " + ;
	"Entidades.ENT_descrient, Turnos.observa,Turnos.codmed " + ;
	"from Turnos,prestacions " + ;
	"Left join prestadores on turnos.codmed = Prestadores.Id " + ;
	"left join Entidades on turnos.codent = Entidades.ENT_codent " + ;
	"where  &mccpoamb turnos.codreserva<>'' and codprest = pre_codprest and fechatur between ?mfecdes and ?mfechas " +mbusco+ ;
	" Order by turnos.horatur ","mwkTurnosTom")

If mret <= 0
	Aerror(eros)
	Messagebox("ERROR AL CONSULTAR TURNOS TOMADOS",48,"VALIDACION")
	Return .F.
Endif
