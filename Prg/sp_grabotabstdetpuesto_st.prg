PARAMETERS midComp, mIdPuesto,mAbm

IF mAbm = 1
     mret =	sqlexec(mcon1," SELECT * from tabStDetPuesto where idComp = ?midComp and idpuesto = ?mIdPuesto ", "mwkValidPresu")
    IF RECCOUNT('mwkValidPresu') > 0
       RETURN 
    ENDIF 
     mret =	sqlexec(mcon1," INSERT into tabStDetPuesto (idComp,idpuesto) VALUES (?midComp, ?mIdPuesto )")
ENDIF 
IF mAbm = 3
  mret =	sqlexec(mcon1," delete from tabStDetPuesto where idComp = ?midComp and idpuesto = ?mIdPuesto ")
ENDIF 
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif