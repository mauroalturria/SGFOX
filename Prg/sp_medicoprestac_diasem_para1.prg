*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
************************************************************************
* Esta rutina ejecuta el cursor de médicos que tienen
* prestaciones ya asignadas y que no se encuentra bloqueado para generar
* la agenda
************************************************************************
parameters vr_codmed,xmcodesp
*do sp_conexion
*!*	mdmasX   =ctod('19/11/2004')
*!*	mddiasem =dow(mdmasX)
*!*	vr_codmed =153

fechatop =ctod('01/01/1900')
if mxambito >1
	mccpoamb = "  medpresta.codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
if empty(xmcodesp)
	mbusesp = ''
else
	mbusesp = " and codesp = '"+xmcodesp+"' "
ENDIF

mret = sqlexec(mcon1," SELECT * FROM medpresta WHERE &mccpoamb diasem = ?mddiasem AND " + ;
	" GeneraAgen = 1 and usuario<>'TURNOSMARK'  AND ?mdmasX BETWEEN fecvigend and Fecvigenh " + mbusesp + ;
	" AND fecvigend < Fecvigenh "+;
	" AND Codmed IN (SELECT id FROM Prestadores WHERE id = ?vr_codmed " + ;
	" AND (fecpasivap = ?fechatop or fecpasivap > ?mdmasx ) and (fecpasiva > ?mdmasX OR fecpasiva = ?fechatop) " + ;
	" AND (bloquedesde > ?mdmasX or bloquehasta < ?mdmasX)) " + ;
	" GROUP BY Codmed, diasem, horadesde, codesp " + ;
	" ORDER BY Codmed, diasem, horadesde, codesp ","MWKmedpresta1u")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret = 0
ELSE
mret    = SQLExec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
		",cast (0 as integer) as esta  from tabubicacion "+;
		" where   centromedico   = ?mxcentromedico and habilitado >0 "+;
		" and codambito = ?mxambito order by piso, numero ",'Mwkqcon')

	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_consultorios1'
		Return
	Endif
	Select MWKmedpresta1u.* From MWKmedpresta1u,Mwkqcon;
		where  MWKmedpresta1u.sala = lugar;
		INTO Cursor MWKmedpresta1
	sele MWKmedpresta1
	go top
	if reccount('MWKmedpresta1') =0
		noExiste=.t.
		vr_proceso = 'EL MEDICO ' + allt(Mwkmedico.nombre) +' NO PRESTA SERVICIOS EL DIA:'+ dtoc(mdmasX)
*Messagebox(vr_proceso,16,'VALIDACION')
	else
* variables que necesito para el proceso genero turnos para un médico
		noExiste=.f.
* variables que necesito para el proceso genero turnos
		mthorad_ini   = MWKmedpresta1.horadesde
		mthorah_ini   = MWKmedpresta1.horahasta
		mtdura        = MWKmedpresta1.duracion
		mccodesp      = ""  && MWKmedpresta1.codesp
		mncodserv     = 0   && MWKmedpresta1.codserv
		mncodmed      = MWKmedpresta1.codmed
	endif
endif
