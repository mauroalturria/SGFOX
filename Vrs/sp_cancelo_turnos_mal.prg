***
***   Cancelo todos los turnos del archivo que me envian
***
miarchi = 0
DO sp_conexion
If Vartype(miarchivo)="N"
	miarchi = miarchivo
Endif
mnarch = miarchi
mcicpoamb = ''
mvicpoamb = ''
 
 	SET STEP ON 
mret = SQLExec(mcon1, "select turnos.* from turnos     " + ;
	"where   fechatur >= {fn curdate()} and confirmado = 0   " + ;
	" and afiliado>2 and usuario = 'TURNOSWEB' and tipoturno not in (0,5,7,14,15,16,17,18,19,20) order by HORATUR ", "mwktodos")
 
	miarchivo = 'mafrl.txt'
	mnarch = FCREATE(miarchivo)

msql    = "select * from mwktodos "
mindes  = 0
minhas  = 0
mfeccan	= sp_busco_fecha_serv('DT')
  
mihora = datetime()+60*60
msql = msql + "where horatur>mihora order by fechatur, horatur into cursor mwkturnocancel"
&msql
mdiahoy = sp_busco_fecha_serv("DD")
SELECT * FROM Select mwkturnocancel into cursor mwkphorarioscm
Select mwkturnocancel

Scan
	mid = mwkturnocancel.Id
	mifecha = mwkturnocancel.fechatur
	mret = SQLExec(mcon1, "select * from turnos " + ;
		"where id = ?mid", "mwktodos")
	Select mwktodos
	Scatter To Regi
	mafili 		= Round(mwktodos.afiliado, 0)
	If !Used('mwknoanula')
		Select * From mwktodos Where 1 = 2 Into Cursor noanula
		Use Dbf('noanula') Alias mwknoanula Again In 0
	Endif
	mccad = Transf(mid)
	mccad = mccad + Chr(9) + Transf(mwktodos.codreserva)
	mccad = mccad + Chr(9) + Transf(mwktodos.codprest)
	mccad = mccad + Chr(9) + Transf(mwktodos.horatur)
	If mwktodos.afiliado>1
		If  mwktodos.fechatur = mifecha
			midtur      = mwktodos.Id
			mcodres 	= mwktodos.codreserva
			mfectur 	= mwktodos.fechatur
			mafili 		= Round(mwktodos.afiliado, 0)
			mcodent		= mwktodos.codent
			mcodesp		= mwktodos.codesp
			mcodmed		= mwktodos.codmed
			msolici		= mwktodos.codmedsoli
			mcodpres	= mwktodos.codprest
			mreserva	= mwktodos.codreserva
			mcodserv	= mwktodos.codserv
			mdiasem		= mwktodos.diasem
			mtomado		= mwktodos.fechatomado
			mfectur		= mwktodos.fechatur
			mhortur		= mwktodos.horatur
			mdonde		= mwktodos.solicigia
			mttomado	= mwktodos.tipotomado
			mturno		= mwktodos.tipoturno
			musuari		= Alltrim(mwktodos.usuario)
			musuari1	= Alltrim(midusu)
			mfgenera	= mwktodos.fechagenera
			musugen		= mwktodos.usuariogenera
			mfeccan		= sp_busco_fecha_serv('DT')
			musuari		= Alltrim(mwktodos.usuario)
			musuari1	= Alltrim(midusu)
			musuari2    = Left(Alltrim(midusu), 3) + "_IVR"
			mobserva 	= "IVR"+ " | " + Alltrim(Nvl(mwktodos.observa,""))
			mUsuSec		= Nvl(mwktodos.UsuarioSector,0)
			mafiliado  	= mwktodos.afiliado
			musucan		= mwkusuario.codigovax
			mret = SQLExec(mcon1, "insert into turnosaudit (codigo,afiliado, turnoid, fechatomado, usuario &mcicpoamb) "+;
				"values ( 9, ?mafiliado, ?mid, ?mfeccan, ?musucan &mvicpoamb) ")
			musuari2    = Left(Alltrim(midusu), 3) + "_MAN"
			mobserva 	= "IVR"+ " | " + Alltrim(Nvl(mwktodos.observa,""))
			midcancel 	= 49
			mhhmmTur	= Val(Left(Ttoc(mhortur,2),2)+Substr(Ttoc(mhortur,2),4,2))
			mret = SQLExec(mcon1, "insert into turnoscancel(afiliado, codcancela, codent, codesp, " + ;
				"codmed, codmedsoli, codprest, codreserva, diasem, feccancela, fechatomado, " + ;
				"fechatur, hhmmtur, horatur, solicigia, tipotomado, tipoturno, usuario, usucancela, "+;
				"observa, codserv,UsuarioSector,idturnos &mcicpoamb ) " + ;
				"values(?mafili, ?midcancel, ?mcodent, ?mcodesp, " + ;
				"?mcodmed, ?msolici, ?mcodpres, ?mreserva, ?mdiasem, ?mfeccan, ?mtomado, " + ;
				"?mfectur, ?mhhmmTur, ?mhortur, ?mdonde, ?mttomado, ?mturno, ?musuari, ?musuari1,"+;
				" ?mobserva, ?mcodserv, ?mususec, ?midtur &mvicpoamb)")

			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS CANCELADOS, AVISAR A SISTEMAS",16, "Validacion")
				Do prg_cancelo
			Endif

			mret = SQLExec(mcon1,"update turnos set afiliado = 0, usuario = '', codprest = 0, " + ;
				"codmedsoli = 0, solicigia = 0, codreserva = '', codent = 0, " + ;
				"codserv = 0, codesp = '' , tipoturno = 9, tipotomado = 0, " + ;
				"usuarioobserva = ?musuari2, fechatomado = ?mfeccan, UsuarioSector = 0 " + ;
				"where id = ?mid ")

			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
				Do prg_cancelo
			Endif
			If Vartype(mnucodprest )<>"N"
				mnucodprest = 0
			Endif
			mret = SQLExec(mcon1, "insert into turnos(afiliado, codesp, codmed, codprest, codserv,"+;
				" codent,confirmado, codreserva, diasem, fechatur, hhmmTur, horatur, nrovale, "+;
				" tipotomado, tipoturno, solicigia, usuario, observa, fechagenera,usuariogenera,UsuarioSector,codprest &mcicpoamb) " + ;
				"values(0, '', ?mcodmed, 0, 0, 0, 0,'', ?mdiasem, ?mfectur, ?mhhmmTur, ?mhortur, 0, 0, " + ;
				"?mturno, 0, ?musuari1, ' ',?mfgenera,?musugen,0,?mnucodprest  &mvicpoamb)")
			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
				Do sp_desconexion With "error"
				Cancel
			Endif
			mccad = mccad + Chr(9) + "Anulado"
			If mnarch > 0
				Fputs(mnarch, mccad)
			Endif
		Else
			Select mwknoanula
			Regi(3) ="ANULAR"
			Append From Array Regi
			mccad = mccad + Chr(9) + "NO Anula"
			If mnarch > 0
				Fputs(mnarch, mccad)
			Endif

		Endif
	Else
		mccad = mccad + Chr(9) + "YA ANULADO"
		If mnarch > 0
			Fputs(mnarch, mccad)
		Endif

	Endif

Endscan
minutos = minhas - mindes
 
Do  prg_osana_cancelacion_masiva_2
DO sp_desconexion