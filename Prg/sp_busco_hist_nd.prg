***
*** Generacion de planilla de Turnos
***
parameters mfecturno ,mfeccompl
do sp_busco_fechahora with mfecturno

mfechora = mwkfechora.hora
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''


mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.diasem, turnos.codmed, codreserva , " +;
	"reg_nrohclinica, reg_numdocumento,reg_nombrepac, turnos.afiliado, " + ;
	"hca_estado, hca_codbarra, hca_usuario, hca_fechainic, reg_nroregistrac as hca_registrac, "+;
	"hce_traslado, hce_color, hce_descrip, codprest,hhmmtur," + ;
	"turnos.codesp, tipoturno, nombre,fechatomado "+ ;
	"from turnos, prestadores,registracio  " + ;
	" left join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac "+;
	" left join TabHCEstado on TabHCEstado.hce_id = TabHCArchivo.hca_estado "+;
	" left join TabHCUbica  on TabHCUbica.codubi = TabHCArchivo.hca_motfalta "+;
	"where " + ;
	" turnos.CODprest not in (78010600,78010601,67010201,22020300) and (not (turnos.CODprest like '28010%') or turnos.CODprest = 28010602 ) and " + ;
	" not (turnos.CODprest like '20012%') and codserv <> 1130 and " + ;
	"turnos.codesp not in("+mfiltraesp +" 'CLIN','DERI','DERM','CARD','CARI','PEDI','CIRG', 'TRAU','KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') " + ;
	" and prestadores.id=codmed and " + ;
	"turnos.afiliado = registracio.reg_nroregistrac and "+;
	"turnos.fechatur = ?mfecturno and " + ;
	"turnos.fechatomado < ?mfeccompl  " + ;
	"group by turnos.fechatur, afiliado, turnos.codreserva " + ;
	"", "mwkphorario1")


if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

mfechades = prg_dtoc(mfecturno)
mfechahas = prg_dtoc(mfecturno+1)
mret = sqlexec(mcon1, "select hcm_registrac, hcm_codmed, hcm_fechatur " +;
	" from tabhcmovct  "+;
	" where hcm_fechatur >= ?mfechades  and hcm_fechatur < ?mfechahas " ,"mwkpcons")

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

select reg_nombrepac, reg_nrohclinica,nombre, nvl(hca_estado,11) as hca_estado ;
	,nvl(hce_descrip,"SIN INGRESAR") as hce_descrip,iif(mfechora<fechatomado,1,0) as pend ;
	from mwkphorario1;
	where transf(afiliado,"@L 9999999999")+transf(codmed,"@L 9999") ;
	not in (select transf(hcm_registrac,"@L 9999999999")+transf(hcm_codmed,"@L 9999");
	from mwkpcons);
	order by nombre into cursor mwkhcnd

select reg_nombrepac, reg_nrohclinica,nombre, nvl(hca_estado,11) as hca_estado ,;
	nvl(hce_descrip,"SIN INGRESAR") as hce_descrip ,iif(mfechora<fechatomado,1,0) as pend;
	from mwkphorario1;
	where transf(afiliado,"@L 9999999999")+transf(codmed,"@L 9999") ;
	in (select transf(hcm_registrac,"@L 9999999999")+transf(hcm_codmed,"@L 9999");
	from mwkpcons);
	order by nombre into cursor mwkhcyd

select count(hca_estado) as cantidad, sum(pend) as pend ,hce_descrip,hca_estado ;
	from mwkhcnd group by hca_estado into cursor mwktotales


select mwkpcons
use
select mwkphorario1
use
