*!*	------------------------------------
*!*	?GetMWL("ELEVA_HR","mwkMamo")
*!*	?GetMWL("ELEVA_RX1","mwkRx1")
*!*	?GetMWL("ELEVA_RX2","mwkRx2")
*!*	?GetMWL("","mwkTodo")
*!*	------------------------------------
*!*	?GetModelidad_Equipo("mwkModalEquipo")
*!*	------------------------------------
*!*	------------------------------------
*!*	------------------------------------
*!*	---------------------------------------------------------------------
*!*	---------------------------------------------------------------------
*!*	---------------------------------------------------------------------
Function GetMWL_H
Lparameters tcFILTRO, tcCursor

If Empty(tcFILTRO)
	mRet = Sqlexec(mcon1,"Select * from dbo.MWL_H",tcCursor)
Else
	If Not "WHERE" $ tcFILTRO
		tcFILTRO = " Where " + tcFILTRO
	Endif 
	
	mRet = Sqlexec(mcon1,"Select * from dbo.MWL_H " + tcFILTRO,tcCursor)
	
Endif 	

Return (mRet > 0)

*!*	---------------------------------------------------------------------
Function GetMWL
Lparameters tcAET_EQUIPO, tcCursor

If Empty(tcAET_EQUIPO)
	mRet = Sqlexec(mcon1,"Select * from dbo.MWL",tcCursor)
Else
	mRet = Sqlexec(mcon1,"EXEC [GetMWL] ?tcAET_EQUIPO",tcCursor)
Endif 	

Return (mRet > 0)
*!*	---------------------------------------------------------------------
Function GetModelidad_Equipo
Lparameters tcCursor

mRet = Sqlexec(mcon1,"Select * from dbo.AET_MODALIDAD",tcCursor)

Return (mRet > 0)
*!*	---------------------------------------------------------------------
Function GetHIS_FIELD
Lparameters tcCursor

mRet = Sqlexec(mcon1,"Select * from dbo.HIS_FIELD",tcCursor)

Return (mRet > 0)

