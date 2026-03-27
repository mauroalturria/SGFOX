PARAMETERS mcaja 
mret = sqlexec(mcon1, "Select  * from TabHciarchivo where hca_orden  = ?mcaja ","mwkValidBorCaja")
SELECT mwkValidBorCaja
IF RECCOUNT('mwkValidBorCaja') = 0
    mret = sqlexec(mcon1, "delete from TabHciCaja where id  = ?mcaja ")
ELSE
    MESSAGEBOX("TIENE H.CLINICA RELACIONADAS A ESA CAJA",48,"VALIDACION")
    RETURN 
ENDIF 

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif