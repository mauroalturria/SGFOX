RESUME
CANCEL
DO FORM c:\desaguemes\scx\frmambula06.scx
RESUME
BROWSE LAST
RESUME
DO FORM c:\desaguemes\scx\frmambula06.scx
RESUME
msql = "Select " + ;
		"paciente, !inlist(codestado,1,20), prestacion, int(prg_edad(fechanac,,'N')) as ledad,"+;
		" iif(demanda=1,'DE','  ') as demanda," + ;
		"nvl(mensaje,space(250)) as mensaje, " + ;
		"sala, protocolo, nvl(mwkambu03.id,000000000) as id, codmed, ENT_descrient, " + ;
		"codent, codestado, fechahoraing, " + ;
		".ctrlcolor_grid(horatur) as ltiempo, .calid() as lid, " + ;
		"fechanac, codesp, codserv, nombre, horatur as turnopara," +;
		"hour(horatur)*100+minute(horatur) as horatur, " + ;
		"hour(fechahoraing)*100+minute(fechahoraing) as horadmite,reg_nroregistrac,codprest " + ;
		",iif(codmed = 533 and at('HOMINIS',ENT_descrient)>0 ,.pvezhominis(reg_nroregistrac),1 ) as pvezhom "+;
		",tipoest,tid "+;
		"from mwkambu03 " + ;
		"where (sala = '" + alltrim(.lcons) + "') or empty(sala) " + ;
		"order by " + queorden + " " + ;
		"into cursor mwkambu1a"
SELECT 58
BROWSE LAST
msql = "Select " + ;
		"paciente, !inlist(codestado,1,20), prestacion, int(prg_edad(fechanac,,'N')) as ledad,"+;
		" iif(demanda=1,'DE','  ') as demanda," + ;
		"nvl(mensaje,space(250)) as mensaje, " + ;
		"sala, protocolo, nvl(mwkambu03.id,000000000) as id, codmed, ENT_descrient, " + ;
		"codent, codestado, fechahoraing, " + ;
		".ctrlcolor_grid(iif(fechahoraing>horatur,fechahoraing,horatur) as ltiempo, .calid() as lid, " + ;
		"fechanac, codesp, codserv, nombre, horatur as turnopara," +;
		"hour(horatur)*100+minute(horatur) as horatur, " + ;
		"hour(fechahoraing)*100+minute(fechahoraing) as horadmite,reg_nroregistrac,codprest " + ;
		",iif(codmed = 533 and at('HOMINIS',ENT_descrient)>0 ,.pvezhominis(reg_nroregistrac),1 ) as pvezhom "+;
		",tipoest,tid "+;
		"from mwkambu03 " + ;
		"where (sala = '" + alltrim(.lcons) + "') or empty(sala) " + ;
		"order by " + queorden + " " + ;
		"into cursor mwkambu1a"
