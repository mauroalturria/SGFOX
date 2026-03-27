*!*	 
*!*	Busco Documentos para una prestacion
*!*	---------------------------------------------------
Lparameter mCodPrest, mCompleto

If Not mCompleto
	mret = sqlexec(mcon1, "Select TabDocPrest.*, " + ;
		"TabDocGral.Descripcion, TabDocGral.Tipo, TabDocGral.Documento " + ;
		"from TabDocPrest " + ;
		"Inner Join TabDocGral On TabDocGral.Id = TabDocPrest.DP_IdDocGral " + ;
		"where DP_CodPrest = ?mCodPrest " + ;
		"order by Descripcion", "mwkDocPrest")

Else && completo
	mret = sqlexec(mcon1, "Select TabDocPrest.*, " + ;
		"TabDocGral.Descripcion, TabDocGral.Tipo, TabDocGral.Documento, Cast(1 as int) as Orden " + ;
		"from TabDocPrest " + ;
		"Inner Join TabDocGral On TabDocGral.Id = TabDocPrest.DP_IdDocGral " + ;
		"where DP_CodPrest = ?mCodPrest " + ;
	"Union Select TabDocPrest.*, " + ;
		"TabDocGral.Descripcion, TabDocGral.Tipo, TabDocGral.Documento, Cast(2 as int) as Orden " + ;
		"from TabDocPrest " + ;
		"Inner Join TabDocGral On TabDocGral.Id = TabDocPrest.DP_IdDocGral " + ;
		"where DP_CodPrest <> ?mCodPrest " + ;		
		"order by Orden, Descripcion", "mwkDocPrest")
Endif 

If mret <= 0
	Messagebox("ERROR AL OBTENER LOS DOCUMENTOS ",48, "VALIDACION")
	Aerror(eros)
	?eros(3)
	Return .f.
Endif 