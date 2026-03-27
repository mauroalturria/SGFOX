*!*	If !prg_ver_alfabeta(lcUrl)
*!*				Messagebox("ERROR AL ABRIR ALFABETA",48,"VALIDACION")
*!*	Endif 

tcUrl = 'http://www.alfabeta.net'

If !prg_veo_url(tcUrl)
	Return .f.
Endif 

