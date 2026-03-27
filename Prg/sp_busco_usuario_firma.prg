*
* Busqueda de firmantes
*
Lparameters mtipo,mcodvax,mcodmedico
** tipo 4 
LOCAL mfecha
If vartype(mtipo) <> "N"
	mtipo = 4
Endif
If vartype(mcodvax) = "N"
	mopcion = 1
Endif
If vartype(mcodmedico) = "N"
	mopcion = 2
Endif
mfecha = sp_busco_fecha_serv("DD")

Use in select("mwkUsufirma")
do case
	case mopcion = 1
		mret = sqlexec(mcon1,"select TUF_firmante,TUF_puesto,TUF_codigovax,matriculas"+;
			" from TabUsuarioFirma"+;
			" join TabUsuario on codigovax = TUF_codigovax "+;
			" join PRESTADORES on PRESTADORES.id = TabUsuario.IDCodMed "+;
			" where TUF_fecpasiva >= ?mfecha and TUF_tipo = ?mtipo and TabUsuario.codigovax = ?mcodvax "+;
			" ","mwkUsufirma")
	case mopcion = 2
		mret = sqlexec(mcon1,"select TUF_firmante,TUF_puesto,TUF_codigovax,matriculas"+;
			" from TabUsuarioFirma"+;
			" join TabUsuario on codigovax = TUF_codigovax "+;
			" join PRESTADORES on PRESTADORES.id = TabUsuario.IDCodMed "+;
			" where TUF_fecpasiva >= ?mfecha and TUF_tipo = ?mtipo and TabUsuario.IDCodMed = ?mcodmedico "+;
			" ","mwkUsufirma")
endcase
If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Messagebox("CONSULTA DE FIRMANTES"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif
