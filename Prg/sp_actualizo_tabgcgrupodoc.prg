
PARAMETERS mIdDocumento,mIdGrupo,mfecha


IF USED('mwkControl')
    SELECT mwkControl
    use
ENDIF 
mret = sqlexec(mcon1,"select *  from tabgcGrupoDoc "+;
		    " where  idGrupo = ?mIdGrupo and IdDocumento = ?mIdDocumento ","mwkControl" )
IF RECCOUNT('mwkControl') = 0     
   mret =  sqlexec(mcon1,"INSERT INTO tabgcGrupoDoc(IdGrupo,IdDocumento,fecactiva) VALUES (?mIdGrupo,?mIdDocumento,?mfecha)")
ELSE
   mret =  sqlexec(mcon1,"update tabgcGrupoDoc set tabgcGrupoDoc.fecactiva = ?mfecha where IdDocumento = ?mIdDocumento and idGrupo = ?mIdGrupo")
ENDIF 

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF 