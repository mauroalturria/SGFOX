
PARAMETERS mIdUsuario,mIdGrupo,mfecha


*********************************************************************************
* BUSCA usuarios
*********************************************************************************

mret = sqlexec(mcon1,"select *  from tabgcUsuGrup "+;
		    " where IdUsuario = ?mIdUsuario and idGrupo = ?mIdGrupo ","mwkControl" )
IF RECCOUNT('mwkControl') = 0     
   mret =  sqlexec(mcon1,"INSERT INTO tabgcUsuGrup (idUsuario,IdGrupo,fecactiva) VALUES (?mIdUsuario,?mIdGrupo,?mfecha)")
ELSE
   mret =  sqlexec(mcon1,"update tabgcUsuGrup set tabgcUsuGrup.fecactiva = ?mfecha where IdUsuario = ?mIdUsuario and idGrupo = ?mIdGrupo")
ENDIF 

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF 