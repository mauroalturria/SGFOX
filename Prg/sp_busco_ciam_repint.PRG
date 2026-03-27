*
* Elaboro cursor para reporte, excel, OpenOffice
*
Lparameters mform

With mform
	If used('mwkciaml')
		Use in mwkciaml
	Endif
	mwhere = ''
	mccad = ''
	If .lblEnt.caption <> "    TODAS"
		msel = .f.
		For ncnt = 1 to .lstent.listcount
			If .lstent.selected(ncnt)
				msel = .t.
				Exit
			Endif
		Endfor
		If msel
			mccad ="( "
			For ncnt = 1 to .lstent.listcount
				If .lstent.selected(ncnt)
					mccad = mccad + allt(.lstent.list(ncnt,2))+" , "
					*.lstent.selected(ncnt) = .f.
				Endif
			Endfor
			mccad = " where TCD_entidad in " +  substr(mccad,1,len(mccad)-2) + " )"
		Endif
		*.lblEnt.caption ="    TODAS"
		mwhere = mccad
	Endif
	
	*left(ttoc(TCD_fechapedido),16)

	Select NroPedido,ENT_descrient,TCD_fechapedido as lfecha,TCD_documento,;
		TCD_nombrepac,TCD_txtedad,TCD_diagnostico, ;
		sp_busco_ciam_orubtra(TCD_ubicacion,1,TCD_detalle) as origen, ;
		sp_busco_ciam_orubtra(TCD_solicdetid,2,TCD_detalle) as ubica, ;
		sp_busco_ciam_orubtra(NroPedido,3,TCD_detalle) as derivado, ;
		sp_busco_ciam_orubtra(NroPedido,4,TCD_detalle) as hrtrasla ;
		from mwkciam &mwhere order by ENT_descrient,TCD_fechapedido desc into cursor mwkciaml

Endwith
