****
** Actualizo sala, demanda, duracion y generaagen en medpresta
****

parameters mncodmed, mddiasem, mthorad, mthorah, mfecprestad, mfecprestah, ;
	mcsala, mndem, mtdura,mdate, midusua, mhominis

mgenera = iif(mndem = 0, 1, 0)
if vartype(mhominis)="N"
	mhominis = 0
endif
if mxambito >1
	mccpoamb = " codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret = sqlexec(mcon1," Update Medpresta set Sala = ?mcsala, demanda = ?mndem, " + ;
	" generaagen = ?mgenera, duracion = ?mtdura, reservados = ?mhominis, " + ;
	" fhgraba = ?mdate, usuario = ?midusua " + ;
	" where &mccpoamb codmed     = ?mncodmed and " + ;
	"diasem    = ?mddiasem and " + ;
	"fecvigend = ?mfecprestad and " + ;
	"fecvigenh = ?mfecprestah and " + ;
	"horadesde = ?mthorad and " + ;
	"horahasta = ?mthorah")

if mret < 0
	messagebox('NO SE GUARDARON LOS ATRIBUTOS DE PRESTACIONES!!! ', 16, 'Validacion')
	mret = 0
else
	messagebox('ATRIBUTOS DE PRESTACIONES ACTUALIZADO!!! ', 48, 'Validacion')
endif
