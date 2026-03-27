****
** reprogramo mismo medico
** reprogramo a distinto medico
****
parameter mhorades1, mhorahas1, mhorades2, mhorahas2,mfechatur1,mhhmmd1,mhhmmh1,mhhmmd2,mhhmmh2, ;
	mnafil, mobservac,lotrom,lsinmk

musua = left(midusu,3) + '_REPR'
mhoy  = sp_busco_fecha_serv('DT')
if vartype(lotrom) # "L"
	lotrom = .f.
endif
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
ENDIF
If Vartype(lsinMK)="N"
	mccpoamb  = mccpoamb + " usuariogenera<>'TURNOSMARKEY' AND "
Endif
If vartype(mobservac)#"C"
	mobservac = ''
endif 
select mwkveoturnos
go top
mfechatur	= mwkveoturnos.fechatur
mncodmed	= mwkveoturnos.codmed
mdiasem		= dow(mwkveoturnos.fechatur)
mhorades	= mwkveoturnos.horatur
mcm = iif(mnmedicodes#codmed,"("+str(mnmedicodes,4,0)+")","")
mobservai 	= iif(lotrom,'REPOM','REPR.') + substr(ttoc(mfechatur1),1,5)+substr(ttoc(mfechatur1),11,6)+;
	+"->"+ substr(ttoc(mfechatur),1,5)+substr(ttoc(mfechatur),11,6)+mcm

do sp_busco_horarios_tomados with mfechatur1, mnmedicodes,mhhmmd1,mhhmmh1
select mwkRephorarios
go top

do while !eof('mwkRephorarios')

	mhoratur	= mhorades2 + (mwkRephorarios.horatur - mhorades1)

	do while mhoratur < mhorahas2
		If Empty(mobservac)	
			mobserva = left(iif(mwkRephorarios.afiliado>1,alltrim(mobservai) + " | " ,"") + ;
					   alltrim(nvl(mwkRephorarios.observa,"")) ,100)
		else
			mobserva = left(iif(mwkRephorarios.afiliado>1,alltrim(mobservai) + " | " ,"") + ;
					   alltrim(nvl(mwkRephorarios.observa,"")) + " | " + alltrim(mobservac) ,100)
		endif 	
		mususec		= mwkRephorarios.UsuarioSector

		mret = sqlexec(mcon1,'select id, afiliado from turnos where &mccpoamb codmed = ?mncodmed and ' + ;
			'fechatur = ?mfechatur and horatur = ?mhoratur ' +;
			'and (turnos.tipoturno < 8 or turnos.tipoturno >=13) ORDER BY afiliado ', 'mwkveolib')

		if mret < 0
			messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS', 18,'Validacion')
			cancel
		endif

		if !eof('mwkveolib')
			if mwkveolib.afiliado = mnafil
				mid = mwkveolib.id
				mret = sqlexec(mcon1, 'update turnos set tipoturno = 9,usuarioobserva = ?musua where id = ?mid')
				if mret < 0
					messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS', 18,'Validacion')
					cancel
				endif

				mid = mwkRephorarios.id

				mhhmmTur	= val(left(ttoc(mhoratur,2),2)+substr(ttoc(mhoratur,2),4,2))

				mret = sqlexec(mcon1, 'update turnos set codmed = ?mncodmed, ' + ;
					'usuarioobserva = ?musua, diasem = ?mdiasem, ' + ;
					'fechatur = ?mfechatur, horatur = ?mhoratur, UsuarioSector = ?mususec, ' + ;
					'observa = ?mobserva, fechaobserva = ?mhoy, hhmmTur = ?mhhmmTur  ' + ;
					'where id = ?mid')
				if mret < 0
					messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS', 18,'Validacion')
					cancel
				endif
			else
				mid = mwkRephorarios.id
				mhoratur = mhoratur + 60	&& le sumo 1 minuto
				mhhmmTur	= val(left(ttoc(mhoratur,2),2)+substr(ttoc(mhoratur,2),4,2))
				mret = sqlexec(mcon1, 'update turnos set codmed = ?mncodmed, usuarioobserva = ?musua,'+;
				' diasem = ?mdiasem, fechatur = ?mfechatur, horatur = ?mhoratur, observa = ?mobserva,'+;
				' fechaobserva = ?mhoy, hhmmTur = ?mhhmmTur , UsuarioSector = ?mususec ' + ;
				'where id = ?mid')
				if mret < 0
					messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS', 18,'Validacion')
					cancel
				endif
			endif
			select mwkRephorarios
			skip 1 in mwkRephorarios
			if !eof('mwkRephorarios')
				mhoratur	= mhorades2 + (mwkRephorarios.horatur - mhorades1)
			else
				exit
			endif
		else
			mhoratur= mhoratur + 60
		endif
	enddo
	select mwkRephorarios
	if !eof('mwkRephorarios')
		skip 1 in mwkRephorarios
	endif
enddo
