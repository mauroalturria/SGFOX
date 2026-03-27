Select zabmedcabpp
Scan
	mireg = Int(nroDocuPac)
	Requery('registel')
	If Reccount('registel')=1
		mimail = Upper(registel.REG_email)
		mireg= registel.REG_nroregistrac
		Select zabmedcabpp
		If Upper(ZMC_emailpac)<>mimail
			Replace apellido With registel.REG_nombrepac ,nombre With mimail ,nroregistrac With mireg
		Endif
	Else
		Replace apellido With "VARIOS"
	Endif
Endscan
