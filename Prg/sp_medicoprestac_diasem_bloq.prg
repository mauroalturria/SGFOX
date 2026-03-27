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

fechatop=ctod('01/01/1900')
*mddiasem=5
*mdmasX =ctod('09/05/2002')

If !Used("MWKValCtrlTur")
	mret=sqlexec(mcon1," SELECT * FROM medpresta WHERE diasem=?mddiasem AND Codesp<>'KINE' AND " +;
		" fechaUltAgenda < ?mdmasX AND fecVigend <=?mdmasX and fecVigenh >?mdmasX AND " + ;
		" GeneraAgen = 1 AND Codmed IN " + ;
		" ( SELECT id FROM Prestadores WHERE (fecpasivap = ?fechatop or fecpasivap > ?mdmasX )"+;
		" and (fecpasiva >?mdmasX OR fecpasiva=?fechatop) " +;
		" AND (bloquedesde > ?mdmasX or bloquehasta < ?mdmasX)) " +;
		" GROUP BY Codmed, diasem, horadesde, codesp " +;
		" ORDER BY Codmed, diasem, horadesde, codesp ",'MWKmedpresta1')
else
	mret=sqlexec(mcon1," SELECT * FROM medpresta WHERE diasem=?mddiasem AND Codesp<>'KINE' AND " +;
		" fecVigend <=?mdmasX and fecVigenh >?mdmasX AND " + ;
		" GeneraAgen = 1 AND Codmed IN " + ;
		" ( SELECT id FROM Prestadores WHERE (fecpasivap = ?fechatop or fecpasivap > ?mdmasX )"+;
		" and (fecpasiva >?mdmasX OR fecpasiva=?fechatop) " +;
		" AND (bloquedesde > ?mdmasX or bloquehasta < ?mdmasX)) " +;
		" GROUP BY Codmed, diasem, horadesde, codesp " +;
		" ORDER BY Codmed, diasem, horadesde, codesp ",'MWKmedpresta1')

	&& Cambio la consulta por la ultima generacion -> fechaUltAgenda < ?mdmasX AND 

Endif 

* esta rutina es para un medico y un dia de la semana
* mret=sqlexec(mcon1," SELECT * FROM medpresta WHERE diasem=2 and codmed=17 ","MWKmedpresta1")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR diasem, REINTENTE",16, "Validacion")
	mret=0

else
	if eof('MWKmedpresta1') or bof('MWKmedpresta1') and mnturno = 2
		messagebox('NO EXISTEN DEFINIDOS MEDICOS PARA ALGUNO DE LOS DIAS',16,'VALIDACION')
	else
* variables que necesito para el proceso genero turnos
		mthorad_ini   = MWKmedpresta1.horadesde
		mthorah_ini   = MWKmedpresta1.horahasta
		mtdura    = MWKmedpresta1.duracion
		mccodesp  = ""  && MWKmedpresta1.codesp
		mncodserv = 0   && MWKmedpresta1.codserv
		mncodmed  = MWKmedpresta1.codmed
		mncanttur =  MWKmedpresta1.canturnos

	endif
endif


