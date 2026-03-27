Parameters tnRegBB, tcAdmBB, tcCurName

*!*	=sp_busco_mm(3739873, ""        ,"mwkMMBB01")
*!*	=sp_busco_mm(0      , "481215-7","mwkMMBB02")


DO CASE
	CASE !Empty(tnRegBB)
		lcSql = "Select Registracio.* From TabRelReg inner join Registracio on  TRR_RegOrig = Reg_NroRegistrac Where TRR_RegDest = ?tnRegBB "
	CASE !Empty(tcAdmBB)
		lcSql = "Select Registracio.* From TabRelReg inner join Registracio on  TRR_RegOrig = Reg_NroRegistrac Where TRR_AdmDest = ?tcAdmBB"
	Otherwise
		Return .f.

ENDCASE

If !prg_ejecutosql(lcSql, tcCurName)
	Return .f.
Endif 