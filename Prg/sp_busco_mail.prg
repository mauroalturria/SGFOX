*****
*  Busco la entidad de una admision
******
Parameters mcodigo
mretorno = ''
If used('mwkpacCob')
	Use in mwkpacCob
Endif
	mret=sqlexec(mcon1,"select reg_email "+;
		"from registracio where registracio = ?mcodigo","mwkpacCob")
If mret < 0
	Messagebox("ERROR EN BUSQUEDA DEL NOMBRE DEL PACIENTE",48,"Validacion")
Else
	If reccount('mwkpacCob')>0
		Select mwkpacCob
		Go top
		mretorno = mwkpacCob.reg_email
	Endif
Endif
Return mretorno

