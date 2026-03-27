PARAMETERS midusuario,midestado,abm

mret = sqlexec(mcon1, " select * from tabpDetusuario  WHERE  idusuario  = ?midusuario and idestado = ?midestado   ", "mwkControl")

IF abm = 1
   IF RECCOUNT('mwkControl') = 0
	mret = sqlexec(mcon1, " INSERT INTO tabpDetusuario (idusuario,idestado)	values(?midusuario,?midestado) ")
   ENDIF 	

ELSE
  IF RECCOUNT('mwkControl') > 0
   	mret = sqlexec(mcon1,   " DELETE FROM tabpDetusuario WHERE idusuario  = ?midusuario and idestado = ?midestado ")
  endif 	
ENDIF 

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
ENDIF
