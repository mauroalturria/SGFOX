parameters midbono, musuarioAs, vr_serie

if type(musuarioAs)#"C"
	mbusq = ' AND usuario ="' + allt(musuarioAs) +'"'
else
	mbusq = ' '
endif
if type(vr_serie)#"C"
	mbusq1 = ' AND Bonoserie ="' + allt(vr_serie) +'"'
else
	mbusq1 = ' '
endif

mret= sqlexec(mcon1," Select * From TabBonoAsig "+;
					" Where idBono =?midbono " + mbusq + mbusq1 +;
					" Order by fechahora desc,idbono asc, "+;
					" bonohasta desc, usuario asc ","MwkUltAsig")

if mret < 0
	messagebox('ERROR DE CURSOR, REINTENTE',64,'VALIDACION')
	mret = 0
	do prg_cancelo
endif					