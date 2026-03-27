*!*	sp_grabo_sinonimos
*!*	morigen = 2 && Actualizacion
*!*	-----------------------------------------
lParameters morigen, mId, mSinonimos, mIncluye

If morigen = 2

	mret = Sqlexec(mcon1, "Update TabCiap2e Set Sinonimos = ?mSinonimos, Incluye = ?mIncluye Where Id = ?mId ")

	If mret < 0
		=Aerr(eros)
		Messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
	Endif
	
Endif 



