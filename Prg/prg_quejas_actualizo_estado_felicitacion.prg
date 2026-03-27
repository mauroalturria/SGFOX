LPARAMETERS tnnumqueja
mret=SQLEXEC(mcon1,"INSERT INTO TabQuejaRespuestaResponsable "+;
" (tqrr_numeroqueja,tqrr_estadorespuesta ) VALUES(?tnnumqueja,2)")
SET STEP ON 
IF mret<1
=AERROR(EROS)
MESSAGEBOX(EROS(3))
ENDIF 