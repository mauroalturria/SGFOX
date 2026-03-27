Parameters mbusco   
mfechas= sp_busco_fecha_serv("DD")+2

mret = SQLExec(mcon1,"select PAC_codadmision , turnos.horatur " + ;
 	"from pacientes " + ;
	"INNER join pacinternad on pacinternad.pin_codadmision = pac_codadmision "+;
	"INNER join Turnos on afiliado = pac_codhci "+;
	"where turnos.codreserva<>'' and fechatur between {fn curdate()} and ?mfechas " +mbusco+ ;
	" Order by turnos.horatur ","mwkTurnosTom")

If mret <= 0
	Aerror(eros)
	Messagebox("ERROR AL CONSULTAR TURNOS TOMADOS",48,"VALIDACION")
	Return .F.
Endif
