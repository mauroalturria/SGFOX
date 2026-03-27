Lparameters tnId, tnIdCodMed, tnNroDedo, tcHuella, tnMask
*--------------------------------------------------------------------------
Do Case
	Case tnId = 0
		mRet = Sqlexec(mcon1,"Insert into Tabprestahuellas (Ph_CodMed, Ph_NroDedo, Ph_Huella, Ph_Mask) Values " + ;
			" (?tnIdCodMed, ?tnNroDedo, ?tcHuella, ?tnMask) ") 
	Case tnId > 0
		mRet = Sqlexec(mcon1,"Update Tabprestahuellas Set " + ;
			" Ph_CodMed = ?tnIdCodMed, Ph_NroDedo = ?tnNroDedo, Ph_Huella = ?tcHuella, Ph_Mask = ?tnMask " + ;
			" Where Id = ?tnId ") 
Endcase 

If mRet <= 0
	Set Step on 
	Messagebox("ERROR AL GUARDAR PRESTADORES - HUELLA",16,"ERROR")
	Return .f.
Endif 
