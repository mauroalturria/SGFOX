Parameters tcAdmOrig, tcCurName

Local lcsql 

TEXT To lcsql Textmerge Noshow Pretext 7
	Select * From TabRelReg 
	Where TRR_AdmOrig  = ?tcAdmOrig
ENDTEXT

If !Prg_EjecutoSql(lcSql,tcCurName)
	Return .f.
ENDIF
