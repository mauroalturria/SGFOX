PARAMETERS mid, mRegOrig , mAdmOrig , mRegDest , mAdmDest , mCodVaxAdd  
  
if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into TabRelReg 
		( TRR_RegOrig , TRR_AdmOrig , TRR_RegDest , TRR_AdmDest , TRR_CodVaxAdd ) 
		 Values 
		( ?mRegOrig , ?mAdmOrig , ?mRegDest , ?mAdmDest , ?mCodVaxAdd ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update TabRelReg 
		Set TRR_RegOrig  = ?mRegOrig , 
		TRR_AdmOrig  = ?mAdmOrig , 
		TRR_RegDest  = ?mRegDest , 
		TRR_AdmDest  = ?mAdmDest , 
		TRR_CodVaxAdd  = ?mCodVaxAdd  
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF

Select * From mwkregnew Where RCE_tipoCondesp = 1 Into Cursor mwkplanMI
		If Reccount('mwkplanMI')=0
			If Messagebox("ESTE PACIENTE ES MENOR DE UN AÑO Y NO TIENE CARGADA LA CONDICION DE PMI"+;
				CHR(13)+"DESEA QUE EL SISTEMA LA AGREGUE?",4+32+256,"Control de Plan Materno Infantil")=6
				Thisform.lnewcond = 1
				Select mwkcondPac
				Locate For estado = 1
				.txtFechah.Value = mfecnac+365
				.txtFechaD.Value = mfecnac
				.txtNroCert.Value = ''
				.cmdAddCap.Click()
			Endif
		Endif