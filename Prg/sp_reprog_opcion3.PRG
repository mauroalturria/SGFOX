****
** reprogramo a sobreturnos del mismo o a otro medico
****
parameter mhorades1, mhorahas1, mhorades2, mhorahas2,mfechatur1 ,mhhmmd1,mhhmmh1,mhhmmd2,mhhmmh2,mnafil, mobservac

mhoy  = sp_busco_fecha_serv('DT')
musua = left(midusu,3) + '_REPR'

If vartype(mobservac)#"C"
	mobservac = ''
endif 

if vartype(mcm)#"C"
	mcm = ''
endif	

select mwkveoturnos
go top
mfechatur	= mwkveoturnos.fechatur
mncodmed	= mwkveoturnos.codmed
mdiasem		= dow(mwkveoturnos.fechatur)
mhorades	= mwkveoturnos.horatur
mobservai 	= 'REPR.' + substr(ttoc(mfechatur1),1,5)+substr(ttoc(mfechatur1),11,6)+;
	+"->"+ substr(ttoc(mfechatur),1,5)+substr(ttoc(mfechatur),11,6)+mcm

do sp_busco_horarios_tomados with mfechatur1, mncodmed,mhhmmd1,mhhmmh1

select mwkRephorarios
go top

do while !eof('mwkRephorarios')

	mhoratur	= mhorades2 + (mwkRephorarios.horatur - mhorades1)
	mid		 	= mwkRephorarios.id
	If Empty(mobservac)	
		mobserva = left(iif(mwkRephorarios.afiliado>1,alltrim(mobservai) + " | " ,"") + ;
			alltrim(nvl(mwkRephorarios.observa,"")),100)
	else
		mobserva = left(iif(mwkRephorarios.afiliado>1,alltrim(mobservai) + " | " ,"") + ;
			alltrim(nvl(mwkRephorarios.observa,"")) + " | " + alltrim(mobservac),100)
	Endif 	
	mususec		= mwkRephorarios.UsuarioSector
	if mhoratur < mhorahas2
		mhhmmTur	= val(left(ttoc(mhoratur,2),2)+substr(ttoc(mhoratur,2),4,2))
		mret = sqlexec(mcon1, 'update turnos set codmed = ?mncodmed, tipoturno = 2, '+;
			'diasem = ?mdiasem, fechatur = ?mfechatur, horatur = ?mhoratur, '+;
			'usuarioobserva = ?musua, UsuarioSector = ?mususec, ' + ;
			'observa = ?mobserva, fechaobserva = ?mhoy, hhmmTur = ?mhhmmTur where id = ?mid')
		if mret < 0
			messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS', 18,'Validacion')
			cancel
		endif

	endif
	select mwkRephorarios
	skip 1 in mwkRephorarios

enddo
