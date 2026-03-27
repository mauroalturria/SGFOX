USE c:\desaguemes\prj\ambulatorio.pjx IN 0 SHARED
BROWSE LAST
select * from ambulatorio where inlist(type,'x','i') into cursor iconos
USE c:\desaguemes\prj\pisos.pjx IN 0 SHARED
SELECT 2
select * from pisos where inlist(type,'x','i') into cursor iconospisos
select * from iconos where key not in (select key from iconospisos))
select * from iconos where key not in (select key from iconospisos) into cursor pasoico
SELECT 2
append from dbf('pasoico')