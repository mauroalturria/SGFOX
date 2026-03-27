***
*** Generacion de planilla de Turnos
***
parameters mcodmed, mdesde1, mfecturno,manu,morden
if type ('morden')#"N"
	morden = 1
endif
do sp_busco_fechahora with mfecturno

mfechora = mwkfechora.hora
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.diasem, "+;
	"turnos.codmed, codreserva , fechatomado, turnos.codserv, " +;
	"REG_nrohclinica, REG_numdocumento,REG_nombrepac, turnos.afiliado, " + ;
	"hca_estado, hca_codbarra, hca_usuario, hca_fechaInic, REG_nroregistrac as hca_registrac, "+;
	"hce_traslado, hce_color, hce_descrip, codprest,hhmmtur," + ;
	"turnos.codesp, tipoturno, abrevio, turnos.codent "+ ;
	"from turnos, registracio "+;
	" left join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac "+;
	" left join TabHCEstado on TabHCEstado.hce_id = TabHCArchivo.hca_estado "+;
	" left join TabHCUbica  on TabHCUbica.codubi = TabHCArchivo.hca_motfalta "+;
	"where  turnos.codmed = ?mcodmed and turnos.codserv <> 1130 and " + ;
	"turnos.afiliado = registracio.REG_nroregistrac and "+;
	"turnos.fechatur = ?mfecturno " , "mwkphorario01")

select mwkphorario01.*,iif(mfechora<fechatomado,1,0) as pend,mwkentexc.tipoturno as fecpasiva from mwkphorario01 left join mwkentexc on mwkphorario01.codent=mwkentexc .codent ;
	where  codesp not in ('NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOO', 'ECOC', 'ECOG', 'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') ;
	and  (at('28010', alltrim(str(CODprest))) # 1 or CODprest = 28010602);
	and at('20012', alltrim(str(CODprest)) )# 1 and !inlist(CODprest,78010600,78010601,67010201,22020300);
	group by fechatur, afiliado, codreserva into cursor mwkphorario1

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_avo_1',transf(mcodmed)+"!"+transf(mdesde1)+"!"+transf(mfecturno)+"!"+transf(manu)+"!"+transf(morden)
	cancel
endif

**turnos.CODprest like '28010%'

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, " + ;
	" turnos.diasem, turnos.codmed, turnos.afiliado , " + ;
	" turnos.codreserva , fechatomado, turnos.codserv, ('0000000000') as REG_nrohclinica,codprest,hhmmtur, " + ;
	" nrodocumento as REG_numdocumento, (preregistra.nombre) as REG_nombrepac, " + ;
	" null as hca_estado, null as hca_codbarra, null as hca_fechaInic, null as hca_registrac, " + ;
	" null as hce_descrip, turnos.codesp, null as hce_traslado, null as hce_color, " + ;
	" null as fechasalst, null as fechasalct, tipoturno, null as abrevio, null as hca_usuario, turnos.codent  " + ;
	" from turnos, preregistra  "+;
	" where turnos.afiliado = preregistra.id and " + ;
	" turnos.codmed = ?mcodmed and turnos.codserv <> 1130 and " + ;
	" turnos.fechatur = ?mfecturno " , "mwkphorario02")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_avo_2',transf(mcodmed)+"!"+transf(mdesde1)+"!"+transf(mfecturno)+"!"+transf(manu)+"!"+transf(morden)
	cancel
