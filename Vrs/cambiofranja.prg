update act_prereg set afiliado = nroregistracio
USE
SELECT 2
USE
SELECT 1
USE
DO gofish.app
MODIFY COMMAND "c:\desaguemes\vrs\avisospor entidad.prg"
USE c:\desaguemes\aviso713.dbf IN 0 EXCLUSIVE
BROWSE LAST
SELECT 6
SELECT 18
do clearall
select distinct codesp from medpresta
select distinct codesp,codserv from medpresta
select distinct codesp,codserv from medpresta where codserv#2200
select * from medpresta where codserv#2200 group by codmed,diasem,hhmmdes,fecvigenh,codesp,codserv into cursor practica
BROWSE LAST
RESUME
SELECT 2
BROWSE LAST
SELECT 2
SELECT 1
SELECT 4
SELECT 2
select * from franja,practica where franja.codmed = practica.codmed and franja.diasem = practica.diasem and ;
franja.hhmmdes = practica.hhmmdes and franja.fecvigenh = practica.fecvigenh
SELECT 5
BROWSE LAST
SELECT 2
BROWSE LAST
select * from franja.*,practica.codesp,practica.codserv where franja.codmed = practica.codmed and franja.diasem = practica.diasem and ;
franja.hhmmdes = practica.hhmmdes and franja.fecvigenh = practica.fecvigenh and franja.tiposerv = 1 into cursor todo
select franja.*,practica.codesp,practica.codserv  from franja,practica where franja.codmed = practica.codmed and franja.diasem = practica.diasem and ;
franja.hhmmdes = practica.hhmmdes and franja.fecvigenh = practica.fecvigenh and franja.tiposerv = 1 into cursor todo
select franja.*,practica.codesp,practica.codserv  from franja,practica where franja.codmed = practica.codmed and franja.diasem = practica.diasem and ;
franja.hhmmdes = practica.hhmmdes and franja.fecvigenh = practica.fecvigenh and franja.tiposervicio = 1 into cursor todo
select * from todo group by codmed,diasem,hhmmdes,fecvigenh,codesp,codserv into cursor control
BROWSE LAST
SELECT 25
SELECT 2
BROWSE LAST
select franja.*,practica.codesp,practica.codserv  from franja,practica where franja.codmed = practica.codmed and franja.diasem = practica.diasem and ;
franja.hhmmdes = practica.hhmmdes and franja.fecvigenh = practica.fecvigenh and franja.tiposervicio = 1 into cursor todo
select * from todo group by codmed,diasem,hhmmdes,fecvigenh,codesp,codserv into cursor control
BROWSE LAST
SELECT 24
BROWSE LAST
copy to control type xl5
copy to controlame type xl5