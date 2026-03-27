Parameters toForm, toCmd, tbINV, tcDESC

If Type('m' + Alltrim(toForm) + toCmd) #'U'
	tbINV = .T.
	tbDESC = ""
	Return tbINV
Else
	tbINV = .F.
	tbDESC = "No tiene permisos"
	Return tbINV
Endif





