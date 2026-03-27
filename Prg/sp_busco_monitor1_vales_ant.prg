parameters mfecdes,mbus,mfecfull,mlistar,mservicio,mestado,mchkvale,;
	mtxtvale,mchkcta,mbcuenta,mfecfullhas
if vartype(mfecfullhas)#"T"
	mfecfullhas= sp_busco_fecha_serv("DT")
endif
do case
	case mchkvale = 1
		mmesag = 'EL VALE SOLICITADO,'
		migual = mtxtvale
		mwhere = " where val_codvaleasist=?migual and VAL_codservvale in "+mbus
	case mchkcta = 1
		mmesag = 'EL NRO. DE CUENTA SOLICITADO,'
		migual = mbcuenta
		mwhere = " where val_codadmision=?migual and VAL_codservvale in "+mbus
	otherwise
		if len(mbus)>1
			mwhere = " where VAL_fechasolicitud >= ?mfecdes and VAL_codservvale in "+mbus
		else
			mwhere = " where VAL_fechasolicitud >= ?mfecdes"
		endif
endcase

if mchkvale=1 or mchkcta=1
	malerta = 0
	if used("mwkbus1")
		use in mwkbus1
	endif
	if mchkvale=1
		mret = sqlexec(mcon1,"select * from valesasist where val_codvaleasist=?migual","mwkbus1")
	else
		mret = sqlexec(mcon1,"select * from valesasist where val_codadmision=?migual","mwkbus1")
	endif
	if mret > 0
		if reccount("mwkbus1") = 0
			malerta = 1
		endif
		use in mwkbus1
	else
		messagebox("ERROR EN BUSQUEDA, MAESTRO DE VALES",0+48,"ERROR")
	endif
endif

*
* Para Nro. de Cuenta
* migual = '220692-5'
* mwhere = " where val_codadmision=?migual and VAL_codservvale in "+mbus
*
* Para Nro. de Vale
* migual = 13043615
* migual = 13043999 && No ubicado para probar
* mwhere = " where val_codvaleasist=?migual and VAL_codservvale in "+mbus
*
if used("mwkvalesfar0")
	use in mwkvalesfar0
endif

mleft = "left outer join TabValObs on TVO_codpun = VAL_codpun "+;
	"left outer join TabEstados on SubEstado = TVO_SubEstado and Propietario = 32 and Estado = ?mdestino"

* where and TVO_subestado>0

mdestino = zzdesti

mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud,"+ ;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
	"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,"+;
	"VAL_estado,nvl(Descrip,'SOLICITADO') as tsolicita,nvl(Tipo,0) as ttipo "+;
	"from valesasist "+mleft+;
	mwhere,"mwkvalesfar0")

if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS 111111", 16, "Validacion")
	return
endif

mwhere = ''

if mlistar = 1
	mwhere = "and ttipo = 0"
endif


select mwkvalesfar0.*,sp_busco_npac(VAL_codadmision) as PAC_nombrepaciente ;
	from mwkvalesfar0 ;
	where val_codsector<>'GUA' and val_codsector<>'AMB' &mwhere into cursor mwkvalesfar0
if !used('mwkpMed')
	do sp_busco_phordatos
endif
mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico "+;
	"from servicios, servcargval " + ;
	"where ser_codserv = servcargval.scv_codservicio " + ;
	"and scv_mnemonico is not null and ser_fechapasiva is null "+;
	"order by ser_descripserv", "mwkserv")
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	return
endif

select * from mwkserv,mwkcodserv ;
	where mwkcodserv.scv_codservicio = mwkserv.ser_codserv into cursor mwkserv

