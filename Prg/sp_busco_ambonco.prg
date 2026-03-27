*
* Busqueda de registros Hosp. día oncológico
*
parameters mfecdes, mfechas,mnregx

mserv = 1130

cbusafil = ''
if vartype(mnregx) = "N"
	if mnregx > 0
		cbusafil =  " and afiliado = ?mnregx "
	endif
endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  turnos.codambito = ?mxambito and "
	mret = sqlexec(mcon1, "SELECT top 1 * from  tabambulatorio "+ ;
	" order by id", "mwkctrlamb")
	select mwkctrlamb
	scatter memvar
	if vartype(m.codambito)#"N"
		mccpoamb = ''
	endif	
	use in select("mwkctrlamb")
Endif 

use in select("mwkambonco")

mret = sqlexec(mcon1,"select Turnos.fechatur,"+;
	"TabAmbonco.TAO_flabor  , Registracio.REG_nombrepac ,"+;
	"TabAmbonco.TAO_autesque, TabAmbonco.TAO_autacomp   ,"+;
	"TabAmbonco.TAO_autprqui, TabAmbonco.TAO_autfarm    ,"+;
	"TabAmbonco.TAO_obsesque, TabAmbonco.TAO_obsacomp   ,"+;
	"TabAmbonco.TAO_obsprqui, TabAmbonco.TAO_fmedfarma  ,"+;
	"TabAmbonco.TAO_obsfarma, TabAmbonco.TAO_usuario    ,"+;
	"TabAmbonco.TAO_fechamov, TabAmbonco.TAO_registracio,"+;
	"TabAmbOnco.id as lid   , Turnos.id as ltid,"+;
	"Turnos.codprest as lpresta,"+;
	"Turnos.codserv as lserv   ,"+;
	"Turnos.observa  ,TabAmbonco.TAO_consentimiento ,"+;
	"Turnos.confirmado as lconfirma, Turnos.horatur, Turnos.nrovale,"+;
	"Registracio.REG_nroregistrac,Registracio.REG_numdocumento, Registracio.REG_nrohclinica, " + ;
	"Pre_codservicio, PRE_descriprest, ENT_descrient,ENT_nroprestadorexterno,codreserva  " +;
	" From Turnos"+;
	" Join Prestacions On Turnos.CodPrest = Prestacions.Pre_CodPrest " + ;
	" Join Registracio On REG_nroregistrac=Turnos.afiliado"+;
	" Join Entidades on Entidades.ENT_codent = turnos.codent"+;
	" Left Join TabAmbonco On ( TabAmbonco.TAO_Registracio=Registracio.REG_nroregistrac"+;
	" and TabAmbonco.TAO_idturnos = Turnos.id )"+;
	" Where &mccpoamb Turnos.codserv = ?mserv"+ cbusafil +;
	" and Turnos.fechatur >= ?mfecdes and Turnos.fechatur <= ?mfechas order by horatur desc","mwkamboncoa")

if mret < 0
	messagebox("EN CONSULTA DE HOSP. DE DIA ONCOLOGICO",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
select * from mwkamboncoa group by fechatur,codreserva,lpresta order by fechatur,REG_nombrepac ,codreserva,horatur into cursor mwkambonco
return .t.

