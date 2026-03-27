***************
** anulo presup
**********

lparameters mPA_idAutprevia,mPA_idPresu

mfecpas = sp_busco_fecha_serv("DD")
mret = sqlexec(mcon1, "UPDATE Zabpresuaut  set  PA_fechapas = ?mfecpas where  PA_idAutprevia = ?mPA_idAutprevia  ")

if mret < 0
	=aerror(merror)
	messagebox(alltrim(merror(3)),16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
ENDIF
 
mret = sqlexec(mcon1, "UPDATE tabpresupuestos SET  Estadoactual = 19  where id = ?mPA_idPresu")
if mret < 0
	=aerror(merror)
	messagebox(alltrim(merror(3)),16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
ENDIF