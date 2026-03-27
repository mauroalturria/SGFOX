RESUME
BROWSE LAST
select * from mwkguardia1 where !empty(priori) into cursor plangua
SELECT 47
BROWSE LAST
RESUME
select * from mwkguardia into cursor cosa
SELECT 48
BROWSE LAST
select * from cosa where !empty(nvl(eg_evolucion,'')) into cursor cosas
BROWSE LAST
SELECT 48
BROWSE LAST
RESUME
mfecha = mfecha -3600*48
RESUME
BROWSE LAST
select * from mwkguardia into cursor cosa

select * from cosa where atnur into cursor cosas
BROWSE LAST
SELECT 49
SELECT 48
use again in 0 dbf('cosas') as sopa
use again in 0 dbf('cosas')
MODIFY PROJECT c:\desaguemes\prj\presupuestos.pjx
use dbf('cosas') in 0 again alias sopa
SELECT 3
BROWSE LAST
select *,left(egm_evolnurse,250) as algo from cosas into cursor sopa
BROWSE LAST
select *,left(eg_evolnurse,150) as algo from cosas into cursor sopa
select left(EG_indicNurse,150) as indic_med ,*, left(eg_evolnurse,150) as algo from cosas into cursor sopas

SELECT 3
USE
SELECT 20
BROWSE LAST
