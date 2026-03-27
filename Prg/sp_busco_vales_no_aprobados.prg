****
** busco los protocolos de vales no aprobados o suspendidos
****

parameter  maprob,noffice,ltodos,lvalint
if vartype(ltodos)#"N"
	ltodos = 1
endif
if vartype(noffice)#"N"
	ltodos = 1
endif
if vartype(lvalint)#"N"
	lvalint = 0
endif
use in select('mwkveoinsun')
use in select('mwkveoinsua')
use in select('mwktodoinsa1')

if !used ('mwkMedicopg')
	mret = SQLExec(mcon1,"SELECT id, nombre  FROM prestadores  " + ;
		" union  SELECT ID , nombre FROM TabMedExterno " + ;
		" where gerenciadora = 0 " , "mwkMedicopg" )
endif
mihoraactual = sp_busco_fecha_serv("DT")


lcSql = "select guardia.protocolo, REG_nombrepac, fechahoraing, fechahoraate,  " + ;
	"a.nombre as nombremed, guardiavale.diagnostico,PRE_especialidad, codprest , " + ;
	"b.nomape as nombreefe, aprobado ,nrovale,guardia.codmed   " + ;
	"from guardiavale " + ;
	"     inner join guardia on guardiavale.protocolo = guardia.protocolo  " + ;
	"     inner join registracio on guardia.nroregistrac = registracio.REG_nroregistrac  " + ;
	" inner join prestacions on Prestacions.PRE_codprest = Guardia.codprest  " + ;
	"     inner join tabusuario as b on guardia.usuario = b.idusuario " + ;
	" left join prestadores as a on guardia.codmed = a.id  " + ;
	"where exists(select 1 from guardiavale where guardiavale.codserv = 5410 " + maprob + " ) " + ;
	" and guardiavale.codserv = 5410 " + maprob + ;
	"order by REG_nombrepac "

mret = sqlexec(mcon1, lcSql, "mwkveoinsua")

*!*	mret = sqlexec(mcon1, "select guardia.protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
*!*		"a.nombre as nombremed, guardiavale.diagnostico,PRE_especialidad, codprest ," + ;
*!*		"b.nomape as nombreefe, aprobado ,nrovale,guardia.codmed  " + ;
*!*		"from registracio, tabusuario as b, guardiavale,guardia  " + ;
*!*		" left join prestadores as a on guardia.codmed = a.id " + ;
*!*		" inner join prestacions on Prestacions.PRE_codprest = Guardia.codprest " + ;
*!*		"where guardiavale.protocolo = guardia.protocolo  and " + ;
*!*		"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
*!*		"guardia.usuario		= b.idusuario and " + ;
*!*		"guardiavale.codserv	= 5410 " + maprob + ;
*!*		" order by REG_nombrepac " , "mwkveoinsua")


if ltodos = 0
	select  protocolo from mwkveoinsua where codprest = 42030723 into cursor mwkemer
	select  protocolo from mwkveoinsua where PRE_especialidad = 'PEDI' ;
		and protocolo not in ( select protocolo  from mwkemer ) ;
		into cursor mwkpedi
	select  protocolo from mwkveoinsua where protocolo not in ( select protocolo  from mwkemer ) ;
		and protocolo not in ( select protocolo  from mwkpedi) ;
		into cursor mwkclin
	do case
		case noffice = 1
			select *,"GUA" as tipopac  from mwkveoinsua where protocolo in (select protocolo  from mwkclin) group by protocolo into cursor  mwkveoinsun
		case noffice = 2
			if lvalint = 1
				do sp_busco_ultfechaVGua
				if mwkUfgua.Vale_Gua_Block
					messagebox('OTRO OPERADOR ESTA REALIZANDO EL PEDIDO. ESPERE POR FAVOR',48,"Bloqueo de pedido")
				else
					if (mihoraactual-mwkUfgua.Fecha_Uval_Gua)/3600<3
						messagebox('DEBEN REALIZAR SOLO DOS PEDIDOS POR DIA... SOLO CONTINUE SI NECESITA UNA REPOSICION URGENTE',48,"Bloqueo de pedido")
					endif

					fhlimite = nvl(mwkUfgua.Fecha_Uval_Gua,ctot("01/01/1900"))- 2*24*3600 &&& dos dias antes para seguridad 17/08/2017 a pedido del Lic.Vazquez
					fechalimite =ttod(fhlimite ) 
					fechaant = dtot(fechalimite )
					cflim = left(prg_dtoc(fechalimite),10)+ " "+ ttoc(fhlimite,2)
					miaprob = strtran(maprob,"aprobado","IPV_confirmado")
					mret = sqlexec(mcon1, "select IH_admision,IH_secuencia, pac_nombrepaciente , IH_fechaHoraIng ,VAL_OperadorCarga," + ;
						" VAL_fechasolicitud,VAL_horasolicitud,IH_motIngreso,nomape,val_codvaleasist,VAL_horacargasolic, VAL_fechacargasoli "+;
						" from valesasist "+;
						" inner join Tabinthce on Tabinthce.IH_admision = val_codadmision "+;
						" inner join pacientes on pac_codadmision = VAL_codadmision "+;
						" inner join tabusuario on  VAL_OperadorCarga = codigovax " + ;
						" where  VAL_codservvale=5410 and  VAL_fechasolicitud >= ?fechalimite and VAL_codsector in ('EME','CEG','IDE') and VAL_estado <> 3 " , "mwktodoinsa1")
					if mret<0
						=aerr(eros)
						messagebox(eros(3))
					endif

					select alltrim(strtran(IH_admision,"-",""))+"-"+transform(IH_secuencia,"@L 999") as protocolo, pac_nombrepaciente as REG_nombrepac, ;
						IH_fechaHoraIng as fechahoraing,	ctot(dtoc(VAL_fechacargasoli )+" "+ttoc(VAL_horacargasolic,2)) as fechahoraate, ;
						padr("MEDICO DE GUARDIA",40) as nombremed,space(50) as diagnostico,'INTE'  as PRE_especialidad, 0 as codprest ,  ;
						nomape as nombreefe, 0 as aprobado ,val_codvaleasist as nrovale,350 as  codmed  ;
						from mwktodoinsa1 group by ih_admision,val_codvaleasist into cursor mwktodoins1

