Lparameters tnOpcion, mcproto, mchc, mcapel, mcnompil, mctit, mcsex, mcfecnac, ;
	mcmedsol, mcmefec, mtp, mcLugar, mcdprest, mcidvale, ;
	mcProc, mcStep, mcHosp, mcCR, mccprest, mcfhvale, mTipoPac, mProcLoc  


If Vartype(mTipoPac)#"C"
	mTipoPac = ""
Endif 	
If Vartype(mProcLoc)#"C"
	mProcLoc = ""
Endif 

*mcfhvale = " getdate() "
 
Do Case
	Case tnOpcion = 1

		mret = SQLExec(mcon1,"insert into dbo.MWL_D( " + ;
			"AccessionNumber, PatientId, Surname, Forename, Title, Sex, DateOfBirth, " + ;
			"ReferringPhysician, PerformingPhysician, Modality, ExamDateAndTime, " + ; 
			"ExamRoom, ExamDescription, StudyUId, ProcedureId, ProcedureStepId, " + ;
			"HospitalName, ScheduledAET, ExamCode, Comments, ProcedureLocation ) " + ;
			" VALUES " + ;
			"(?mcproto, ?mchc, ?mcapel, ?mcnompil, ?mctit, ?mcsex, ?mcfecnac, " + ;
			"?mcmedsol, ?mcmefec, ?mtp, ?mcfhvale, " + ;
			"?mcLugar, ?mcdprest, ?mcidvale, ?mcProc, ?mcStep, " + ;
			"?mcHosp, ?mcCR, ?mccprest, ?mTipoPac, ?mProcLoc )")

	Case tnOpcion = 2

		mret = SQLExec(mcon1,"Update dbo.MWL_D Set " + ;
			"AccessionNumber = ?mcproto, PatientId = ?mchc, Surname = ?mcapel, " + ;
			"Forename = ?mcnompil, Title = ?mctit, Sex = ?mcsex, DateOfBirth = ?mcfecnac, " + ;
			"ReferringPhysician = ?mcmedsol, PerformingPhysician = ?mcmefec, " + ;
			"Modality = ?mtp, ExamDateAndTime = ?mcfhvale, " + ; 
			"ExamRoom = ?mcLugar, ExamDescription = ?mcdprest, ProcedureId = ?mcProc, " + ;
			"ProcedureStepId = ?mcStep, " + ;
			"HospitalName = ?mcHosp, ScheduledAET = ?mcCR, ExamCode = ?mccprest, Comments = ?mTipoPac,  " + ;
			"ProcedureLocation = ?mProcLoc Where StudyUId = ?mcidvale ")


Endcase

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .f.
Endif
