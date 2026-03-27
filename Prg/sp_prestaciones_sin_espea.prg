*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* ULTIMA MODIFICACION:14/07/2003
*******************************
******************************************************************************
*Ejecuta el cursor de prestaciones filtrado por especialidad, recibe en una
*variable el codigo de médico que busca y en otra el codigo de la especialidad
******************************************************************************

*do sp_conexion.prg
*mncodmed=145
*susp
if mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret=sqlexec(mcon1," SELECT a.codprest, b.PRE_descriprest, "+ ;
	" b.PRE_especialidad,b.pre_tipomuestra,b.PRE_Lateralidad, a.codserv, b.PRE_turnosMultip, diasem, " +;
	" a.fecvigend, a.fecvigenh, a.sala, a.duracion, a.demanda, "+;
	" a.horadesde, a.horahasta,a.id,hhmmdes,hhmmhas " + ;
	" FROM medpresta as a, prestacions as b " + ;
	" WHERE &mccpoamb a.codmed = ?mncodmed and diasem = ?mddiasem " + ;
	" and a.codprest = b.PRE_codprest and PRE_fechapasiva is null " +;
	" ORDER BY b.PRE_descriprest, a.horadesde, a.horahasta, "+;
	" a.fecvigend, a.fecvigenh","Mwkprestasig")
*" GROUP BY b.PRE_codprest,a.horadesde,a.horahasta,a.fecvigend, a.fecvigenh " + ;

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0
else

	if !used('MwkprestasigVig')
		select * from Mwkprestasig ;
			where fecvigend >= ?mfecturnod and fecvigenh <= ?mfecturnoh;
			and fecvigend < fecvigenh;
			and between (ttoc(horadesde,2),mthorad,mthorah);
			and between (ttoc(horahasta,2),mthorad,mthorah);
			order by fecvigend, fecvigenh;
			into cursor MwkprestasigVig

	endif
endif
