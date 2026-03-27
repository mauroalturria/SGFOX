Select dobles
Scan
	miafi = Round(afiliado ,0)
	mireg= reg_nroregistrac
	Requery('turno')
	Update turno Set afiliado = mireg
Endscan


Select arreglo
Scan
	mides = descrip_b
	mid = id_a
	SELECT tabusuario
	
	Update tabusuario Set descrip = mides WHERE id = mid
Endscan


update turnoids set afiliado = 0, usuario = '', codprest = 0,observa ='Depuracion libres AGENDA-SISTEMAS' ,  ;
			 codmedsoli = 0, solicigia = 0, codreserva = '', codent = 0, tipotomado = 0,   ;
			 codserv = 0, codesp = '' ,   UsuarioSector = 0 ,tipoturno = 9  