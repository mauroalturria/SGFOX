*************************
*Autor:Claudia Antoniow
*************************
*Fecha:20/08/2002
*************************
*Ult. Modificación:20/08/2002
*****************************
parameter IDRecord,NTipo

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mret=sqlexec(mcon1,"UPDATE turnos SET tipoturno=?Ntipo "+;
	" where &mccpoamb codmed=?mncodmed and fechatur=?mtfechatur and id=?IDRecord ")

if mret <0
	messagebox('No se pudo reservar turno, AVISAR A SISTEMAS',16,'VALIDACION')
	mret=0
endif
