*
* Busqueda de examenes de residencias
*
Lparameter mtipo

If empty(mtipo)
	If used('mwkresidencia')
		Use in mwkresidencia
	Endif
	mcursor = "'mwkresidencia'"
Else
	If used('mwkresidenci2')
		Use in mwkresidenci2
	Endif
	mcursor = "'mwkresidenci2'"
Endif

mquery = "TBE_Apellido,TBE_Nombre,TBE_dni,TBE_especialidad,TBE_tema,TBE_puntaje,TBE_orden,TBE_correctas,"+;
	"TBE_incorrectas,TBE_norespondidas,TBE_noencontradas,"

For mi = 1 to 100
	mquery = mquery + "TBE_p"+alltrim(str(mi))+","
Endfor

mquery = mquery + "TBE_imagen,TBE_tipo,TBE_restar "

*!*	mret = sqlexec(mcon1,"select TBE_Apellido,TBE_Nombre,TBE_dni,TBE_especialidad,TBE_tema,TBE_puntaje,TBE_orden,* "+;
*!*		"from TabResProfexa order by TBE_apellido,TBE_tema",&mcursor)

mret = sqlexec(mcon1,"select "+mquery+;
	"from TabResProfexa where TBE_anio=?mranio and TBE_evento=?mreven order by TBE_apellido,TBE_tema",&mcursor)

If mret < 0
	Messagebox("EN BUSQUEDA DE EXAMENES DE RESIDENCIA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
