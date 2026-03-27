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

fechatop=Ctod('01/01/1900')
*mddiasem=5
*mdmasX =ctod('09/05/2002')
If mxambito >1
	mccpoamb = "  medpresta.codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif


If !Used("MWKValCtrlTur")
	mret=SQLExec(mcon1," SELECT * FROM medpresta WHERE &mccpoamb diasem=?mddiasem AND Codesp<>'KINE' AND " +;
		" fechaUltAgenda < ?mdmasX AND fecVigend <=?mdmasX and fecVigenh >?mdmasX AND " + ;
		" GeneraAgen = 1 and usuario<>'TURNOSMARK' AND Codmed IN " + ;
		" ( SELECT id FROM Prestadores WHERE (fecpasivap = ?fechatop or fecpasivap > ?mdmasX )"+;
		" and (fecpasiva >?mdmasX OR fecpasiva=?fechatop) " +;
		" AND (bloquedesde > ?mdmasX or bloquehasta < ?mdmasX)) " +;
		" GROUP BY Codmed, diasem, horadesde, codesp " +;
		" ORDER BY Codmed, diasem, horadesde, codesp ",'MWKmedpresta1pre')
Else
	mret=SQLExec(mcon1," SELECT * FROM medpresta WHERE &mccpoamb diasem=?mddiasem AND " +;
		" fecVigend <=?mdmasX and fecVigenh >?mdmasX AND " + ;
		" GeneraAgen = 1 and usuario<>'TURNOSMARK' AND Codmed IN " + ;
		" ( SELECT id FROM Prestadores WHERE (fecpasivap = ?fechatop or fecpasivap > ?mdmasX )"+;
		" and (fecpasiva >?mdmasX OR fecpasiva=?fechatop)) " +;
		" GROUP BY Codmed, diasem, horadesde, codesp " +;
		" ORDER BY Codmed, diasem, horadesde, codesp ",'MWKmedpresta1pre')
&&AND (bloquedesde > ?mdmasX or bloquehasta < ?mdmasX)
&& Cambio la consulta por la ultima generacion -> fechaUltAgenda < ?mdmasX AND

Endif

* esta rutina es para un medico y un dia de la semana
* mret=sqlexec(mcon1," SELECT * FROM medpresta WHERE diasem=2 and codmed=17 ","MWKmedpresta1")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR diasem, REINTENTE",16, "Validacion")
	mret=0

Else
	mret    = SQLExec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
		",cast (0 as integer) as esta  from tabubicacion "+;
		" where   centromedico   = ?mxcentromedico  "+;
		" and codambito = ?mxambito order by piso, numero ",'Mwkqcon')

	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_consultorios1'
		Return
	Endif
	Select MWKmedpresta1pre.* From MWKmedpresta1pre,Mwkqcon;
		where  MWKmedpresta1pre.sala = lugar;
		INTO Cursor MWKmedpresta1
		
	If Eof('MWKmedpresta1') Or Bof('MWKmedpresta1') And mnturno = 2
		Messagebox('NO EXISTEN DEFINIDOS MEDICOS PARA ALGUNO DE LOS DIAS',16,'VALIDACION')
	Else
* variables que necesito para el proceso genero turnos
		mthorad_ini   = MWKmedpresta1.horadesde
		mthorah_ini   = MWKmedpresta1.horahasta
		mtdura    = MWKmedpresta1.duracion
		mccodesp  = ""  && MWKmedpresta1.codesp
		mncodserv = 0   && MWKmedpresta1.codserv
		mncodmed  = MWKmedpresta1.codmed
		mncanttur =  MWKmedpresta1.canturnos

	Endif
Endif


