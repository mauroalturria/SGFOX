Parameters mid, mRegOrig , mAdmOrig , mRegDest , mAdmDest , mCodVaxAdd  ,mtdFHRN
If Vartype(mtdFHRN)<>"T"
	mtdFHRN= sp_busco_fecha_serv("DT")
Endif
If mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into TabRelReg
		( TRR_RegOrig , TRR_AdmOrig , TRR_RegDest , TRR_AdmDest , TRR_CodVaxAdd,TRR_FechorNac  )
		 Values
		( ?mRegOrig , ?mAdmOrig , ?mRegDest , ?mAdmDest , ?mCodVaxAdd,?mtdFHRN )
	ENDTEXT

Else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update TabRelReg
		Set TRR_RegOrig  = ?mRegOrig ,
		TRR_AdmOrig  = ?mAdmOrig ,
		TRR_RegDest  = ?mRegDest ,
		TRR_AdmDest  = ?mAdmDest ,
		TRR_CodVaxAdd  = ?mCodVaxAdd,
		TRR_FechorNac  = ?mtdFHRN
		where ID = ?mid
	ENDTEXT

Endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .F.
Endif
