*
* Grabo Log de movimientos
*
Lparameters mid, mest, muser, mfech

If vartype(muser) <> "C"
	muser = Alltrim(mwkusuario.idusuario)
Endif

If vartype(mfech) <> "T"
	mfech = sp_busco_fecha_serv("DT")
Endif

mret = sqlexec(mcon1,"insert into TabLGHceLog "+;
	"(TLL_idhce,TLL_estado,TLL_idusuario,TLL_fecmov)"+;
	" values "+;
	"(?mid,?mest,?muser,?mfech)")

If mret < 0
	Messagebox("REGISTRO HCE LEGALES LOG DE MOVIMIENTOS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
