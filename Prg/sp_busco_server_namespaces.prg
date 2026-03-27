****
** Busco IP del Server y el NameSpaces de Rutinas
****
ldisconnec = .F.
if !used("mwkserver1")
	DO sp_conexion
	ldisconnec = .t.
ENDIF

mret = sqlexec(mcon1, "select oleserver, olespaces from tabcfg  where id<1000  ", "mwktabcfg")  &&where id<1000 

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	do prg_cancelo
ELSE
	IF ldisconnec 
		DO sp_desconexion WITH "sp_busco_server_namespace"
	endif
endif