*!*						mret = sqlexec(mcon1, "select Tabintpmvales.*, IH_admision,IH_secuencia, pac_nombrepaciente , IH_fechaHoraIng ,idcodmed ," + ;
*!*							" nomape,nombre,IH_motIngreso "+;
*!*							" from Tabintpmvales "+;
*!*							" inner join Tabinthce on Tabinthce.id = Tabintpmvales.IPV_idevol "+;
*!*							" inner join pacientes on pac_codadmision = Tabinthce.ih_admision "+;
*!*							" inner join tabusuario on  IPV_usuariomodif = idusuario " + ;
*!*							" left join prestadores  on IH_codmed = prestadores.id " + ;
*!*							" where IPV_vale > 0 and  IPV_fechormodif>= ?fechalimite and PAC_sectorinternac='EME' " ;
*!*							, "mwktodoinsa2")
*!*						if mret<0
*!*							=aerr(eros)
*!*							messagebox(eros(3))
*!*						endif
*!*						select alltrim(strtran(IH_admision,"-",""))+"-"+transform(IH_secuencia,"@L 999") as protocolo, pac_nombrepaciente as REG_nombrepac, ;
*!*							IH_fechaHoraIng as fechahoraing, IPV_fechormodif as fechahoraate,  ;
*!*							nombre as nombremed,IH_motIngreso as diagnostico,padr('INTERNACION',40)  as PRE_especialidad, 0 as codprest ,  ;
*!*							nomape as nombreefe, 0 as aprobado ,IPV_vale as nrovale,idcodmed as  codmed  ;
*!*							from mwktodoinsa2 group by ih_admision,IPV_vale into cursor mwktodoins2
*!*						select * from mwktodoins2 ;
*!*							union all select * from mwktodoins1 where nrovale not in (select nrovale from mwktodoins2 )	;
*!*							into cursor mwktodoins
					select * from mwktodoins1	into cursor mwktodoins
					select *,"INT" as tipopac ;
						from mwktodoins ;
						into cursor mwktodoinsumo
				endif
			endif
			select *,"GUA" as tipopac from mwkveoinsua where protocolo in (select protocolo  from mwkemer) group by protocolo into cursor  mwkveoinsung
			if used('mwktodoinsumo')
				if reccount('mwkveoinsung')>0
					select * from mwktodoinsumo group by protocolo ;
						union all select  protocolo+"   " as protocolo, REG_nombrepac, fechahoraing,	fechahoraate, ;
						nvl(nombremed,space(40)) as nombremed,diagnostico,PRE_especialidad, codprest ,  nombreefe, aprobado ,nrovale,codmed,tipopac  from mwkveoinsung;
						group by protocolo into cursor mwkveoinsun

				else
					select * from mwktodoinsumo group by protocolo into cursor mwkveoinsun
				endif
			else
				select * from mwkveoinsung into cursor mwkveoinsun
			endif


		case noffice = 3
			select *,"GUA" as tipopac from mwkveoinsua where protocolo in (select protocolo  from mwkpedi) group by protocolo into cursor  mwkveoinsun
	endcase
else
	select *,"GUA" as tipopac from mwkveoinsua group by protocolo into cursor  mwkveoinsun
endif
use in select('mwkveoinsu')
use dbf('mwkveoinsun') in 0 again alias mwkveoinsu

if mret<0
	=aerr(eros)
	messagebox(eros(3))
endif
&&&guardiavale.fechahora>='2006-07-25 01:30:00' and
