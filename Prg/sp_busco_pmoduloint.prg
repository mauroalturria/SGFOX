****
** Busco modulos
****

mret = sqlexec(mcon1, "SELECT * FROM TabPModulo where ID in "+;
		" (SELECT mcodigo as codid from tabprmod where mtipo=1 union "+;
		"   SELECT pcodigo as codid from tabprprest where ptipo=1 union"+;
		"     SELECT ccodigo as codid from tabprconce where ctipo=1 )"+;
		"" , "mwkmod")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif