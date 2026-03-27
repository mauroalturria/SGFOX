*
* Busqueda de códigos de reserva, afiliados
*
Lparameters mfecha, mxesp

Use in select("mwkbase1")
Use in select("mwkbase2")
Use in select("mwkreservas")
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret = sqlexec(mcon1,"select REG_nombrepac,ENT_descrient,codreserva,horatur,fechatur,"+;
	"REG_nrohclinica,afiliado,nombre "+;
	" from turnos"+;
	" Join registracio on registracio.REG_nroregistrac = turnos.afiliado "+;
	" Join prestadores on prestadores.id = turnos.codmed "+;
	" Join Entidades on Entidades.ENT_codent = turnos.codent"+;
	" where &mccpoamb turnos.codreserva<>'' and (turnos.tipoturno < 9 or turnos.tipoturno >= 13) and turnos.codesp=?mxesp and fechatur=?mfecha and" +;
	" codreserva"+;
	" not in (select codreserva from turnos where (turnos.tipoturno < 9 or turnos.tipoturno >= 13) and "+;
	"turnos.codesp=?mxesp and fechatur>?mfecha)","mwkbase1")

If mret < 0
	Messagebox("CONSULTA DE TURNOS, CODIGOS DE RESERVAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

mret = sqlexec(mcon1,"select afiliado from turnos" +;
	" where &mccpoamb turnos.codreserva<>'' and (turnos.tipoturno < 9 or turnos.tipoturno >= 13) and codesp=?mxesp and fechatur=?mfecha and" +;
	" afiliado in (select afiliado from turnos where &mccpoamb (turnos.tipoturno < 9 or turnos.tipoturno >= 13) and codesp=?mxesp and fechatur>?mfecha )"+;
	" and codreserva"+;
	" not in (select codreserva from turnos where &mccpoamb (turnos.tipoturno < 9 or turnos.tipoturno >= 13) and codesp=?mxesp and fechatur>?mfecha )","mwkbase2")

If mret < 0
	Messagebox("CONSULTA DE TURNOS, NROS DE AFILIADO"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Select mwkbase1.*,mwkbase2.afiliado as lcontrol;
	from mwkbase1;
	left join mwkbase2 on mwkbase2.afiliado = mwkbase1.afiliado ;
	group by mwkbase1.afiliado,mwkbase1.codreserva ;
	order by REG_nombrepac;
	into cursor mwkreservas

Return .T.
