****
** confirmacion del vale de insumos guardia
****

parameter mprotocolo, maprob

mfmod = sp_busco_fecha_serv('DT')

set deleted off
update confarma set ulti = .f. where Protocolo = mprotocolo and ulti = .t.
set deleted on
select * from mwkvin order by nrovale into cursor mwkvino
select mwkvino
go top
ltodos = .t.
musu  = mwkusuario.codigovax
if maprob = 1 or maprob = 7 or maprob = 2
	do while !eof('mwkvino')
		mobserva = ''
		mivale 		= mwkvino.nrovale
		do while  mivale = mwkvino.nrovale and !eof('mwkvino')
			if mwkvino.Sel = 1
				minsumo 	= mwkvino.INS_codinsumo
				mcantidad	= mwkvino.pia_cantsolicitada
				mdescrip	= mwkvino.INS_descriinsumo
				mcodinsumo	= mwkvino.INS_codpuntero
				mfhcons 	= mwkvino.fechahora
				
				mivale 		= mwkvino.nrovale
				insert into confarma(protocolo, insumo, cantidad, descrip, codinsumo,fhcons, ulti,nval ) ;
					values(mprotocolo, minsumo, mcantidad, mdescrip, mcodinsumo,mfhcons, .t.,mivale  )
			else
				minsumo = alltrim(mwkvino.INS_codinsumo)
				mobserva = mobserva + "_"+minsumo 
				ltodos = .f.
			endif
			skip 1 in mwkvino
		enddo
		update  confarma set observa = mobserva where nval = mivale 
	enddo
endif
if mwkveoinsu.tipopac ="GUA"
	mret = sqlexec(mcon1, "update guardiavale set aprobado = ?maprob, " + ;
		" usuario = ?musu, fechamodif = ?mfmod " + ;
		" where protocolo = ?mprotocolo and codserv = 5410")


	if mret < 0
		=aerr(eros)
		messagebox(eros(2),16,'Validacion')
*		messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS',16,'Validacion')
*		=sqldisconnect(mcon1)
*		cancel
	endif
endif
