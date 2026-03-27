*
* Acentar datos de quien confirma un tratamiento citostático.
*
Lparameters mregis,mfecha,mnombr,mobser

mret = sqlexec(mcon1,"insert into TabFarmApto "+;
	"(TFA_registracio,TFA_fecha,TFA_conombre,TFA_obser) values (?mregis,?mfecha,?mnombr,?mobser)")

If mret < 0
	Messagebox("EN INGRESO DE CONFIRMACION DE APTITUD DEL TRATAMIENTO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
