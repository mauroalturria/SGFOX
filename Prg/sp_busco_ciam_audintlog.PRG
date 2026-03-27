*
* Auditorias de Internacion Log
*
Lparameters mlid

If used('mwkaudlog')
	Use in mwkaudlog
Endif

*!*	mret = sqlexec(mcon1,"select  tabsectorint.descrip as lsector,TabCiamAudIntLog.TCL_fecdes as desde,"+;
*!*		"TabCiamAudIntLog.TCL_fechasta as hasta from TabCiamAudIntLog left join tabsectorint"+;
*!*		" on tabsectorint.id = TabCiamAudIntLog.TCL_idtipo"+;
*!*		" where TabCiamAudIntLog.TCL_idaudint = ?mlid","mwkaudlog")

mret = sqlexec(mcon1,"select  tabsectorint.descrip as lsector,TabCiamAudIntLog.TCL_fecdes as desde,"+;
	"TabCiamAudIntLog.TCL_hhmming as hora from TabCiamAudIntLog left join tabsectorint"+;
	" on tabsectorint.id = TabCiamAudIntLog.TCL_idtipo"+;
	" where TabCiamAudIntLog.TCL_idaudint = ?mlid","mwkaudlog")

If mret < 0
	Messagebox("EN CONSULTA DE LOG AUDITORIAS DE INTERNACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
