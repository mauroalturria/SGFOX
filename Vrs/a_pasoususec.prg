public mcon1,myip
do sp_conexion
fechades = ctod("01/01/1900")
fechatdes = ctod("01/01/2005")

archi = " turnoshis "

*ret=SQLExec(mcon1,"SELECT * FROM Tabbonorec WHERE fecha >= ?fechades","tabbonorec")
mret = sqlexec(mcon1,'select idusuario,tabsectorusuario.codsector,tabsectorusuario.fecpasiva '    +;
	'from tabusuario ' +;
	'left join tabsectorusuario on (tabusuario.id = tabsectorusuario.codusuario and preferido = 1)' +;
	'left join tabsectores on tabsectorusuario.codsector = tabsectores.id ' +;
	' where tabsectorusuario.fecpasiva =  ?fechades '+;
	' order by idusuario, tabsectorusuario.fecpasiva ' , 'mwkusuarios')
	
mret = sqlexec(mcon1,'select afiliado,usuario,turnos.id,usuariosector   '    +;
	'from &archi  as turnos '+;
	' where afiliado > 1 and fechatur > ?fechatdes ' , 'mwktomados')

select id upper(usuario) as usuario,usuariosector from mwktomados where isnull(usuariosector) into cursor mwktomadosa

select  * from mwktomadosa,mwkusuarios where usuario = idusuario into cursor mwkturnos


SET STEP ON
archi = " turnoshis "
select mwkturnos
scan
	msector  = codsector
	mid = id	
	wait windows transform(recno()) nowait
	mret=SQLExec(mcon1,"update &archi set usuariosector  = ?msector  "+;
		" where id = ?mid ")
	if mret<0 
		=aerr(eros)
		set step on
	endif			
endscan
do sp_desconexion