RESUME
DO FORM c:\desaguemes\scx\frmambula03.scx
RESUME
SELECT 51
BROWSE LAST
RESUME
SELECT 17
BROWSE LAST
SELECT 4
BROWSE LAST
DO FORM c:\desaguemes\scx\frmambula07.scx
RESUME
BROWSE LAST
select horahasta-horadesde as horas,* from tabsobretoa into cursor algo
BROWSE LAST
select horahasta-horadesde/3600 as horas,* from tabsobretoa into cursor algo
select (horahasta-horadesde)/3600 as horas,* from tabsobretoa into cursor algo
BROWSE LAST
select * from algo where horas<=2
copy to control type xls
copy to control type xl5
select (horahasta-horadesde)/3600 as horas,* from tabsobretoa into cursor algo
select * from algo where horas<=2
copy to control type xl5
do clearall
select *,left(av_aviso,250) as aviso1,substr(av_aviso,251,250) as aviso2,substr(av_aviso,501,250) as aviso3 ;
from vista9 into cursor avisos
BROWSE LAST
select *,len(av_aviso) as aa from vista9 into cursor vista91
BROWSE LAST
select *,len(av_aviso) as aa from vista9 order by aa desc into cursor vista91
BROWSE LAST
select *,left(av_aviso,250) as aviso1,substr(av_aviso,251,250) as aviso2,substr(av_aviso,501,250) as aviso3 ;
,substr(av_aviso,751,250) as aviso4,substr(av_aviso,1001,250) as aviso5,iif(aa>1250,"S","N") as continua ;
from vista91 into cursor avisos
BROWSE LAST
select *,left(av_aviso,250) as aviso1,left(substr(av_aviso,251,250),250) as aviso2,left(substr(av_aviso,501,250),250) as aviso3 ;
,left(substr(av_aviso,751,250),250) as aviso4,left(substr(av_aviso,1001,250),250) as aviso5,iif(aa>1250,"S","N") as continua ;
from vista91 into cursor avisos
BROWSE LAST
copy to avisos type xl5
SELECT 20
USE
SELECT 16
USE
SELECT 2
USE
SELECT 5
select len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol from guaevol
MODIFY PROJECT c:\desaguemes\prj\autorizaciones.pjx
DO FORM c:\desaguemes\scx\frmautor01.scx
RESUME
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol from guaevol into cursor evol 
SELECT 20
BROWSE LAST
select * from consulta order by lmc desc into cursor sss
BROWSE LAST
select * from consulta order by lan desc into cursor sss
BROWSE LAST
select * from consulta order by lef  desc into cursor sss
BROWSE LAST
select * from consulta order by levol  desc into cursor sss
BROWSE LAST
SELECT 9
SELECT 12
BROWSE LAST
SELECT 29
BROWSE LAST
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol from guaevol into cursor evol 
BROWSE LAST
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol from guaevol into order by levol desc cursor evol 
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol from guaevol order by levol desc into cursor evol
BROWSE LAST
select * from evol where protocolo = '1371703-11 '
select * from evol order by egm_fechah where protocolo = '1371703-11 '
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol from guaevol order by protocolo ,egm_fechah  into cursor evol
BROWSE LAST
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol from guaevol order by levol desc into cursor evol
BROWSE LAST
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol LEFT(EGM_EVOL,250) from guaevol order by levol desc into cursor evol
select *,len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol, LEFT(EGM_EVOL,250) from guaevol order by levol desc into cursor evol
BROWSE LAST
Estudio  Resultado  Unid.  Antecedente  Dif. tiempo  Valor Referencia
select *,left(eg_motconsulta,250) as MC1,left(eg_anteceden,250) as antec1,left(eg_exfisico,250) as ExFis1,;
len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol LEFT(EGM_EVOL,250) from guaevol order by levol desc into cursor evol 
select *,left(eg_motconsulta,250) as MotCons1,left(eg_anteceden,250) as antec1,left(eg_exfisico,250) as ExFis1,;
len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol,LEFT(EGM_EVOL,250) as evolmed  from guaevol order by protocolo ,egm_fechah   into cursor evol
BROWSE LAST
copy to evoluciones type xl5
USE c:\desaguemes\protogua.dbf IN 0 EXCLUSIVE
SELECT 20
BROWSE LAST
select * from protogua where protocolo not in (select protocolo from evol)
select *,left(eg_motconsulta,250) as MotCons1,left(eg_anteceden,250) as antec1,left(eg_exfisico,250) as ExFis1,;
len(eg_motconsulta) as lmc, len(eg_anteceden) as lan,len(eg_exfisico) as lef,;
len(egm_evol) as levol,LEFT(EGM_EVOL,250) as evolmed  from guaevol order by protocolo ,egm_fechah   into cursor evol
copy to evoluciones type xl5
select * from protogua where protocolo not in (select protocolo from evol)
select * from evol where protocolo not in (select protocolo from protogua )
select * from evol where protocolo in (select protocolo from protogua )
copy to evoluciones type xl5
SELECT 28
BROWSE LAST
USE
select *,padr(left(eg_motconsulta,250),250) as MC1,;
len(eg_motconsulta) as lmc, ;
len(egm_evol) as levol, padr(LEFT(EGM_EVOL,250),250)as evol1, padr(substr(EGM_EVOL,251,250),250)as evol2 from evoluc order by egm_proto into cursor evol 
select *,padr(left(eg_motconsulta,250),250) as MC1,;
len(eg_motconsulta) as lmc, ;
len(egm_evol) as levol, padr(LEFT(EGM_EVOL,250),250)as evol1;
, padr(substr(EGM_EVOL,251,250),250)as evol2 ;
from evoluc order by egm_proto,egm_fechah into cursor evol