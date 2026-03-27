*
* Base de conocimiento x principio activo
*
Lparameters mprinc

If used('mwkbasecos')
	Use in mwkbasecos
Endif

mret = sqlexec(mcon1,"select TabFarmBaseCo.*,TabFarmPActivo.TFP_pactivo"+;
	" from TabFarmBaseCo"+;
	" join TabFarmPActivo on TFP_inscod = TBC_inscod"+;
	" where TBC_inscod=?mprinc","mwkbasecos")

If mret < 0
	Messagebox("EN BUSCQUEDA DEL INSUMOS EN MAESTRO"+chr(10)+;
		"BASE DE CONOCIMIENTOS",16,"ERROR")
Endif
