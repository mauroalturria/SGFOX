***********************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* ULTIMA MODIFICACION:14/07/2003
***********************************
********************************************************************************
* Ejecuta el cursor de prestaciones filtrado por especialidad, recibe en una
* variable el codigo de médico que busca y en otra el codigo de la especialidad
********************************************************************************
Lparameters mcpasivo

If Vartype(mcpasivo) # "C"
	mcpasivo = " and PRE_fechapasiva is null"
Else
	mcpasivo = " "
Endif
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and a.codambito = ?mxambito "
Endif

mret=SQLExec(mcon1," SELECT a.codprest, b.PRE_descriprest, "+ ;
	" b.PRE_especialidad,b.pre_tipomuestra,b.PRE_Lateralidad, a.codserv, b.PRE_turnosMultip, diasem, " +;
	" a.fecvigend, a.fecvigenh, a.sala, a.duracion, a.demanda, "+;
	" a.horadesde, a.horahasta,a.id,hhmmdes,hhmmhas,a.codprest,"+;
	" a.hhasta1,a.hdesde1,a.fechaUltAgenda,a.canturnos,a.generaAgen,a.reservados " + ;
	" FROM medpresta as a, prestacions as b " + ;
	" WHERE a.codmed = ?mncodmed and diasem = ?mddiasem " + ;
	" and a.codprest = b.PRE_codprest " + mcpasivo +mccpoamb +;
	" ORDER BY b.PRE_descriprest, a.horadesde, a.horahasta, "+;
	" a.fecvigend, a.fecvigenh","Mwkprestasig")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0
Else
	Select * From Mwkprestasig ;
		where fecvigend >= ?mfecturnod And fecvigenh <= ?mfecturnoh;
		and fecvigend < fecvigenh;
		and Between (Ttoc(horadesde,2),mthorad,mthorah);
		and Between (Ttoc(horahasta,2),mthorad,mthorah);
		order By fecvigenh, fecvigend;
		into Cursor MwkprestasigVig

Endif