endif
select mwkphorario02.*,iif(mfechora<fechatomado,1,0) as pend,mwkentexc.tipoturno as fecpasiva from mwkphorario02 left join mwkentexc on mwkphorario02.codent=mwkentexc .codent ;
	where  codesp not in ('NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') ;
	and codserv <> 1130 and  (at('28010', alltrim(str(CODprest))) # 1 or CODprest = 28010602);
	and at('20012', alltrim(str(CODprest)) )# 1 and !inlist(CODprest,78010600,78010601,67010201,22020300);
	group by fechatur, afiliado, codreserva into cursor mwkphorario2
mfechanula = ctot("01/01/1900 00:00:00")
msqlorden = iif(morden=1,"asc","desc")
mret = sqlexec(mcon1, "select hcm_registrac, hcm_codmed, hcm_fechatur as fechasalct " +;
	" from TabHCMovct  "+;
	" where hcm_fechaIngr = ?mfechanula " ,"mwkpcons011")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_avo_3',transf(mcodmed)+"!"+transf(mdesde1)+"!"+transf(mfecturno)+"!"+transf(manu)+"!"+transf(morden)
	cancel
endif

select hcm_registrac, hcm_codmed, fechasalct,nombre  from mwkpcons011  ;
	left outer join mwkpmed on hcm_codmed = mwkpmed.id ;
	order by fechasalct &msqlorden into cursor mwkpcons11

select * from mwkpcons11 group by hcm_registrac into cursor mwkpcons1

mret = sqlexec(mcon1, "select hcm_registrac, hcm_descMed, hcm_fechatur as fechasalst " +;
	" from TabHCMovst  "+;
	" where hcm_fechaIngr = ?mfechanula ", "mwkpcons022")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_avo_4',transf(mcodmed)+"!"+transf(mdesde1)+"!"+transf(mfecturno)+"!"+transf(manu)+"!"+transf(morden)
	cancel
endif

select * from mwkpcons022  order by fechasalst &msqlorden into cursor mwkpcons22

select * from mwkpcons22 group by hcm_registrac into cursor mwkpcons2

select mwkpcons11
use
select mwkpcons22
use

select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, fechatur, mwkmpfecha.nombre, afiliado, ;
	reg_numdocumento, horatur, mwkphorario1.id, mwkphorario1.codmed, mwkmpfecha.diasem, horadesde, nvl(hca_estado,00) as hca_estado ,;
	left(right(alltrim(reg_nrohclinica), 4), 2) as termina, ;
	nvl(hca_codbarra, space(13)) as hca_codbarra, ;
	iif(isnull(hca_fechainic),{^1900-01-01},ttod(hca_fechainic)) as hca_fechainic,;
	nvl(hca_registrac, 0000000000) as hca_registrac, ;
	nvl(hcm_descmed, space(40)) as hcm_descmed, nvl(hcm_codmed,0000) as hcm_codmed, ;
	nvl( mwkpcons1.nombre, space(40)) as nombre2, iif(isnull(fechasalst),"     ",left(ttoc(fechasalst),5)) ;
	+ iif(isnull(fechasalct),"     ",left(ttoc(fechasalct),5)) as fechasal;
	,nvl(hce_descrip, padr("NO INGRESADA",20 )  ) as hce_descrip  ;
	, mwkphorario1.codesp, nvl(hce_traslado,.f.) as hce_traslado ;
	,nvl(hce_color,1) as hce_color ,nvl(hca_usuario,space(20)) as hca_usuario  ;
	, tipoturno,nvl(abrevio,"     ") as abrevio,iif(isnull(fecpasiva),0,1) as PAC_excl,pend,mwkphorario1.codprest ;
	from mwkphorario1 ;
	left join mwkpcons1 on mwkpcons1.hcm_registrac = afiliado and hca_estado = 3;
	left join mwkpcons2 on mwkpcons2.hcm_registrac = afiliado and hca_estado = 5;
	left join mwkmpfecha on (mwkphorario1.codmed = mwkmpfecha.codmed and ;
	mwkphorario1.codprest = mwkmpfecha.codprest and ;
	mwkphorario1.fechatur >= mwkmpfecha.fecvigend and ;
	mwkphorario1.fechatur < mwkmpfecha.fecvigenh and ;
	mwkphorario1.hhmmtur >= mwkmpfecha.hhmmdes and ;
	mwkphorario1.hhmmtur<mwkmpfecha.hhmmhas and ;
	mwkphorario1.diasem = mwkmpfecha.diasem );
	order by horatur, afiliado;
	group by horatur, afiliado;
	into cursor mwkphorariot



select hora, reg_nombrepac, reg_nrohclinica, fechatur, nombre, afiliado ;
	,reg_numdocumento, horatur, id, codmed, diasem, horadesde, hca_estado ;
	,termina, hca_codbarra, hca_fechainic, hca_registrac ;
	,nvl(hce_color,1) as hce_color,nvl(hca_usuario,space(20)) as hca_usuario   ;
	,iif(hce_traslado and !isnull(fechasal), padr(left(alltrim(fechasal) + '-' ;
	+ alltrim(nvl(nombre2,"")),20),20);
	, hce_descrip ) as hce_descrip ;
	, codesp, hce_traslado, tipoturno, abrevio,pac_excl,pend,mwkphorariot.codprest  ;
	from mwkphorariot ;
	order by horatur, afiliado;
	into cursor mwkphorario3

select mwkphorariot
use

select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, fechatur, nombre, afiliado, ;
	reg_numdocumento, horatur, mwkphorario2.id, mwkphorario2.codmed, mwkphorario2.diasem, horadesde, ;
	nvl(hca_estado,04) as hca_estado ,;
	left(right(alltrim(reg_nrohclinica), 4), 2) as termina,  ;
	nvl(hca_codbarra, space(13)) as hca_codbarra, ;
	nvl(hca_fechainic,ctot("01/01/1900 00:00:00")) as hca_fechainic,;
	nvl(hca_registrac, 0000000000) as hca_registrac, ;
	nvl(hce_descrip, padr("PREREGISTRADO",20 )) as hce_descrip,nvl(hce_color,4) as hce_color  ;
	, mwkphorario2.codesp,  space(40) as nombre2, nvl(mwkphorario2.abrevio,"     ") as abrevio;
	, nvl(hce_traslado,.f.) as hce_traslado, tipoturno,nvl(hca_usuario,space(20)) as hca_usuario,;
	iif(isnull(fecpasiva),0,1) as PAC_excl,pend,mwkphorario2.codprest  ;
	from mwkphorario2 ;
	left join mwkmpfecha on (mwkphorario2.codmed = mwkmpfecha.codmed and ;
	mwkphorario2.codprest = mwkmpfecha.codprest and ;
	mwkphorario2.fechatur >= mwkmpfecha.fecvigend and ;
	mwkphorario2.fechatur < mwkmpfecha.fecvigenh and ;
	mwkphorario2.hhmmtur >= mwkmpfecha.hhmmdes and ;
	mwkphorario2.hhmmtur<mwkmpfecha.hhmmhas and ;
	mwkphorario2.diasem = mwkmpfecha.diasem );
	order by horatur, afiliado;
	group by horatur, afiliado;
	into cursor mwkphorario4

if reccount('mwkphorario4')>0

	select hora, reg_nombrepac, reg_numdocumento, reg_nrohclinica, termina, ;
		iif(pend=1,"*","")+alltrim(hce_descrip) + " " + alltrim(abrevio) as descestado,PAC_excl,pend ,afiliado;
		, hca_estado, hca_codbarra, horadesde, ttod(hca_fechainic) as hca_fechainic, hca_registrac, codesp, fechatur, nombre;
		, codmed, hce_traslado, horatur, tipoturno, hce_color,hca_usuario,hce_descrip from mwkphorario4 ;
		union ;
		select hora, reg_nombrepac, reg_numdocumento, reg_nrohclinica, termina, ;
		iif(pend=1,"*","")+alltrim(hce_descrip) + " " + alltrim(abrevio) as descestado,PAC_excl,pend ,afiliado;
		, hca_estado, hca_codbarra, horadesde, hca_fechainic, hca_registrac, codesp, fechatur, nombre;
		, codmed, hce_traslado, horatur, tipoturno, hce_color,hca_usuario,hce_descrip ;
		where codesp in ('AUDI', 'OTOR', 'INVE') ;
		from mwkphorario3;
		group by afiliado into cursor mwkhora
else
	select hora, reg_nombrepac, reg_numdocumento, reg_nrohclinica, termina;
		,iif(pend=1,"*","")+alltrim(hce_descrip) + " " + alltrim(abrevio) as descestado,PAC_excl,pend ,afiliado;
		, hca_estado, hca_codbarra, horadesde, hca_fechainic, hca_registrac, codesp, fechatur, nombre;
		, codmed, hce_traslado, horatur,tipoturno, hce_color,hca_usuario,hce_descrip ;
		where codesp in ('AUDI', 'OTOR', 'INVE') ;
		from mwkphorario3 ;
		group by afiliado into cursor mwkhora

endif

msql_reg = 'select * from mwkhora order by hora,REG_nombrepac,tipoturno into cursor mwkplanilla'

select mwkpcons1
use
select mwkpcons2
use
select mwkphorario1
use
select mwkphorario2
use
select mwkphorario3
use
select mwkphorario4
use
