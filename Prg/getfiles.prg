***************************************************************************************************
*  Procedure  : GetFiles  := Carga en cursor los nombres de los files de interfaz de un tipo dado
*
*  Parametros :
*
*       TipoFile (I) := Tipo de file de interfaz  (VAP,... etc)
*       NombreCursor (O) := Nombre del cursor de salida con los filenames
*
***************************************************************************************************

parameter TipoFile, NombreCursor

private pattern, VecDir, CantFiles, i

create cursor (m.NombreCursor) (FileInterf C(50))

m.pattern = alltrim(m.zzDirInterf) + '*.' + alltrim(m.TipoFile)
*messagebox(alltrim(m.zzDirInterf) )
m.CantFiles = adir(VecDir, m.pattern)
if m.CantFiles = 0 and upper(alltrim(m.TipoFile))="VAP"
	messagebox("ERROR DE CONEXION. SALGA COMPLETAMENTE DEL MONITOR "+chr(13)+;
		"SALGA TAMBIEN DEL LANZADOR Y VUELVA A INGRESAR")
endif
lubico = (upper(alltrim(m.TipoFile))#"VAP")
for i = 1 to m.CantFiles
	if alltrim(upper(VecDir[ m.i , 1 ])) = "NOBORRAR.VAP"
		lubico = .t.			
	else
		insert into (m.NombreCursor) values ( VecDir[ m.i , 1 ] )
	endif
endfor
if !lubico 
	messagebox("ERROR DE CONEXION. SALGA COMPLETAMENTE DEL MONITOR "+chr(13)+;
		"SALGA TAMBIEN DEL LANZADOR Y VUELVA A INGRESAR")
endif

select FileInterf from (m.NombreCursor) order by FileInterf asc into cursor (m.NombreCursor)
if lower(m.NombreCursor) = "datos"
	If reccount(m.NombreCursor)=0
		Wait windows ("No hay vales en la cola de impresion...") nowait
	Endif
Endif

return lubico

******************************************

