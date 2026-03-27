Select b_vales
Set Step On
Scan
	miambi = pac_codambito 
		miafi = PAC_codhci
		miprest = PIA_codprest
		miusu = idusuario
		mifecconf = val_horacargasolic
		mivale = valesasist
		Update b_turnoid Set nrovale = mivale , confirmado = 1, ;
			fechaconfirma =mifecconf ,usuarioconfirma = miusu  ;
			WHERE  afiliado= miafi And  codprest= miprest;
			AND codprest = miprest AND codambito = miambi 

Endscan
