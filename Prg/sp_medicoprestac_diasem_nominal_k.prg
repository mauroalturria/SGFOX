************************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* FECHA ULT. MODIFICACION:03/04/2002
************************************
************************************************************************
* Esta rutina ejecuta el cursor de médicos que tienen
* prestaciones ya asignadas y que no se encuentra bloqueado para generar
* la agenda
************************************************************************
*mdmasX   =ctod('24/12/2003')
*mddiasem =dow(mdmasX)
fechatop =ctod('01/01/1900')
if mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret=sqlexec(mcon1," SELECT a.*,b.nombre "+;
	" FROM medpresta as a, prestadores  as b WHERE &mccpoamb (fecpasivap = ?fechatop or fecpasivap > ?mdmasx ) and "+;
	" a.diasem=?mddiasem AND a.Codesp=?vr_espe AND " + ;
	" a.fecVigend <=?mdmasX and a.fecVigenh >?mdmasX and a.usuario<>'TURNOSMARK' AND " + ;
	" a.fechaUltAgenda <= ?mdmasX AND a.GeneraAgen = 1 AND a.Codmed =b.id " + ;
	" And (b.fecpasiva >?mdmasX OR b.fecpasiva=?fechatop ) " +;
	" AND (b.bloquedesde <= b.bloquehasta) AND (b.bloquedesde > ?mdmasX  OR b.bloqueHasta < ?mdmasX ) " +;
	" GROUP BY a.Codmed,a.horadesde,a.codesp " +;
	" ORDER BY nombre,horadesde ","MWKmedprestaNom")


* esta rutina es para un medico y un dia de la semana
* mret=sqlexec(mcon1," SELECT * FROM medpresta WHERE diasem=2 and codmed=17 ","MWKmedpresta1")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR diasem, REINTENTE",16, "Validacion")
	mret=0

else
	sele MWKmedprestaNom
	go top
	if !eof('MWKmedprestaNom')
		sele MWKmedprestaNom
*!*			keyboard '{ESC}' plain clear
*!*			browse
		report form repturno21 to printer noconsole
	endif
endif


