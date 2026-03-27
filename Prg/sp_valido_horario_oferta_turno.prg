****
* corre en frmturno41 y frmturno44 agrego sobre oferta - turno con horario y agenda
* valida en medpresta la franja horaria
****
*
parameter mcodmed, mdiasem, mfecha, mhora, mhorah


if type('mthrdes')= "N"
	msolohora = mhora
	msolohorah = mhorah
else
	msolohora = val(left(strtran(mhora,":",""),4))
	msolohorah = val(left(strtran(mhorah,":",""),4))
endif

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret=sqlexec(mcon1,"select * from medpresta   " +;
	" where &mccpoamb codmed = ?mcodmed  " +;
	" and diasem = ?mdiasem    " +;
	" and ?msolohora  >= hhmmdes " +;
	" and ?msolohorah <= hhmmhas " +;
	" and ?mfecha between fecvigend " +;
	" and fecvigenh ","mwkveohora")

*"?mfecha >= fecvigend and ?mfecha < fecvigenh and " +;
*"?mdiahora >= hdesde1 and ?mdiahorah =< hhasta1 ","mwkveohora")


if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR 1, AVISAR A SISTEMAS", 16,"Validacion")
	cancel
endif

mfhd = ctot(dtoc(mfecha) + ' ' + ttoc(mwkveohora.hdesde1, 2))
mfhh = ctot(dtoc(mfecha) + ' ' + ttoc(mwkveohora.hhasta1, 2))

mret=sqlexec(mcon1,"select codmed from turnos " + ;
	"where &mccpoamb codmed = ?mcodmed and  fechatur = ?mfecha and " + ;
	"(turnos.tipoturno < 8 or turnos.tipoturno >=13) and horatur between ?mfhd and ?mfhh ", "mwkveoturno")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR 2, AVISAR A SISTEMAS", 16,"Validacion")
	cancel
endif

