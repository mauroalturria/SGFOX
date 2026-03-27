Parameters xmopc,xmnreg,xmcodent,mbusco  && se reutiliza para buscar por una prestacion o una especialidad

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
mfecdes = sp_busco_fecha_serv("DD")
If Vartype(mbusco)<>"C"
	mbusco = " "
Endif
mret = SQLExec(mcon1,"select turnos.codprest,PRE_descriprest,turnos.codesp,turnos.fechatur, turnos.horatur,turnos.confirmado, " + ;
	"prestadores.Nombre,turnos.codreserva, " + ;
	"turnos.usuario, turnos.fechatomado,Turnos.codmed " + ;
	"from Turnos,prestacions " + ;
	"Left join prestadores on turnos.codmed = Prestadores.Id " + ;
	"where  &mccpoamb codprest = pre_codprest and fechatur >= ?mfecdes and afiliado = ?xmnreg and codent = ?xmcodent " +mbusco+ ;
	" Order by turnos.horatur ","mwkTurnosTom")

If mret <= 0
	Aerror(eros)
	Messagebox("ERROR AL CONSULTAR TURNOS TOMADOS",48,"VALIDACION")
	Return .F.
Endif
Do Case
Case xmopc=1 &&&fecha del siguiente turno
	Select mwkTurnosTom
	Locate For confirmado = 0
	If Found()
		Return horatur
	Else
		Return Ctot("  /  /  ")
	Endif
Case xmopc=2 &&&prestacion del siguiente turno
	Select mwkTurnosTom
	Locate For confirmado = 0
	If Found()
		Return PRE_descriprest
	Else
		Return SPACE(50)
	Endif
Endcase
