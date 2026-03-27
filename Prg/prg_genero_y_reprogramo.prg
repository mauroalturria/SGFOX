****
** genera agenda y reprograma
****
Parameter vr_codmed, vr_fechatur, mhorades1, mhorahas1, mhorades2, mhorahas2,mhhmmd1,mhhmmh1,mhhmmd2,mhhmmh2,mnafil, mobservac

If Type('mnmedicodes')# "N"
	mnmedicodes= vr_codmed
Endif

If Vartype(mobservac) # "C"
	mobservac = ''
Endif

mhoy  		= sp_busco_fecha_serv('DT')


mccpoamb = ''
mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif
Select mwkgenera
Go Top
Locate For horatur => mhorades1
musua 		= Left(midusu,3) + '_REPR'
mhorades	= mwkgenera.horatur

mcm = Iif(mnmedicodes # vr_codmed,"("+Str(mnmedicodes,4,0)+")","")
mobservai 	= 'REPR.' +Substr(Ttoc(mhorades1),1,5)+Substr(Ttoc(mhorades1),11,6)+;
	+"->"+ Substr(Ttoc(vr_fechatur),1,5)+Substr(Ttoc(vr_fechatur),11,6)+mcm

mdiasem		= Dow(vr_fechatur)
mdia		= mhoy

****  Genero Agenda
Do While !Eof('mwkgenera')
	mhoratur	= mhorades2 + (mwkgenera.horatur - mhorades1)
	mtipotur	= mwkgenera.tipoturno
	mhhmmTur	= Val(Left(Ttoc(mhoratur,2),2)+Substr(Ttoc(mhoratur,2),4,2))
	mususec		= mwkgenera.UsuarioSector
	mobserva = Left(Iif(mwkgenera.afiliado>1,Alltrim(mobservai) + " | " ,"")+ ;
		alltrim(Nvl(mwkgenera.observa,"")),100)

	If Between(mhoratur, mhorades2, mhorahas2) And mhoratur < mhorahas2
* valido que no exista el turno
		mncodmed   = vr_codmed
		mndiasem   = mdiasem
		mtfechatur = vr_fechatur
		mthorad    = mhoratur

		Do sp_valido_turnos

		If Eof('MWKExisteTurno')
			If Vartype(mnucodprest )<>"N"
				mnucodprest = 0
			Endif
			mret = SQLExec(mcon1,"insert into turnos (afiliado, codmed, codserv, codent, codesp, "+;
				"confirmado, diasem, fechatur, hhmmtur, horatur, nrovale, tipotomado, " + ;
				"tipoturno, usuariogenera, fechagenera, observa, UsuarioSector,codprest  &mcicpoamb,ambcentro ) " + ;
				"values (?mnafil, ?vr_codmed, 0, 0, ' ', 0, ?mdiasem, ?vr_fechatur, ?mhhmmTur, " + ;
				"?mhoratur, 0, 0, ?mtipotur, ?musua, ?mdia, ?mobservac,?mususec,?mnucodprest &mvicpoamb,?mxcentromedico )")

			If mret < 0
				Messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS', 18,'Validacion')
				Do prg_cancelo
			Endif
		Endif
	Endif

	Skip 1 In mwkgenera

Enddo

****  Aca Reprogramo
Select mwkgenera
Go Top
Locate For horatur => mhorades1

mfechatur	= mwkgenera.fechatur
mncodmed	= mwkgenera.codmed
mdiasem		= Dow(mwkgenera.fechatur)

Do sp_busco_horarios_tomados With mfechatur, mncodmed,mhhmmd1,mhhmmh1
Select mwkRephorarios
Go Top


Do While !Eof('mwkRephorarios')

	If Empty(mobservac)
		mobserva = Left(Iif(mwkRephorarios.afiliado>1,Alltrim(mobservai) + " | " ,"")+ ;
			alltrim(Nvl(mwkRephorarios.observa,"")),100)
	Else
		mobserva = Left(Iif(mwkRephorarios.afiliado>1,Alltrim(mobservai) + " | " ,"")+ ;
			alltrim(Nvl(mwkRephorarios.observa,"")) + " | " + Alltrim(mobservac),100)
	Endif

	mhoratur	= mhorades2 + (mwkRephorarios.horatur - mhorades1)
	mdiasem		= Dow(vr_fechatur)
	mususec		= Nvl(mwkRephorarios.UsuarioSector,0)
	If mhoratur < mhorahas2
		mret = SQLExec(mcon1,'select id, afiliado from turnos where &mccpoamb codmed = ?vr_codmed and ' + ;
			'afiliado = ?mnafil and fechatur = ?vr_fechatur and ' + ;
			'horatur = ?mhoratur and (turnos.tipoturno < 8 or turnos.tipoturno >=13) ', 'mwkveolib')
		Sele mwkveolib
		Go Top
		Do While !Eof('mwkveolib')
			mid = mwkveolib.Id
			mret = SQLExec(mcon1, 'update turnos set tipoturno = 9, usuarioobserva = ?musua ' + ;
				'where id = ?mid')
			Skip 1 In mwkveolib
		Enddo

		mid = mwkRephorarios.Id
		mhhmmTur	= Val(Left(Ttoc(mhoratur,2),2)+Substr(Ttoc(mhoratur,2),4,2))
		mret = SQLExec(mcon1, 'update turnos set codmed = ?vr_codmed, usuarioobserva = ?musua,'+;
			' diasem = ?mdiasem, fechatur = ?vr_fechatur, hhmmTur = ?mhhmmTur,'+;
			' horatur = ?mhoratur, observa = ?mobserva ,fechaobserva = ?mhoy,UsuarioSector = ?mususec ' + ;
			'where id = ?mid')

		If mret < 0
			=Aerr(eros)
			Messagebox(eros(3), 18,'Validacion')
			Do prg_cancelo
			Cancel
		Endif

		Select mwkRephorarios
		Skip 1 In mwkRephorarios

	Else
		Messagebox('HAY TURNOS QUE NO REPROGRAMARON', 32,'Validacion')
		Select mwkRephorarios
		Skip 100 In mwkRephorarios

	Endif
Enddo
mm = 1
