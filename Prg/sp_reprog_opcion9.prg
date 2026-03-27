****
** reprogramo mismo medico
** reprogramo a distinto medico
****
Parameter mprestant,mprestnue , mobservac,lotrom

musua = Left(midusu,3) + '_REPR'
mhoy  = sp_busco_fecha_serv('DT')
If Vartype(lotrom) # "L"
	lotrom = .F.
Endif
mprest = mprestant
mprestn = mprestnue
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
If Vartype(mobservac)#"C"
	mobservac = ''
Endif
Select mwkveoturnos
Go Top
mfechatur	= mwkveoturnos.fechatur
mncodmed	= mwkveoturnos.codmed
mdiasem		= Dow(mwkveoturnos.fechatur)
mhhmmtur = mwkveoturnos.hhmmtur
mcm = Iif(mnmedicodes#codmed,"("+Str(mnmedicodes,4,0)+")","")
mobservai 	= 'REPPD' + mcm
Scan
	If Empty(mobservac)
		mobserva = Left(Iif(mwkveoturnos.afiliado>1,Alltrim(mobservai) + " | " ,"") + ;
			alltrim(Nvl(mwkveoturnos.observa,"")) ,100)
	Else
		mobserva = Left(Iif(mwkveoturnos.afiliado>1,Alltrim(mobservai) + " | " ,"") + ;
			alltrim(Nvl(mwkveoturnos.observa,"")) + " | " + Alltrim(mobservac) ,100)
	Endif

	mid = mwkveoturnos.Id
	mafi = mwkveoturnos.afiliado
	mret = SQLExec(mcon1,'select id, afiliado from turnos where afiliado = ?mafi and ' + ;
		'codprest = ?mprest and id = ?mid ', 'mwkveolib')
	If Reccount('mwkveolib')>0
		mret = SQLExec(mcon1, 'update turnos set codprest = ?mprestn ,usuarioobserva = ?musua where id = ?mid')
		If mret < 0
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
	Endif
	Select mwkveoturnos
Endscan
***controlo que tenga la nueva prestacion
mret = SQLExec(mcon1,"SELECT * FROM medpresta  " + ;
	"WHERE &mccpoamb medpresta.codprest = ?mprestn  and " + ;
	' fecvigend <> fecvigenh and ' + ;
	' fecvigend <= ?mfechatur and fecvigenh >= ?mfechatur and ' + ;
	"medpresta.diasem =?mdiasem  and medpresta.codmed = ?mncodmed " + ;
	" and hhmmdes<=?mhhmmtur and hhmmhas >=?mhhmmtur ","Mwkprestanue")
If mret < 0
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
If Reccount("Mwkprestanue")=0
	mret = SQLExec(mcon1,"SELECT * FROM medpresta  " + ;
	"WHERE &mccpoamb medpresta.codprest = ?mprest  and " + ;
	' fecvigend <> fecvigenh and ' + ;
	' fecvigend <= ?mfechatur and fecvigenh >= ?mfechatur and ' + ;
	"medpresta.diasem =?mdiasem  and medpresta.codmed = ?mncodmed " + ;
	" and hhmmdes<=?mhhmmtur and hhmmhas >=?mhhmmtur ","Mwkprestant")

	mid =Mwkprestant.Id
	mfech = sp_busco_fecha_serv("DT")
	mfecdes = mfechatur -1
	mfechas = mfechatur +1
	mret = SQLExec(mcon1,"INSERT INTO Medpresta(codprest,fhgraba,GeneraAgen, Internado, Porcentaje,"+;
		" cantidad, canturnos,  codesp, codmed,  codserv, demanda, diasem, duracion, fecVigenH, fecVigend,"+;
		"  fechaUltAgenda,  guardia, hdesde1, hhasta1, hhmmDes, hhmmHas, horadesde, horahasta,"+;
		" reservados, sala, usuario)"+;
		" select ?mprestn  ,?mfech ,GeneraAgen, Internado, Porcentaje, cantidad, canturnos,"+;
		" codesp, codmed,  codserv, demanda, diasem, duracion, ?mfechas , ?mfecdes ,"+;
		" fechaUltAgenda,  guardia, hdesde1, hhasta1, hhmmDes, hhmmHas, horadesde, horahasta,"+;
		" reservados, sala, usuario from Medpresta where id = ?mid" )
Endif
