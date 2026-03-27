******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :09/10/2003
********************
parameter vr_nroFac,vr_fecha,vr_Usu,vr_ptovta,vr_comp,vr_letra


sele MWKBonoSelec
go top

do while !eof('MWKBonoSelec')
	mbonDes =MWKBonoSelec.nrodesde
	mbonHas =MWKBonoSelec.nrohasta
	mcant   =MWKBonoSelec.cantidad
	mimp    =MWKBonoSelec.Importe
	mtpoB   =MWKBonoSelec.idbono
	mvalUni =MWKBonoSelec.Unidad
	mserie 	=MWKBonoSelec.serie
	
	mdetalle=transform(mbonDes) + chr(9) + transform(mbonHas) + chr(9) ;
		+ transform(mcant)+ chr(9) + transform(mimp) + chr(9) +transform(mtpoB)+ chr(9) ;
		+transform(vr_nrofac)+ chr(9) +transform(vr_fecha)+ chr(9) + mserie

	mret= sqlexec(mcon1,'INSERT INTO TabdetalleFac(BonoSerie, Bonodesde, BonoHasta, Cantidad, ImporteB, letraComp, '+;
		' NroFactura, tipobono,tipocomp,ptovta,valorUni, fechagraba, usuario)'+;
		'VALUES(?mserie,?mbonDes,?mbonHas,?mcant,?mimp,?vr_letra,?vr_nrofac, ?mtpob,'+;
		'?vr_comp,?vr_ptovta,?mvalUni,?vr_fecha,?vr_usu)')

	if mret < 0
		=aerr(eros)
		mmsgerr = eros(2)
		do sp_insert_tabCtrlErr with mdetalle, mmsgerr , vr_usu, "sp_grabo_detalle_fac"
		messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')
		mret=0
	endif
	mret = sqlexec(mcon1," SELECT NroBono FROM TabBonoLast "+ ;
		" WHERE tipobono = ?mtpob and usuario =?vr_usu " ;
		, "MwkLastBon")
	*	if MwkLastBon.NroBono < mbonHas
	mret = sqlexec(mcon1," update TabBonoLast set NroBono = ?mbonHas, bonoserie = ?mserie "+ ;
		" WHERE tipobono = ?mtpob and usuario =?vr_usu" )
	*	endif
	mret = sqlexec(mcon1," delete from TabBonoDet where  NroBono >= ?mbonDes "+ ;
		" and NroBono <= ?mbonHas and tipobono = ?mtpob and bonoserie = ?mserie" )
	mret = sqlexec(mcon1," select nrobono from TabBonoDet where  NroBono >= ?mbonDes "+ ;
		" and NroBono <= ?mbonHas and tipobono = ?mtpob and bonoserie = ?mserie" ,"mwkcontrola")
	if mret < 0
		=aerr(eros)
		mmsgerr = eros(3)
		do sp_insert_tabCtrlErr with mdetalle, mmsgerr , vr_usu, "sp_grabo_detalle_fac"
	endif
	if reccount("mwkcontrola")>0
		do sp_insert_tabCtrlErr with mdetalle, mmsgerr , vr_usu, "no_borro_bonos"
	endif

	select MWKBonoSelec
	skip 1 in MWKBonoSelec
Enddo

