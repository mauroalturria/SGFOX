****
** Busca Las prestaciones asignadas al médico
****
Lparameters lsinMK
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
If Vartype(lsinMK)="N"
	mccpoamb  = mccpoamb + " medpresta.usuario<>'TURNOSMARK' AND "
Endif
mret = SQLExec(mcon1,"SELECT medpresta.codprest, prestacions.pre_descriprest, " + ;
	"prestacions.pre_especialidad, medpresta.codserv,pre_tipomuestra,PRE_Lateralidad,medpresta.usuario " + ;
	"FROM medpresta, prestacions " + ;
	"WHERE &mccpoamb medpresta.codprest = prestacions.pre_codprest and " + ;
	' medpresta.fecvigend <> medpresta.fecvigenh  And fecvigenh >={fn curdate()} and ' + ;
	"medpresta.diasem > 0 and medpresta.codmed = ?mncodmed " + ;
	" and PRE_fechapasiva is null  " +;
	"GROUP BY medpresta.codprest " + ;
	"ORDER BY prestacions.pre_descriprest ","Mwkprestasig1")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Messagebox(eros(3))
	Do prg_cancelo
Endif
