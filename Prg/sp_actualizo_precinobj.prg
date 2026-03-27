Lparameters mOpcion, lnId, lnIdPase, lnIdObj, lnPrec, lbEstado, lcUsuario

mfechoy = sp_busco_fecha_serv('DT')

Do Case
	case mOpcion = 1
			If lnId = 0
				mRet = Sqlexec(mcon1,"Insert into TabPasePrecinObj " + ;
					"( PRO_idobjprec, PRO_idpase, PRO_abierto, PRO_fechora, " + ;
						"PRO_idusuario, PRO_ipadress, PRO_nroprecin ) Values " + ;
					"( ?lnIdObj, ?lnIdPase, ?lbEstado, ?mfechoy, " + ;
					" ?lcUsuario, ?myIp, ?lnPrec )")	
			Else
				mRet = Sqlexec(mcon1,"Update TabPasePrecinObj Set " + ;
						"PRO_idobjprec = ?lnIdObj, PRO_idpase = ?lnIdPase, " +;
						"PRO_abierto = ?lbEstado, PRO_fechora = ?mfechoy, " + ;
						"PRO_idusuario = ?lcUsuario, PRO_ipadress = ?myIp, " + ;
						"PRO_nroprecin = ?lnPrec where id = ?lnId ")
			Endif 
	otherwise

endcase 

