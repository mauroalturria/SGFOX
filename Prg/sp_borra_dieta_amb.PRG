****
** elimino componentes de la dieta
****
parameter midpac, mbusca

if type('mbusca')#"C"
	mbusca=''
endif

Local mFecBaja
mFecBaja = sp_busco_fecha_serv('DT')

*!*	mret = sqlexec(mcon1, "delete from TabNutDetAmb " + ;
*!*		" where TND_idPaciente = ?midpac " + mbusca )

mret = sqlexec(mcon1, "Update TabNutDetAmb " + ;
	"Set TND_FecBaja = ?mFecBaja " + ;
	"Where TND_idPaciente = ?midpac " + mbusca )

If mRet <= 0
	Messagebox("ERROR DE ACTUALIZACION",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 