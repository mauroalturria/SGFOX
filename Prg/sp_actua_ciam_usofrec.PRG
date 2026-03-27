*
* Actualizacion campo UsoFrec, CIAM [Paciente] - [Pedido], estadísticos de uso
*
Lparameters mbusca

If used('mwkdetuso')
	use in mwkdetuso
Endif

mret = sqlexec(mcon1,"select TCU_usofrec"+;
	" from TabCiamUbica where id=?mbusca","mwkdetuso")

If mret > 0
	If used('mwkdetuso')
		If reccount('mwkdetuso')>0
			muso = mwkdetuso.TCU_usofrec + 1
			mret = sqlexec(mcon1,"update TabCiamUbica set TCU_usofrec=?muso where id=?mbusca")
			If mret < 0
				Messagebox("EN LA ACTUALIZACION DE ENTIDADES"+chr(10)+;
				"ESTADISTICO DE USO - AVISE A SISTEMAS",16,"ERROR")
			Endif
		Endif
	Endif
Else
	Messagebox("EN LA BUSQUEDA DE CIAM ENTIDADES"+CHR(10)+;
	"AVISE A SISTEMAS",16,"ERROR")
Endif

If used('mwkdetuso')
	use in mwkdetuso
Endif
