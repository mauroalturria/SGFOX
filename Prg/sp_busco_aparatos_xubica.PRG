*
* Aparatos ubicación
*
Lparameters mtipo,mubica,mespec,mIdPase, mbusco

mfnull = ctod("01/01/1900")

If Vartype(mbusco) # "C"
	mbusco = ""
Endif 	

If used('mwkubicespe')
	Use in mwkubicespe
Endif

Do Case
	case mTipo = 1
		mret = sqlexec(mcon1,"select tabaparatos.apa_descrip as laparato,"+;
			"TAU_cantidad,TAU_averiado,TAU_obser,TabApaUbica.id as lid,"+;
			"tabaparatos.id as idapa"+;
			" from TabApaUbica"+;
			" join TabAparatos on TabAparatos.id = TabApaUbica.TAU_idapa"+;
			" where TabApaUbica.TAU_idubica = ?mubica and " + ;
			"TabApaUbica.TAU_codesp = ?mespec and TabApaUbica.TAU_IdPase = ?mIdPase "+;
			" and TAU_FPasiva = ?mfnull","mwkubicespe")

	case mTipo = 3
		mret = sqlexec(mcon1,"select tabaparatos.apa_descrip as laparato,"+;
			"TAU_cantidad,TAU_averiado,TAU_obser,TabApaUbica.id as lid,"+;
			"tabaparatos.id as idapa"+;
			" from TabApaUbica"+;
			" join TabAparatos on TabAparatos.id = TabApaUbica.TAU_idapa"+;
			" where TabApaUbica.TAU_IdPase = ?mIdPase and TAU_averiado = 1"+;
			" and TAU_FPasiva = ?mfnull","mwkubicespe")

	case mTipo = 4
		mret = sqlexec(mcon1,"select tabaparatos.apa_descrip as laparato,"+;
			"TAU_cantidad,TAU_averiado,TAU_obser,TabApaUbica.id as lid,"+;
			"tabaparatos.id as idapa, TAU_fechamov, "+;
			"(piso || descrip || numero) as lugar " + ;
			" from TabApaUbica"+;
			" join TabAparatos on TabAparatos.id = TabApaUbica.TAU_idapa "+;
			" Left Join TabUbicacion On TabUbicacion.Id = TabApaUbica.TAU_idubica " + ;
			" where TAU_averiado = 1 " + mbusco + " " + ;
			" and TAU_FPasiva = ?mfnull","mwkubicespe")

	otherwise

		mret = sqlexec(mcon1,"select tabaparatos.apa_descrip as laparato,tabaparatos.id as idapa "+;
			" from TabApaxEsp"+;
			" join TabAparatos on TabAparatos.id = TabApaxEsp.APE_idapa"+;
			" where TabApaxEsp.Ape_codesp = ?mespec and TabApaxEsp.Ape_FPasiva = ?mfnull","mwkubicespe")
endcase 


If mret < 0
	Messagebox("EN CONSULTA DE APARATOS POR UBICACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
		return .f.
Endif

