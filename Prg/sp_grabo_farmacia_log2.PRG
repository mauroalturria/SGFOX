*
* Grabo Log Citostáticos, Auditorias con Destinos (Dispensación, Devolución, Préstamo)
*
lparameters mfechamov,midusua

if vartype(midusua) # "C"
	mfechamov = sp_busco_fecha_serv("DT")
	midusua   = mwkusuario.idusuario
endif

Dimension vd[6]
mfechamov = sp_busco_fecha_serv("DT")
midusua   = mwkusuario.idusuario
Select mwkfarauditrep
Scan
	If len(alltrim(mwkfarauditrep.ldestino))>0
		vd[1] = mwkfarauditrep.TCI_codinsumo
		vd[2] = mwkfarauditrep.TCI_partida
		vd[3] = mwkfarauditrep.ldestino
		vd[4] = mwkfarauditrep.lobs
		vd[5] = mwkfarauditrep.lserval
		vd[6] = mwkfarauditrep.ldesid
		mret = sqlexec(mcon1, "insert into TabFarmDesLog " + ;
			"(TDL_fechamov,TDL_idusuario,TDL_insumocodigo,TDL_partida,TDL_destino,"+;
			"TDL_observa,TDL_servicio,TDL_movimiento)"+;
			" values "+;
			"(?mfechamov,?midusua,?vd[1],?vd[2],?vd[3],?vd[4],?vd[5],?vd[6])")
		If mret < 0
		=aerror(merror)
		
		messagebox(merror(3))
		
		*	Messagebox("REGISTRO DE MOVIMIENTOS -LOG DESTINOS-"+chr(10)+;
		*		"AVISE A SISTEMAS",16,"ERROR")
			Exit
		Endif
	Endif
Endscan
Release vd
