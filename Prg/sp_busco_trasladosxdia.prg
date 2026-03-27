*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mturnoant, mturnosig, mmedico

if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

mret = sqlexec(mcon1, "select horatur, codreserva ,"+ ;
	" codmed, nombre, REG_nrohclinica, REG_nombrepac, afiliado " + ;
	"from registracio,turnos "+;
	"left outer join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.tipoturno < 9 and turnos.afiliado > 0 and " + ;
	"turnos.afiliado = registracio.REG_nroregistrac and "+;
	"turnos.codesp not in('NEUF', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') and " + ;
	"turnos.fechatur = ?mturnoant " + ;
	"group by afiliado " + ;
	"order by afiliado,horatur ", "mwkphorario1")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

mret = sqlexec(mcon1, "select fechatur,horatur, codreserva ,"+ ;
	" codmed, nombre, REG_nrohclinica, REG_nombrepac, afiliado " + ;
	"from registracio,turnos "+;
	"left outer join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.tipoturno < 9 and turnos.afiliado > 0 and " + ;
	"turnos.afiliado = registracio.REG_nroregistrac and "+;
	" turnos.codesp not in("+mfiltraesp +" 'CLIN','DERI','DERM','CARD','CARI','PEDI','CIRG', 'TRAU','NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') and " + ;
	" (not (turnos.CODprest like '28010%') or turnos.CODprest = 28010602 ) and " + ;
	" not (turnos.CODprest like '20012%') and " + ;
	"turnos.fechatur = ?mturnosig " + ;
	"group by afiliado,codmed " + ;
	"order by afiliado,horatur desc ", "mwkphorario21")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif
select * from mwkphorario21 group by afiliado into cursor mwkphorario2

select mwkphorario2.*,left(right(alltrim(mwkphorario2.REG_nrohclinica), 4), 2) as termina , mwkphorario1.nombre as nombreant ;
	from mwkphorario2 ;
	left join mwkphorario1 on mwkphorario1.afiliado = mwkphorario2.afiliado ;
	into cursor mwkphorario0

morden = iif(mmedico = 2 ," nombre ",iif(mmedico = 1 ," nombreant "," termina " ) ) 
select * from mwkphorario0 ;
	where !isnull(nombreant) ;
	order by &morden, REG_nombrepac	;
	into cursor mwkphorario
	