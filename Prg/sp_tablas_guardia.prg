****
** Tablas para Guardia
****
use in select("mwkptosvt1")
use in select("mwkptosvta")

mret = sqlexec(mcon1,"select Descripcion, FechaAlta, FechaPasiva,PuntodeVenta " + ;
	" from Puntosdeventa where TipoPuntoVenta = 1 ", "mwkptosvt1")
select *,iif(at('Ambulatorio',Descripcion)>0,"0016",iif(at('Guardia',Descripcion)>0,"0017","0019")) as origen ;
	from mwkptosvt1 into cursor mwkptosvta


use in select("mwkTCte")
mret = sqlexec(mcon1,"select descrip, abrevio, ID, codafip " + ;
	" from tabformularios where id<=5 and abrevio<>'' ", "mwkTCte")

use in select("mwkdocu")
mret = sqlexec(mcon1,"select abrevio, descrip, codigovax, id " + ;
	"from tabdocumentos where id<100000 order by id", "mwkdocu")

use in select("mwkdocent")
mret = sqlexec(mcon1," SELECT TDE_CodigoDoc , TDE_CodEnt , TDE_DescripEnt , "+;
	"tde_idtabdocumentos,abrevio,descrip from tabdocent,tabdocumentos "+;
	" where tde_idtabdocumentos = tabdocumentos.id ","mwkdocent")

use in select("mwkespe")
mret = sqlexec(mcon1,"select descrip, codesp, atiendeen from guardiaespecialid " + ;
	"where id<100000 order by descrip", "mwkespe")
mret = SQLExec(mcon1,"select descrip, id, sector from tabmotivos " + ;
	" where sector = 1 and id <100000 order by descrip", "mwkmotCose")

mret = SQLExec(mcon1,"select Descripcion , ID , TipoAten  from CosegurosTipoAtencion " , "mwktipoaten")

use in select("mwkentidad1")
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_tipo,ENT_codagrup, ENT_nroprestadorexterno from entidades " + ;
	"where ent_fecpas is null and (ent_capita is null or ent_capita <> 'S') and " + ;
	"(ent_turnoshabilit is null or ent_turnoshabilit <> 'S') " + ;
	"order by ent_descrient", "mwkentidad1")

use in select("mwkentexg")
mret = sqlexec(mcon1, "select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'GUA' union select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'INT' and codent not in ( select codent from entidexclu "+;
	"where tpopac = 'GUA')","mwkentexg")

use in select("mwkentidad2")
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_capita,ENT_codagrup,ENT_tipo,ENT_nroprestadorexterno from entidades " + ;
	"where ent_fecpas is null and (ent_turnoshabilit is null or ent_turnoshabilit <> 'S') " + ;
	"order by ent_descrient", "mwkentidad2")

if used("mwktaltas")
	use in mwktaltas
ENDIF


mret = SQLExec(mcon1, "select codent, tipoturno, tpopac,tpopamb, tpopgua, tpopint from entidexclu  " + ;
	"where fecpasiva = '1900-01-01' and tpopac = 'TRA' " , "mwktraditum")
	 
mret = sqlexec(mcon1,"select descrip, id, sector,tipoest,ambito,orden from tabtipoaltas " + ;
	"where sector <3 and id<100000 and ambito<=2 " + ;
	"order by descrip", "mwktaltas")
*	"order by orden", "mwktaltas")

use in select("mwkserv")
mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv from servicios, servcargval " + ;
	"where ser_guardia = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
	"and scv_mnemonico is not null order by ser_descripserv", "mwkserv")

use in select("mwksecint")
mret = sqlexec(mcon1, "select * from tabsectorint where grupo <2 and id<100000  order by descrip", "mwksecint")

if !used("mwkCiap2e")
	do sp_tablas_cie
endif
mfecnul = ctod("01/01/1900")
use in select("mwkCieN")
mret = sqlexec(mcon1, "select * from  TabCieNanda order by descrip", "mwkCieN")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR DE TABLAS, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "Err sp_tablas_guardia"
	cancel
endif

use in select("mwkplanpre")
mret = sqlexec(mcon1, "select * from planes where fecpasivaplan = '1900-01-01' ", "mwkplanpre")

&&& motivo de reimpresion de placas
use in select("mwkmotivoR")
mret = sqlexec(mcon1,"select descrip, id, sector from tabmotivos " + ;
	" where sector = 2 order by descrip", "mwkmotivoR")

use in select('mwkautproto')
mret = sqlexec(mcon1, "select * from tabautProto where APA_fecpasiva = '1900-01-01' order by apa_codigo ", "mwkautproto")

use in select('mwkautpdet')
mret = sqlexec(mcon1, "select * from tabautPdet where APD_fecpasiva = '1900-01-01' ", "mwkautpdet")

if mret<0
	use in select('mwkautproto')
	create cursor mwkautproto (id n(1),APA_codesp c(4), APA_codigo c(4),APA_codprest c(4), APA_fecpasiva c(4), APA_tipo c(4))
ENDIF

mret = SQLExec(mcon1, "select entidad from coseguros  " + ;
	" where fechahasta>={fn curdate()} and tipopac = 'AMB' "+;
	" group by entidad " , "mwkentcose")
mret = SQLExec(mcon1, "select Descripcion,TipoAten from CosegurosTipoAtencion  " , "mwktipoatcose")

If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
