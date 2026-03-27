*
* Ambulatorio Registro de Egreso
*
Lparameters mfcheg, mcodmed, mSala

mfecha = ttod(mfcheg)
mhora  = val(strtran(left(ttoc(mfcheg,2),5),":",""))

mret = sqlexec(mcon1,"update TabAmbIEMed set TAI_hhmmegr = ?mhora"+;
	" where TAI_fecha=?mfcheg and TAI_codmed=?mcodmed and TAI_consultorio=?mSala and TAI_hhmmegr=9999")

If mret < 0
	=aerror(merror)
	Messagebox("EN ACTUALIZACION DEL EGRESO EL PROFESIONAL"+chr(10)+;
		alltrim(merror(3))+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
