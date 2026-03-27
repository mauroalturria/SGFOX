*
* Consulta de H.C. depuradas x Entidad Pasivada
*
Lparameters mbuscar, mbusca2

If used('mwkhubica')
	Use in mwkhubica
Endif

If vartype(mbusca2)#"C"
	mret = sqlexec(mcon1,"select HCU_fecha, HCU_caja, HCU_carpeta,"+;
		" HCU_hcdesde, HCU_hchasta, ID as lId"+;
		" from TabHciUbicacion"+;
		" where HCU_codent = ?mbuscar","mwkhubica")
Else
	mret = sqlexec(mcon1,"select HCU_fecha, HCU_caja, HCU_carpeta,"+;
		" HCU_hcdesde, HCU_hchasta, HCU_codent,ID as lId"+;
		" from TabHciUbicacion"+;
		" where ?mbusca2 between HCU_hcdesde and HCU_hchasta","mwkhubica")
Endif

If mret < 0
	Messagebox("EN CONSULTA DE DEPURACION DE H.C.",16,"ERROR")
Endif
