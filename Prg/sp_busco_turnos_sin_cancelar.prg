***********************************
** AUTOR: Claudia Antoniow Torrico
***********************************
** FECHA :17/09/2003
***********************************
parameters v_mcodmed, v_mfecha,v_fecvigprest2,v_thorad1,v_thorah1,v_ddiasem
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret=sqlexec(mcon1,"select afiliado,codreserva,horatur,codprest from turnos " +;
	"where &mccpoamb codmed = ?v_mcodmed " +;
	"and  fechatur >= ?v_mfecha " +;
	"and  fechatur < ?v_fecvigprest2 " +;
	"and  diasem = ?v_ddiasem " +;
	"and  hhmmtur >= ?v_thorad1 " +;
	"and  hhmmtur < ?v_thorah1 " +;
	"and (tipoturno < 8 or tipoturno = 11 or tipoturno >= 13 )", "mwksincancel")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR veoturnos, REINTENTE", 16,"Validacion")
	do prg_cancelo
endif

