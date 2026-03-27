****
** busca turnos dados paa una entidad y una prestacion
****
parameter mcodent, mcodespe, mfecdes, mfechas, mbusco

*!* *!* mwhereesp = iif( !empty(mcodespe),"turnos.codesp = ?mcodespe and " ,'')
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mccpocmed = " centromed = ?mxcentromedico and "
mret=sqlexec(mcon1,"SELECT  centromed,codmed,diasem, hhmmdes, hhmmhas,fecvigend, fecvigenh  "+;
	" from  franjahoraria  "+;
	" where &mccpoamb &mccpocmed fecvigenh >= ?mfecdes "+;
	" and  fecvigend <> fecvigenh "  ,"mwkfranjahT")
 
mwhereesp = iif( !empty(mcodespe),"turnos.codesp in "+ mcodespe + " and " ,'')

*!* mwhereent = Iif( !Empty(mcodent) ,"turnos.codent = ?mcodent and ", '' )

mwhereent = Iif( !Empty(mcodent) ,"turnos.codent in "+mcodent+" and ", '' )

mret = sqlexec(mcon1, "select horatur as fecha, nombre as profesional, " 	 + ;
	"REG_nombrepac as paciente, pre_descriprest as prestacion, " + ;
	"codreserva, turnos.usuario, fechatomado, REG_telefonos, REG_numdocumento, " + ;
	"turnos.codent, turnos.codesp,codmedsoli,confirmado,abreviatura,turnos.codmed,turnos.fechatur,turnos.diasem,turnos.hhmmtur "+;
	",Registracio.REG_bloq_comen, Registracio.REG_bloq_fecha,"+;
	"  Registracio.REG_bloq_oper,REG_email  " + ;
	"from turnos, prestadores, registracio, prestacions,tabtipoturno " + ;
	"where &mccpoamb turnos.codreserva<>'' and turnos.afiliado = REG_nroregistrac and " + ;
	"turnos.codmed = prestadores.id and turnos.tipoturno = tabtipoturno.tipoturno and  " + ;
	"turnos.codprest = pre_codprest and " + ;
	mwhereent + mwhereesp + mbusco + ;
	"turnos.fechatur >= ?mfecdes and " + ;
	"turnos.fechatur <= ?mfechas and " + ;
	"(turnos.tipoturno < 8 or turnos.tipoturno >9) " + ;
	"", "mwktodosr")

mret = sqlexec(mcon1, "select horatur as fecha, prestadores.nombre as profesional, " 	 + ;
	"preregistra.nombre as paciente, pre_descriprest as prestacion, " + ;
	"codreserva, turnos.usuario, fechatomado, preregistra.telefono as REG_telefonos"+;
	", preregistra.nrodocumento as REG_numdocumento, " + ;
	"turnos.codent, turnos.codesp,codmedsoli,confirmado,abreviatura,turnos.codmed,turnos.fechatur,turnos.diasem,turnos.hhmmtur    " + ;
	"from turnos, prestadores, preregistra, prestacions,tabtipoturno  " + ;
	"where &mccpoamb turnos.codreserva<>'' and turnos.afiliado = preregistra.id and turnos.tipoturno = tabtipoturno.tipoturno and " + ;
	"turnos.codmed = prestadores.id and " + ;
	"turnos.codprest = pre_codprest and " + ;
	mwhereent + mwhereesp + mbusco + ;
	"turnos.fechatur >= ?mfecdes and " + ;
	"turnos.fechatur <= ?mfechas and " + ;
	"(turnos.tipoturno < 8 or turnos.tipoturno >9) and turnos.afiliado > 1 " + ;
	"", "mwktodosp")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_turnos_por_entid_espe1'
	do prg_cancelo
endif
select * from mwktodosr;
	union all select *,space(200) as REG_bloq_comen, ctod("01/01/1900") as REG_bloq_fecha,;
	0 as REG_bloq_oper, SPACE(50) as REG_email from mwktodosp;
	into cursor mwktodos1
Select mwktodos1.*,mwkfranjahT.centromed;
	 From mwkfranjahT,mwktodos1 Where mwkfranjahT.codmed = mwktodos1.codmed ;
	AND mwkfranjahT.diasem = mwktodos1.diasem And mwkfranjahT.hhmmdes <= mwktodos1.hhmmtur ;
	AND mwkfranjahT.hhmmhas>= mwktodos1.hhmmtur And mwkfranjahT.fecvigend <= mwktodos1.fechatur ;
	AND mwkfranjahT.fecvigenh>= mwktodos1.fechatur order by  fecha into cursor mwktodos
use in  SELECT('mwktodosr')
use in  SELECT('mwktodosp')
use in  SELECT('mwktodos1')

