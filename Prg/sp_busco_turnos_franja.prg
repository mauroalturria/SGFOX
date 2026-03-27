*
* Busco Turnos generados en la franja
*

&& Lparameters mfecturnoh2,mddiasem,mmcodmed,mthorad2,mthorah2
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret = sqlexec(mcon1,"select * from turnos where &mccpoamb diasem = ?mddiasem and " + mfecturnoh2 +" and "+;
	"hhmmtur between ?mthorad2 and ?mthorah2 and codmed=?mmcodmed","mwkturasig")
	
If mret > 0
	If used('mwkturasig')
		If reccount('mwkturasig')>0
			lsigue = .F.
			Messagebox("EXISTEN TURNOS GENERADOS PARA ESTA FRANJA HORARIA"+chr(10)+;
				"NO PODRA ACTUALIZAR A DEMANDA ESPONTANEA",48,"Validación")
		Endif
	Endif
Else
	lsigue = .F.
	Messagebox("AL CONSULTAR TURNOS PARA LA FRANJA REQUERIDA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

