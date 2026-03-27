*-----Agrego caja-------*
PARAMETERS mcaja,mdigito,mestado
    Bandera = .t.
    IF USED('mwkCajaMax')
      SELECT mwkCajaMax
      USE
    ENDIF 
    DO sp_buscar_cajaMaxima WITH mdigito

	*mdigito = SUBSTR(mdigito,1,1)
	mret = SQLEXEC(mcon1,"Select * from tabhcicaja where  caja = ?mcaja and digito = ?mdigito","mwkCajaValid")
	*mret = SQLEXEC(mcon1,"Select * from tabhcicaja where  caja = ?mcaja and substr(digito,1,1) = ?mdigito","mwkCajaValid")
	IF RECCOUNT('mwkCajaValid')> 0
	   MESSAGEBOX("ESTA CAJA YA EXISTE",48,"VALIDACION") 
	   Bandera = .f.
	ENDIF 
	IF !bandera
	   RETURN 
	ENDIF 

	mret = SQLEXEC(mcon1,"insert into tabhcicaja(caja,digito,estado) values(?mcaja,?mdigito,?mestado)")
if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
ENDIF