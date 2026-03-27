*!*	
*!*	Entidades Activas 
*!*	===========================================

mRet = SqlExec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno,ENT_capita from entidades " + ;
	"where ENT_fecpas is null and (ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
	"order by ENT_descrient", "mwkentidad2")
	
If mRet < 0 
	MessageBox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
*	cancel
EndIf