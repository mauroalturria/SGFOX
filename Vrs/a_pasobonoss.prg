public mcon1
do sp_conexion
fechades = ctod("01/01/1900")

*ret=SQLExec(mcon1,"SELECT * FROM Tabbonorec WHERE fecha >= ?fechades","tabbonorec")
mret = sqlexec(mcon1,'select idusuario,tabsectorusuario.codsector,tabsectorusuario.fecpasiva '    +;
	'from tabusuario ' +;
	'left join tabsectorusuario on (tabusuario.id = tabsectorusuario.codusuario and preferido = 1)' +;
	'left join tabsectores on tabsectorusuario.codsector = tabsectores.id ' +;
	' where tabsectorusuario.fecpasiva =  ?fechades '+;
	' order by idusuario, tabsectorusuario.fecpasiva ' , 'mwkusuarios')
	
mret = sqlexec(mcon1,'select afiliado,usuario,turnos.id '    +;
	'from turnoshis as turnos '+;
	'where afiliado > 1 ' , 'mwktomadosa')

select  * from mwktomadosa,mwkusuarios where usuario = idusuario into cursor mwkturnos


SET STEP ON
select mwkturnos
scan
	if id>1546560
		msector  = codsector
		mid = id	
		wait windows transform(id) nowait
		mret=SQLExec(mcon1,"update turnoshis set usuariosector  = ?msector  "+;
			" where id = ?mid ")
		if mret<0 
			=aerr(eros)
			set step on
		endif			
	endif			
endscan
set step on
mret=SQLExec(mcon1,"SELECT BonoDesde, BonoHasta,BonoSerie, TipoBono"+;
			" FROM Tabdetallefac where fechagraba >'2006-01-01 00:00:00' ","Tabdetallefac")
SELECT Tabdetallefact
scan
	mdesde = BonoDesde
	mhasta = BonoHasta
	mserie = BonoSerie
	mipobono = tipobono
							
	mret=SQLExec(mcon1,"delete from Tabbonoest "+;
			" where TipoBono= ?mipobono and NroBono>=?mdesde and NroBono<=?mhasta ")
		if mret<0 
			=aerr(eros)
			set step on
		endif			
	sELECT Tabdetallefact
endscan	