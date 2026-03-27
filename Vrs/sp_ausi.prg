prima = .t.

Select mwkcontrol
Scan
	if prima
		locate for reg_nroreg =   828996
		prima = .f.
	endif		
	If mal = 0
		mitiempo = seconds()
		pasa = 0
		minombre = strtran(reg_nombre,"'","")
		Do sp_control_auditoria2 with reg_numdoc,minombre , reg_nroreg,pasa
		mitiempototal = round(seconds()- mitiempo /60,4)
		Select mwkcontrol
		qpasa = str(10000+pasa,5,0)
		qm = iif(substr(qpasa,2,1)= "1","| Vales <> Nombre |","")
		qm = qm + iif(substr(qpasa,2,1)= "2","| NºAfi.INV |","")
		qm = qm + iif(substr(qpasa,2,1)= "3","| Vales <> Nombre || NºAfi.INV |","")
		qm = qm + iif(substr(qpasa,3,1)= "3","| Afi-Ent DUP |",;
			iif(substr(qpasa,3,1)= "2","| Afi DUP |",""))
		qm = qm + iif(substr(qpasa,4,1)= "2","| NroDoc = 0 |",;
			iif(substr(qpasa,4,1)= "1","| NroDoc DUP |",;
			iif(substr(qpasa,4,1)= "3","| TipoDoc= 0 |","")))
		qm = qm + iif(substr(qpasa,5,1)= "3","| Nombre DUP |","")
		If pasa=0
			Do sp_grabo_auditoria2 with 0, reg_nroreg, '*',2, 0
		Else
			Wait windows reg_nombre+"-->"+str(pasa) nowait
			Replace mal with pasa,TPV_Observ with qm
		Endif
	Else
		If mal = 9
			mreg = mwkcontrol.reg_nroreg
			mret = sqlexec(mcon1, "update TabPacVip set TPV_Audit = 0 "+;
				" where TPV_NroReg = ?mreg ")

		Endif

	Endif
Endscan
Do sp_desconexion
