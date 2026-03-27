************************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* FECHA ULT. MODIFICACION:21/03/2002
************************************
************************************************************************
* Esta rutina ejecuta el cursor de médicos que tienen
* prestaciones ya asignadas y que no se encuentra bloqueado para generar
* la agenda
* parametro:mccodesp,mddiasem,mdmasx
************************************************************************
Parameters vr_codesp,vr_diasem,vr_dia
If mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

fechatop=Ctod('01/01/1900')
mret=SQLExec(mcon1,"SELECT a.* FROM medpresta as a ,prestadores as b "+;
	"WHERE &mccpoamb (fecpasivap = ?fechatop or fecpasivap > ?vr_dia) and  a.diasem = ?vr_diasem "+;
	"AND a.Codesp = ?vr_codesp AND a.fechaUltAgenda <= ?vr_dia and a.usuario<>'TURNOSMARK' "+;
	"AND a.fecVigend <= ?vr_dia and a.fecVigenh > ?vr_dia  "+;
	"AND	a.GeneraAgen = 1 AND a.Codmed =b.id "+;
	"AND(b.fecpasiva > ?vr_dia OR b.fecpasiva = ?fechatop) "+;
	"AND (b.bloquedesde > ?vr_dia OR b.bloquehasta < ?vr_dia) "+;
	"GROUP BY Codmed, diasem, horadesde, horahasta, fecvigend, fecvigenh "+;
	"ORDER BY Codmed, diasem, horadesde, horahasta, fecvigend, fecvigenh ","MWKmedpresta1pre")

* esta rutina es para un medico y un dia de la semana
* mret=sqlexec(mcon1," SELECT * FROM medpresta WHERE diasem=2 and codmed=17 ","MWKmedpresta1")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR diasem, REINTENTE",;
		16, "Validacion")
	mret=0
Else

	mret    = SQLExec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
		",cast (0 as integer) as esta  from tabubicacion "+;
		" where   centromedico   = ?mxcentromedico and habilitado >0 "+;
		" and codambito = ?mxambito order by piso, numero ",'Mwkqcon')

	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_consultorios1'
		Return
	Endif
	Select MWKmedpresta1pre.* From MWKmedpresta1pre,Mwkqcon;
		where  MWKmedpresta1pre.sala = lugar;
		INTO Cursor MWKmedpresta1
	Sele MWKmedpresta1
	Go Top

	If Eof('MWKmedpresta1') Or Bof('MWKmedpresta1') And mnturno = 2

		mcdia  = Iif(vr_diasem = 2,'Lunes  ',Iif(vr_diasem = 3,'Martes  ',;
			iif(vr_diasem = 4,'Miércoles  ',Iif(vr_diasem = 5,'Jueves  ',;
			iif(vr_diasem = 6,'Viernes  ',Iif(vr_diasem = 7,'Sabado  ','Domingo ')))))) +;
			dtoc(vr_dia)
		Wait Windows vr_codesp+ ' NO TIENE DEFINIDOS MEDICOS PARA EL ' + mcdia Nowait
	Else
* variables que necesito para el proceso genero turnos

		mthorad_ini = MWKmedpresta1.horadesde
		mthorah_ini = MWKmedpresta1.horahasta
		mtdura      = MWKmedpresta1.duracion
		mccodesp    = ""  && MWKmedpresta1.codesp
		mncodserv   = 0   && MWKmedpresta1.codserv
		mncodmed    = MWKmedpresta1.codmed
		mncanttur   = MWKmedpresta1.canturnos

	Endif
Endif


