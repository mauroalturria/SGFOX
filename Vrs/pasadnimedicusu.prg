Select tabusuario_med
SET STEP ON
Scan
	mimat = Transform(matricula)
	Select b_prestadores
	Locate For matprov = tabusuario_med.matricula
	If Found()
		Select tabusuario_med
		Replace nrodocumento With b_prestadores.dni
	Endif
	Select tabusuario_med
Endscan
