BROWSE LAST
USE
SELECT 3
USE
SELECT 2
USE
tablerevert(.t.)
USE
MODIFY COMMAND c:\desaguemes\vrs\actualizo_admisss.prg
do sp_conexion
do sp_desconexion
select guaevol.*,nombre  from guaevol,mwkmedicogua where mwkmedicogua.id=guaevol.egm_codmed
select guaevol.*,nombre  from guaevol,mwkmedicogua where mwkmedicogua.id=guaevol.egm_codmed;
and !empty(eg_indicnurse)
SELECT 16
BROWSE LAST
select guaevol.*,nombre  from guaevol,mwkmedicogua where mwkmedicogua.id=guaevol.egm_codmed;
and !empty(eg_indicnurse) into cursor avola
select substr(eg_indicnurse,20,15) as nom from avola
BROWSE LAST
select substr(eg_indicnurse,20,16) as nom from avola
select substr(eg_indicnurse,20,20) as nom from avola
select substr(eg_indicnurse,18,20) as nom from avola
select substr(eg_indicnurse,16,20) as nom from avola
select substr(eg_indicnurse,20,20) as nom from avola
select substr(eg_indicnurse,20,18) as nom from avola
select substr(eg_indicnurse,20,16) as nom from avola
select substr(eg_indicnurse,20,16) as nomi,left(nombre,16) as nomp from avola
select substr(eg_indicnurse,20,15) as nomi,left(nombre,15) as nomp from avola
select substr(eg_indicnurse,20,16) as nomi,left(nombre,15) as nomp from avola
SELECT 21
BROWSE LAST
select substr(eg_indicnurse,20,16) as nomi,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
BROWSE LAST
select * from control where proto+nomi not in(select proto+nomp from control)
select * from control where alltrim(proto)+alltrim(nomi) not in(select alltrim(proto)+alltrim(nomp) from control)
SELECT 16
BROWSE LAST
SELECT 21
BROWSE LAST
select * from control where alltrim(proto)+alltrim(nomi) ;
SELECT 16
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) group by proto into cursor ver
BROWSE LAST
SELECT 16
SELECT 21
BROWSE LAST
select substr(strtran(eg_indicnurse,"Indicación Posterior al CIERRE del Protocolo ",""),20,16) as nomi,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
BROWSE LAST
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) group by proto into cursor ver
BROWSE LAST
select guaevol.*,nombre  from guaevol,mwkmedicogua where mwkmedicogua.id=guaevol.egm_codmed;
and !empty(eg_indicnurse) into cursor avola
select substr(strtran(eg_indicnurse,"Indicación Posterior al CIERRE del Protocolo ",""),20,16) as nomi,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) group by proto into cursor ver
BROWSE LAST
select fechaing,substr(strtran(eg_indicnurse,"Indicación Posterior al CIERRE del Protocolo ",""),20,16) as nomi,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
SELECT 1
BROWSE LAST
select fechahoraing,substr(strtran(eg_indicnurse,"Indicación Posterior al CIERRE del Protocolo ",""),20,16) as nomi,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) group by proto into cursor ver
BROWSE LAST
SELECT 1
BROWSE LAST
select fechahoraing,substr(eg_indicnurse,at("->"meg_indicnurse),20,16) as nomi;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
?at("->"meg_indicnurse)
?at("->",eg_indicnurse)
BROWSE LAST
?at(" ->",eg_indicnurse)
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
BROWSE LAST
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
BROWSE LAST
SELECT 1
BROWSE LAST
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
select guaevol.*,nombre  from guaevol,mwkmedicogua where mwkmedicogua.id=guaevol.egm_codmed;
and !empty(eg_indicnurse) into cursor avola
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
SELECT 20
BROWSE LAST
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,3)),16) as nomi3;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
BROWSE LAST
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,3)),16) as nomi3;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,4)),16) as nomi4;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
select * from control where !empty(nomi4)
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,3)),16) as nomi3;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,4)),16) as nomi4;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,5)),16) as nomi5;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
select * from control where !empty(nomi5)
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,3)),16) as nomi3;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,4)),16) as nomi4;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,5)),16) as nomi5;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,6)),16) as nomi6;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
select * from control where !empty(nomi6)
select fechahoraing,right(left(eg_indicnurse,at(" ->",eg_indicnurse)),16) as nomi;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,2)),16) as nomi2;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,3)),16) as nomi3;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,4)),16) as nomi4;
,right(left(eg_indicnurse,at(" ->",eg_indicnurse,5)),16) as nomi5;
,left(nombre,15) as nomp,eg_protocolo as proto from avola into cursor control
BROWSE LAST
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
or alltrim(proto)+alltrim(nomi2) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
or alltrim(proto)+alltrim(nomi2) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
or (!empty(alltrim(nomi2)) and alltrim(proto)+alltrim(nomi2) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
or (!empty(alltrim(nomi2)) and alltrim(proto)+alltrim(nomi2) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi3)) and alltrim(proto)+alltrim(nomi3) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
or (!empty(alltrim(nomi2)) and alltrim(proto)+alltrim(nomi2) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi3)) and alltrim(proto)+alltrim(nomi3) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi4)) and alltrim(proto)+alltrim(nomi4) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
group by proto into cursor ver
select * from control where alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
or (!empty(alltrim(nomi2)) and alltrim(proto)+alltrim(nomi2) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi3)) and alltrim(proto)+alltrim(nomi3) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi4)) and alltrim(proto)+alltrim(nomi4) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi5)) and alltrim(proto)+alltrim(nomi5) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
group by proto into cursor ver
BROWSE LAST
select * from control where nomi#'MENECHUK PATRIC' and (alltrim(proto)+alltrim(nomi) ;
not in(select alltrim(proto)+alltrim(nomp) from control) ;
or (!empty(alltrim(nomi2)) and alltrim(proto)+alltrim(nomi2) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi3)) and alltrim(proto)+alltrim(nomi3) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi4)) and alltrim(proto)+alltrim(nomi4) ;
not in(select alltrim(proto)+alltrim(nomp) from control)) ;
or (!empty(alltrim(nomi5)) and alltrim(proto)+alltrim(nomi5) ;
not in(select alltrim(proto)+alltrim(nomp) from control))) ;
group by proto into cursor ver
BROWSE LAST
