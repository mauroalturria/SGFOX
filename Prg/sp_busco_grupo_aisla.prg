use in select("mwkGrupoAisla")
mret = sqlexec(mcon1, "select  Zabgrupoaisla.ID, GA_DiasPrimerPedido,GA_DiasSigtePedido, GA_Duracion, GA_Enfermedades, GA_HabCohorte,"+;
	" GA_HabIndiv, GA_Nombre, GA_TipoAislamiento,descrip  from Zabgrupoaisla "+;
	" inner join tabestados ON (GA_TipoAislamiento = estado and propietario = 25 and tipo = 56) "+;
	"order by Zabgrupoaisla.ID", "mwkGrupoAisla")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	cancel
ENDIF
use in select("mwkGrupoGermen")
mret = sqlexec(mcon1, "select  ID,GG_Germen,GG_IdGrupo from ZabGrupoGermen", "mwkGrupoGermen")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	cancel
ENDIF
