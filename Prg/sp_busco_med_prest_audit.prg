****
**  Busca los horarios de Auditoria Hominis  cambiar la prestacion
****

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret=sqlexec(mcon1,"SELECT hhmmdes,hhmmhas,horadesde, horahasta, sala " + ;
	" from medpresta " + ;
	" where &mccpoamb fecvigend<=?mfecturno2  and fecvigenh >?mfecturno2 " + ;
	" and  fecvigend <> fecvigenh and codprest = 42010380 " + ;
	" group by hhmmdes,hhmmhas " + ;
	" order by horadesde" ,"mwkfranjahora")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	do prg_cancelo
endif