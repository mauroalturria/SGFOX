Parameters tnIdQuiro, tnEstado

If Parameters() < 2
	Return .f.
Endif 	

TEXT To lcsql Textmerge Noshow Pretext 7
	Update TabQuirofano Set Estado = ?tnEstado Where Id = ?tnIdQuiro
ENDTEXT

If !Prg_EjecutoSql(lcSql,"mwkAux")
	Return .F.
Endif