select *, ctot(dtoc(VAL_fechasolicitud)+ " " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as fechahora from mwkvalesfar0 ;
	into cursor mwkcons_prev

if mchkvale = 1 or mchkcta = 1
	mctrl = 1
	select mwkcons_prev.*,nombre, ser_descripserv, ser_codserv,scv_mnemonico from  mwkcons_prev;
		left join mwkpmed on val_prestador = mwkpmed.id ;
		left join mwkserv on val_codservvale = mwkserv.ser_codserv ;
		where mctrl = 1 ;
		into cursor mwkconsumoss
else
	select mwkcons_prev.*,nombre, ser_descripserv, ser_codserv,scv_mnemonico from  mwkcons_prev;
		left join mwkpmed on val_prestador = mwkpmed.id ;
		left join mwkserv on val_codservvale = mwkserv.ser_codserv ;
		where fechahora >= mfecfull and fechahora <=mfecfullhas ;
		into cursor mwkconsumoss
endif

select * from mwkconsumoss order by VAL_fechasolicitud desc,VAL_horasolicitud desc,VAL_tipopaciente asc;
	into cursor mwkconsumoss

if used('mwkconsu')
	use in mwkconsu
endif

create cursor mwkconsu;
	(esta n(1), VAL_tsolicita c(30), VAL_codadmision c(8), VAL_fechasolicitud c(16),val_codsector c(3), VAL_codvaleasist n(8), ;
	VAL_nroprotocolo c(10), VAL_habitacion c(5), VAL_cama c(3), PAC_nombrepaciente c(40), ser_descripserv c(30),nombre c(40),;
	VAL_tipopaciente c(3),;
	ser_codserv n(4), scv_mnemonico c(2), VAL_ttipo n(1),VAL_estado n(1))

create cursor mwkconsu3;
	(esta n(1), VAL_tsolicita c(30), VAL_fechasolicitud c(16),VAL_codadmision c(8),VAL_codvaleasist n(8), PAC_nombrepaciente c(40),;
	val_codsector c(3),VAL_habitacion c(5),VAL_cama c(3),sectorn c(3), habitan c(5), caman c(3),;
	ser_descripserv c(30),VAL_nroprotocolo c(10), nombre c(40),;
	VAL_tipopaciente c(3),;
	ser_codserv n(4), scv_mnemonico c(2), VAL_ttipo n(1),scamhab1 c(14),scamhab c(14), compara c(14), sfecha c(16), svip c(1),VAL_estado n(1) )

select mwkconsumoss
go top
scan
	mlcampo = dtoc(mwkconsumoss.VAL_fechasolicitud)+ " " +strtran(alltrim(mwkconsumoss.VAL_horasolicitud),".",":")
	insert into mwkconsu ;
		(esta,VAL_tsolicita,VAL_codadmision,val_codsector,VAL_fechasolicitud,VAL_codvaleasist,VAL_nroprotocolo,;
		VAL_habitacion,VAL_cama,PAC_nombrepaciente,ser_descripserv,nombre,VAL_tipopaciente,ser_codserv,scv_mnemonico,;
		VAL_ttipo,VAL_estado) ;
		values ;
		(0,mwkconsumoss.tsolicita,mwkconsumoss.VAL_codadmision,;
		mwkconsumoss.val_codsector,;
		mlcampo,;
		mwkconsumoss.VAL_codvaleasist,;
		iif(isnull(mwkconsumoss.VAL_nroprotocolo),space(10),str(mwkconsumoss.VAL_nroprotocolo)),;
		iif(isnull(mwkconsumoss.VAL_habitacion),space(5),mwkconsumoss.VAL_habitacion),;
		iif(isnull(mwkconsumoss.VAL_cama),space(3),mwkconsumoss.VAL_cama),;
		mwkconsumoss.PAC_nombrepaciente,;
		mwkconsumoss.ser_descripserv,;
		iif(isnull(mwkconsumoss.nombre),space(40),mwkconsumoss.nombre),;
		mwkconsumoss.VAL_tipopaciente,;
		mwkconsumoss.ser_codserv,;
		mwkconsumoss.scv_mnemonico,;
		mwkconsumoss.ttipo,mwkconsumoss.VAL_estado)
endscan
if len(alltrim(mservicio)) > 0 and len(alltrim(mestado)) > 0
	select * from mwkconsu where mwkconsu.VAL_tsolicita = mestado and mwkconsu.ser_descripserv = mservicio into cursor mwkconsu
else
	if len(alltrim(mestado)) > 0
		select * from mwkconsu where mwkconsu.VAL_tsolicita = mestado into cursor mwkconsu
	endif
	if len(alltrim(mservicio)) > 0
		select * from mwkconsu where mwkconsu.ser_descripserv = mservicio into cursor mwkconsu
	endif
endif

select *,nvl(sp_busca_monitor1_cambiohab( VAL_codadmision ),'') as scamhab1,;
	(alltrim(val_codsector)+','+;
	alltrim(VAL_habitacion)+','+;
	alltrim(VAL_cama)+;
	space(14-len(alltrim(val_codsector)+','+;
	alltrim(VAL_habitacion)+','+;
	alltrim(VAL_cama)))) as compara from mwkconsu into cursor mwkconsu

select *,left(scamhab1,14) as scamhab,;
	substr(scamhab1,18) as sfecha from mwkconsu into cursor mwkconsu

select mwkconsu
go top
scan
	if mwkconsu.compara <> mwkconsu.scamhab
		mhasta1  = at(',',mwkconsu.scamhab,1)
		mhasta2  = at(',',mwkconsu.scamhab,2)
		mhasta3  = mhasta2-mhasta1
		msector  = left(mwkconsu.scamhab,mhasta1-1)
		mpiso    = substr(mwkconsu.scamhab,mhasta1+1,mhasta3-1)
		mhab     = substr(mwkconsu.scamhab,mhasta2+1,3)
	else
		msector  = ''
		mpiso    = ''
		mhab     = ''
	endif

* Para Fila de color ante Entidades con Exclusividad

	mcodad = VAL_codadmision
	msecto = VAL_tipopaciente
	if used('mwkentexc')
		use in mwkentexc
	endif

	mret=sqlexec(mcon1,"select * from EntidExclu where EntidExclu.codent = "+;
		"(select COB_codentidad from coberturas where COB_pacientes = ?mcodad) and "+;
		"EntidExclu.tpopac = ?msecto and "+;
		"EntidExclu.fecpasiva = to_date('01/01/1900','dd/mm/yyyy')","mwkentexc")

	if mret > 0
		msvip = iif(reccount('mwkentexc')>0,'S','N')
	else
		msvip = 'N'
	endif

*
	insert into mwkconsu3 ;
		(esta,;
		VAL_tsolicita,;
		VAL_codadmision,;
		VAL_fechasolicitud,;
		val_codsector,;
		VAL_codvaleasist,;
		VAL_nroprotocolo,;
		VAL_habitacion,;
		VAL_cama,;
		PAC_nombrepaciente,;
		ser_descripserv,;
		nombre,;
		VAL_tipopaciente,;
		ser_codserv,;
		scv_mnemonico,;
		VAL_ttipo,;
		scamhab1,;
		compara,;
		scamhab,;
		sfecha,;
		sectorn,habitan,caman,svip,VAL_estado) ;
		values ;
		(mwkconsu.esta,;
		mwkconsu.VAL_tsolicita,;
		mwkconsu.VAL_codadmision,;
		mwkconsu.VAL_fechasolicitud,;
		mwkconsu.val_codsector,;
		mwkconsu.VAL_codvaleasist,;
		mwkconsu.VAL_nroprotocolo,;
		mwkconsu.VAL_habitacion,;
		mwkconsu.VAL_cama,;
		mwkconsu.PAC_nombrepaciente,;
		mwkconsu.ser_descripserv,;
		mwkconsu.nombre,;
		mwkconsu.VAL_tipopaciente,;
		mwkconsu.ser_codserv,;
		mwkconsu.scv_mnemonico,;
		mwkconsu.VAL_ttipo,;
		mwkconsu.scamhab1,;
		mwkconsu.compara,;
		mwkconsu.scamhab,;
		mwkconsu.sfecha,;
		msector,mpiso,mhab,msvip,mwkconsu.VAL_estado)
endscan

select mwkconsu3
go top

if reccount("mwkconsu3")=0 and (mchkvale=1 or mchkcta=1)
	if malerta = 1
		mmesag = mmesag +chr(10)+'NO HA SIDO UBICADO EN MAESTROS'
	else
		mmesag = mmesag +chr(10)+'NO PERTENECE AL DESTINO'
	endif
	messagebox(mmesag,0,"Validación")
else


endif



