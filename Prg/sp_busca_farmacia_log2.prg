*
* Busqueda Log de movimientos Farmacia Medicamentos Citostáticos, Destinos
*
Lparameters mcod2, mpar2, motiv2, muser2,mfech2

If used('mwkfarmlog2')
	Use in mwkfarmlog2
Endif

mret = sqlexec(mcon1,"select SER_descripserv,TDL_destino, TDL_observa"+;
	" from TabFarmdeslog"+;
	" join SERVICIOS on SER_codserv = TDL_servicio"+;
	" join TabEstados on propietario = 30 and estado = 2 and Descrip = ?motiv2 and  subestado = TDL_movimiento"+;
	" where TDL_partida = ?mpar2 and TDL_insumocodigo = ?mcod2"+;
	" and TDL_idusuario = ?muser2" + ;
	" and TDL_fechamov  = ?mfech2"	,"mwkfarmlog2")

If mret < 0 
	*=aerror(merror)
	*Messagebox(merror(3))
	Messagebox("EN CONSULTA MEDICAMENTOS CITOSTATICOS -LOG DESTINOS-"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
