*!*	QUE MUESTRO EN EL LLAMADOR

lparameters lcIpServer, lnPage

*!*	lnPage = 1
*!*	lcIpServer     = "172.16.1.9"

mfecnull = ctod("01/01/1900")

do case 
	case lnPage = 1

		mret = sqlexec(mcon1,"select Top 5 *, " + ;
			"Reg_nombrepac as LLA_nombrepac " + ;
			"from Tabllamador " + ;
			"Left Join Registracio on Registracio.Reg_NroRegistrac = Tabllamador.LLA_nroregistrac " + ;
			"where LLA_IpServer = ?lcIpServer " + ;
			"and not LLA_fechapant = ?mfecnull " + ;
			"Order by Id Desc ", "mwkllamados")		

	case lnPage = 2
		mret = sqlexec(mcon1,"select Top 8 Tabllamador.*, " + ;
			"Reg_nombrepac as LLA_nombrepac " + ;
			"from Tabllamador " + ;
			"Left Join Registracio on Registracio.Reg_NroRegistrac = Tabllamador.LLA_nroregistrac " + ;
			"where LLA_IpServer = ?lcIpServer " + ;
			"and not LLA_fechapant = ?mfecnull " + ;
			"Order by Id Desc ", "mwkllamados")
Endcase

if mret <= 0
	aerror(eros)
	Do prg_error_SQL("NO PUDO ACTUALIZAR")
	return .F.
endif 
