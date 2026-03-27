Select algo
SET STEP ON
Scan
	mimat = matriculas_a
	Select b_prestadores
	Locate For matriculas= mimat
	If FOUND()
		Replace cuil With algo->cuil_b
	ENDIF
	Select algo
Endscan
