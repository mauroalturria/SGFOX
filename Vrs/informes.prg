USE c:\desaguemes\valesinfo.dbf IN 0 SHARED
SELECT 2
BROWSE LAST
select * from valesinfo group by val_codpun,val_proto
select * from valesinfo group by val_codpun,val_codadm,val_nropro into cursor cosa
select count(val_nropro) as doble ,* from cosa group by val_codadm where val_tipopa#"INT" into cursor cosas
select * from cosas where doble>1
select * from valesinfo where isnull(nrovale)
select * from cosas where doble>1
locate for val_codadm ='0KX686-1'
locate for val_codadm ='0KU603-1'
sum(doble) to aaa
?aaa
sum(doble) to aaa for val_tipopa#"INT"
?aaa
select count(val_nropro) as doble ,* from cosa where val_tipopa#"INT" group by val_codadm into cursor cosas
select * from cosas where doble>1 into cursor asasç
select * from cosas where doble>1 into cursor asas
BROWSE LAST
USE
SELECT 8
USE
SELECT 6
do clearall
select * from prestadores where usuarpas#upper(usuarpas)
update prestadores set usuarpas = upper(usuarpas) where usuarpas#upper(usuarpas)
select * from prestadores where usuarpas#upper(usuarpas)
append from dbf('vista5')
DO gofish.app
DO FORM c:\desaguemes\scx\frmadmision15.scx
DO gofish.app
USE c:\desaguemes\valesinfo.dbf IN 0 SHARED
SELECT 2
BROWSE LAST
select *,sum(nvl(codpun,0)) as infor from valesinfo group by  val_codadm into cursor valinfo
select *,sum(nvl(codpun,0)) as infor from valesinfo where val_tipopa#"INT" group by  val_codadm into cursor valinfo
select * from valinfo where infor = 0
SELECT 5
select * from valesinfo group by val_codpun,val_proto
select * from valesinfo group by val_codpun,val_codadm,val_nropro into cursor cosa
select count(val_nropro) as doble ,* from cosa group by val_codadm into cursor cosas
select * from cosas where doble=1
select *,sum(nvl(codpun,0)) as infor from valesinfo group by  val_codadm into cursor valinfo
BROWSE LAST
select * from valesinfo group by val_codpun,val_codadm,val_nropro into cursor cosa
select count(val_nropro) as doble ,* from cosa group by val_codadm into cursor cosas
select * from cosas where doble=1
select count(val_nropro) as doble ,*,sum(nvl(codpun,0)) as infor  from cosa group by val_codadm into cursor cosas
select * from cosas where doble=1
select * from cosas where doble=1 and infor = 0
select *,sum(nvl(codpun,0)) as infor from valesinfo where val_tipopa="INT" group by  val_codadm,val_fechas into cursor valinfoint
select * from cosas where infor = 0
BROWSE LAST
select * from vales_realprest group by val_codpun,val_codadmision,val_nroprotocolo,val_circuitoorigen into cursor cosa
select * from cosa group by val_codpun,val_codadmision  into cursor cosas
SELECT 9
SELECT 7
SELECT 9
select * from vales_realprest group by val_codpun,val_codadmision,val_nroprotocolo,val_medicosolicit into cursor cosa
select * from cosa group by val_codpun,val_codadmision  into cursor cosas
select * from cosa group by val_codadmision  into cursor cosas
select * from vales_realprest group by val_codpun,val_codadmision,val_nroprotocolo,val_circuitoorigen into cursor cosa
select * from cosa group by val_codadmision  into cursor cosas
select * from vales_realprest group by val_codadmision,val_circuitoorigen into cursor cosa
select * from cosa group by val_codadmision  into cursor cosas
select * from vales_realprest group by val_codadmision,val_medicosolicit into cursor cosa
MODIFY PROJECT c:\desaguemes\prj\pisos.pjx
select * from prestadores where usuarpas#upper(usuarpas)
update prestadores set usuarpas = upper(usuarpas) where usuarpas#upper(usuarpas)
select * from prestadores where usuarpas#upper(usuarpas)
select * from cosas where doble= 1
select * from valesinfo group by val_codadm,val_nropro where val_tipopa#"INT"
select * from valesinfo group by val_codpun,val_codadm,val_nropro where val_tipopa#"INT"
SELECT 2
BROWSE LAST
select * from cosas where doble= 1
select * from valesinfo group by val_codadm where val_tipopa#"INT"
select * from cosas where doble= 1
select * from cosas where doble>1
select * from cosas where doble= 1
select *,sum(nvl(codpun,0)) as infor from valesinfo where val_tipopa#"INT" group by  val_codadm into cursor valinfo
select * from  valinfo where infor = 0
SELECT 2
BROWSE LAST
select * from valesinfo where left(pre_descri)="ABDOM"
select * from valesinfo where left(pre_descri,5)="ABDOM"
select * from valesinfo where left(pre_descri,5)="ABDOM" order by val_codadm
select protos
scan
	miproto = protocolo
	select codprest from protogua where protocolo = miproto and codcie9 >0 group by codprest into cursor prestas
	select prestas
	mipres = ''
	scan	
		mipres = mipres + str(codprest)+chr(9)
	endscan
	update protgua set 	prestas = mipres where protocolo = miproto
	select protos
endscan
select * from valinfo group by val_codpun,val_nroproto,nroprotoco
select * from valinfo group by val_codpun,val_nropro,nroprotoco into cursor valinfo2
SELECT 43
BROWSE LAST
select *,sum(nvl(codpun,0)) as infor from valinfo2 where val_tipopa#"INT" group by  val_codadm into cursor valinfoamb
select *,sum(nvl(codpun,0)) as infor from valinfo2 where val_tipopa="INT" group by  val_codadm,val_fechas into cursor valinfoint
select * from valinfoint union select * from valinfoamb into cursor valinfogrp
update valinfo set estadoinfo = 0 where isnull(estadoinfo)
select * from valinfo order by val_codadm,val_fechas,val_codser,estadoinfo group by val_codpun,val_nropro,nroprotoco into cursor valinfo2
select *,sum(nvl(codpun,0)) as infor from valinfo2 where val_tipopa#"INT" group by  val_codadm,val_codser into cursor valinfoamb



select verproto
set step on
scan
	madmi = alltrim(admision)
	mserv = serv
	mfecha	= fecha
	if eof() or mserv = 0 or recno()>1650
		set step on
	endif
	wait windows admision + transf(fecha) nowait
	requery('vales_pro')
	select verproto
	if reccount('vales_pro')>0 and vales_pro.VAL_codadmision = alltrim(madmi)
		midato = vales_pro.nroprotocolo
		replace nproto with midato
	endif
endscan
