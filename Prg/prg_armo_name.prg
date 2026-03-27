**** armos nombre de campo
lparameters miobjeto,mdes
with miobjeto
	if upper(.baseclass)="FORM"
		return (mdes)
	else
		mdes= .name +'.'+ mdes
		=prg_armo_name(.parent,@mdes)
	endif
endwith
