Lparameters tnOpcion, mcproto, mchc, mcapel, mcnompil, mctit, mcsex, mcfecnac, ;
	mcmedsol, mcmefec, mtp, mcLugar, mcdprest, mcidvale, ;
	mcProc, mcStep, mcHosp, mcCR, mccprest, mTipoPac, mProcLoc, mcfhvale

mret = 1
If Vartype(mTipoPac)#"C"
	mTipoPac = ""
Endif
If Vartype(mProcLoc)#"C"
	mProcLoc = ""
Endif
If !Used('mwkselcm')
	Do sp_busco_tabCM
	Use In Select('mwkselcm')
	Select * From mwkambitocm Group By abreviatura Order By orden Into Cursor mwkselcm Readwrite
Endif
If Vartype(mcfhvale)#"C"
	mcfhvale = " getdate() "
Endif

Do Case
Case tnOpcion = 1

	If Vartype(mxcentromedico)="N"
		Select mwkselcm
		Locate For centromedico = mxcentromedico
		mcHosp = Alltrim(abreviatura)
	Endif
	mret = SQLExec(mcon1,"insert into dbo.MWL( " + ;
		"AccessionNumber, PatientId, Surname, Forename, Title, Sex, DateOfBirth, " + ;
		"ReferringPhysician, PerformingPhysician, Modality, ExamDateAndTime, " + ;
		"ExamRoom, ExamDescription, StudyUId, ProcedureId, ProcedureStepId, " + ;
		"HospitalName, ScheduledAET, ExamCode, Comments, ProcedureLocation) " + ;
		" VALUES " + ;
		"(?mcproto, ?mchc, ?mcapel, ?mcnompil, ?mctit, ?mcsex, ?mcfecnac, " + ;
		"?mcmedsol, ?mcmefec, ?mtp, " + mcfhvale + ", " + ;
		"?mcLugar, ?mcdprest, ?mcidvale, ?mcProc, ?mcStep, " + ;
		"?mcHosp, ?mcCR, ?mccprest, ?mTipoPac, ?mProcLoc )")

Case tnOpcion = 2

	If Vartype(mxcentromedico)="N"
		Select mwkselcm
		Locate For centromedico = mxcentromedico
		mcHosp = Alltrim(abreviatura)
	Endif

	mret = SQLExec(mcon1,"Update dbo.MWL Set " + ;
		"AccessionNumber = ?mcproto, PatientId = ?mchc, Surname = ?mcapel, " + ;
		"Forename = ?mcnompil, Title = ?mctit, Sex = ?mcsex, DateOfBirth = ?mcfecnac, " + ;
		"ReferringPhysician = ?mcmedsol, PerformingPhysician = ?mcmefec, " + ;
		"Modality = ?mtp, ExamDateAndTime = " + mcfhvale + ", " + ;
		"ExamRoom = ?mcLugar, ExamDescription = ?mcdprest, ProcedureId = ?mcProc, " + ;
		"ProcedureStepId = ?mcStep, " + ;
		"HospitalName = ?mcHosp, ScheduledAET = ?mcCR, ExamCode = ?mccprest, Comments = ?mTipoPac, " + ;
		"ProcedureLocation = ?mProcLoc Where StudyUId = ?mcidvale ")


Case tnOpcion = 3

	Do sp_Busco_Mwl With "Where  StudyUId = '" + mcidvale + "'", "mwkmwlAux"
	If Used("mwkmwlAux")
		Select mwkmwlAux
		Scan All

			Do sp_update_mwl_d With 1, mwkmwlAux.AccessionNumber, mwkmwlAux.PatientId, mwkmwlAux.Surname, ;
				mwkmwlAux.Forename, mwkmwlAux.Title, mwkmwlAux.Sex, mwkmwlAux.DateOfBirth, ;
				mwkmwlAux.ReferringPhysician, mwkmwlAux.PerformingPhysician, mwkmwlAux.Modality, ;
				mwkmwlAux.ExamRoom, mwkmwlAux.ExamDescription, mwkmwlAux.StudyUId, ;
				mwkmwlAux.ProcedureId, mwkmwlAux.ProcedureStepId, mwkmwlAux.HospitalName, ;
				mwkmwlAux.ScheduledAET, mwkmwlAux.ExamCode, mwkmwlAux.ExamDateAndTime, mwkmwlAux.Comments, mwkmwlAux.ProcedureLocation

			Select mwkmwlAux
		Endscan

		Use In Select("mwkmwlAux")

		mret = SQLExec(mcon1,"Delete from dbo.MWL Where StudyUId = ?mcidvale ")
	Endif

Endcase

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
