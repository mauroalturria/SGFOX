*
* Busqueda log de moviemiento de una solicitud
*
Lparameters mlid

Use in select("mwklogmov")

mret = sqlexec(mcon1,"select TLL_fecmov,descrip,TLL_idusuario"+;
	" from TabLGHceLog"+;
	" inner join TabEstados on propietario=37 and estado=8 and subestado=TLL_estado"+;
	" where TLL_idhce=?mlid","mwklogmov")

If mret < 0
	Messagebox("CONSULTA DE HCE LEGALES SOLICITADAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.

