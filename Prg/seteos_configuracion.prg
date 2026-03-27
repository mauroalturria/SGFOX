** Creamos el objeto de configuracion

Set Procedure To sp_conf_class
objConfig = Createobject("configuracion")
objConfig.SetCentro("")   && Seteo Ambito-Policonsultorio.

** Asignamos el valor del ambito

mxambito = objConfig.pAmbito

If mxambito = 0
	objConfig.SetDefault()
	mxambito = 1 && Default S.G.
Endif
If Vartype(mxcentromedico )<>"N"
	Public mxcentromedico
	mxcentromedico =1
Endif
** Cargamos el objeto al screen
_Screen.AddProperty("oConf",objConfig)
If mxcentromedico <3
**Ponemos el fondo del screen.
	cfondo = Iif(_Screen.Width<=800,_Screen.oConf.getvalue("pfondo_centro"),_Screen.oConf.getvalue("pfondo_centro2"))
Else
	cfondo = Iif(_Screen.Width<=800,_Screen.oConf.getvalue("pfondo_centro"),_Screen.oConf.getvalue("pfondo_centro3"))
Endif
If !Empty(cfondo)
	Modify Windows Screen;
		fill File &cfondo
Endif

If mxambito > 2
	If At("Policonsultorio",_Screen.Caption,1) = 0
		mtpoli = "Policonsultorio : "+Alltrim(_Screen.oConf.getvalue("pNombre_Centro"))
		_Screen.Caption = _Screen.Caption + Space(10) + mtpoli
	Else
		mtpoli = "Policonsultorio : "+Alltrim(_Screen.oConf.getvalue("pNombre_Centro"))
		lcAntec = Alltrim(Substr(_Screen.Caption, 1, -1+ At("Policonsultorio",_Screen.Caption,1)))
		_Screen.Caption = lcAntec + Space(10) + mtpoli
	Endif
Endif

Release objConfig
