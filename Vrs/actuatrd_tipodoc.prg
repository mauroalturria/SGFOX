select cosa
scan
	mid = cosa.id
	mreg = cosa.trd_registracio
	mtd = cosa.trd_tipodoc
	requery('regdoc')
	update regdoc set trd_registracio =mreg,trd_tipodoc=mtd
	select cosa
endscan


MODIFY PROJECT c:\desaguemescar\prj\calendario.pjx
select * from tabregdocu where trd_tipodoc#reg_tipodocumento into cursor mal
select * from tabregdocu where trd_tipodoc<>reg_tipodocumento into cursor mal
select * from tabregdocu where trd_tipodoc<>val(reg_tipodocumento) into cursor mal
select * from tabregdocu where reg_nrohclinica in (select reg_nrohclinica from mal) into cursor control
browse
select * from tabregdocu where reg_nrohclinica in (select reg_nrohclinica from mal) group by reg_nrohclinica into cursor control
select * from tabregdocu where reg_nrohclinica in (select reg_nrohclinica from mal) into cursor control
browse
select * from tabregdocu where reg_nrohclinica in (select reg_nrohclinica from mal) order by reg_nrohclinica into cursor control
BROWSE LAST
select * from tabregdocu where trd_fecpasiva = ctod("01/01/1900") and reg_nrohclinica in (select reg_nrohclinica from mal) order by reg_nrohclinica into cursor control
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and reg_nrohclinica in (select reg_nrohclinica from mal) order by reg_nrohclinica into cursor control
BROWSE LAST
use again dbf('control') in 0  alias cosa
use dbf('control') again in 0  alias cosa
SELECT 2
BROWSE LAST
select id,count(id) as cuantos from cosa group reg_nrohclinica into cursor dobles
select id,count(id) as cuantos from cosa group by reg_nrohclinica into cursor dobles
browsw
browse
select * from regdocu where id in (select id from dobles where cuantos = 1)
select * from tabregdocu where id in (select id from dobles where cuantos = 1)
select id,trd_registracio,count(id) as cuantos from cosa group by reg_nrohclinica into cursor dobles
select * from tabregdocu where trd_registracio in (select trd_registracio from dobles where cuantos = 1)
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos = 1)
update tabregdocu set trd_registracio = val(reg_tipodocumento) where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos = 1)
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos > 1)
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos > 1) order by reg_nrohclinica
SELECT 2
USE
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos > 1) order by reg_nrohclinica into cursor ddbb
use dbf('ddbb') again in 0  alias cosa
SELECT 2
BROWSE LAST
USE
update tabregdocu set trd_registracio = 1 where trd_fechapasiva = ctod("01/01/1900") and trd_tipodoc = 0
select * from tabregdocu where trd_tipodoc<>val(reg_tipodocumento) into cursor mal
select * from tabregdocu where reg_nrohclinica in (select reg_nrohclinica from mal) into cursor control
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and reg_nrohclinica in (select reg_nrohclinica from mal) order by reg_nrohclinica into cursor control
select id,trd_registracio,count(id) as cuantos from control group by reg_nrohclinica into cursor dobles
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos > 1) order by reg_nrohclinica into cursor ddbb
SELECT 6
BROWSE LAST
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos > 1) order by reg_nrohclinica into cursor ddbb
SELECT 6
BROWSE LAST
select * from tabregdocu where trd_tipodoc<>val(reg_tipodocumento) into cursor mal
select * from tabregdocu where reg_nrohclinica in (select reg_nrohclinica from mal) into cursor control
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and reg_nrohclinica in (select reg_nrohclinica from mal) order by reg_nrohclinica into cursor control
select id,trd_registracio,count(id) as cuantos from control group by reg_nrohclinica into cursor dobles
select * from tabregdocu where trd_fechapasiva = ctod("01/01/1900") and trd_registracio in (select trd_registracio from dobles where cuantos > 1) order by reg_nrohclinica into cursor ddbb
BROWSE LAST
use dbf('ddbb') again in 0  alias cosa
BROWSE LAST
SELECT 2
BROWSE LAST
update cosa set trd_tipodoc = val(reg_tipodocumento)
MODIFY COMMAND
RESUME
