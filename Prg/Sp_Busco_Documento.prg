Lparameters pNroRegistrac
*!*	========================================================
lnNumero = 0

mRet = Sqlexec(mCon1,"Select REG_numdocumento " + ;
	"from Registracio Where REG_NroRegistrac = ?pNroRegistrac ", "cDOC" )  

*!*	REG_tipodocumento

If  mRet < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Canc
Endif 

lnNumero = cDOC->Reg_NumDocumento

Select cDOC
Use 

Return lnNumero