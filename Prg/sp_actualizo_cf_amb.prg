*!*	------------------------------------------------------------------------
*!*	actualizo codigos de facturacion
*!*	------------------------------------------------------------------------
Lparameters mfecreal

mfhora = sp_busco_fecha_serv('DT')
horalimite = Ctot(Dtoc(Ttod(mfhora) )+" 11:00:00")
mhora = Hour(mfhora)*100 + Minute(mfhora)

Select * ;
	FROM mwkpndieta1 ;
	Into Cursor mwkactualiza


If Reccount ('mwkactualiza')>0
	Do sp_actualizo_tab_nut_amb With 1,mfecreal
Endif

