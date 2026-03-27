*
* Busqueda de registros Hosp. día oncológico
*
Parameters mfecdes, mfechas

mserv = 1130

*!*	mfecdes = Ctod("01/01/2011")
*!*	mfechas = Ctod("21/01/2011")
*!*	 mserv = 2150 && para pruebas

Use in select("mwkamboncoCanc")

mret = sqlexec(mcon1,"select TurnosCancel.fechatur, "+;
	"TabAmbonco.TAO_flabor  , Registracio.REG_nombrepac ,"+;
	"TabAmbonco.TAO_autesque, TabAmbonco.TAO_autacomp   ,"+;
	"TabAmbonco.TAO_autprqui, TabAmbonco.TAO_autfarm    ,"+;
	"TabAmbonco.TAO_obsesque, TabAmbonco.TAO_obsacomp   ,"+;
	"TabAmbonco.TAO_obsprqui, TabAmbonco.TAO_fmedfarma,  TabAmbonco.TAO_consentimiento   ,"+;
	"TabAmbonco.TAO_obsfarma, TabAmbonco.TAO_usuario    ,"+;
	"TabAmbonco.TAO_fechamov, TabAmbonco.TAO_registracio,"+;
	"TabAmbOnco.id as lid   , TurnosCancel.id as ltid   ,"+;
	"TurnosCancel.codprest as lpresta,"+;
	"TurnosCancel.codserv as lserv   ,"+;
	"TurnosCancel.confirmado as lconfirma, TurnosCancel.horatur, " + ;
	"TurnosCancel.nrovale, " + ;
	"Registracio.REG_nroregistrac, Registracio.REG_nrohclinica, " + ;
	"Pre_codservicio, PRE_descriprest, ENT_descrient,ENT_nroprestadorexterno," +;
	" TurnosCancel.feccancela," +;
	" TurnosCancel.observa," +;
	" TurnosCancel.usucancela," +;
	" TabMotivos.descrip as lmotivo " +;
	" From TurnosCancel " + ;
	" Join Prestacions On TurnosCancel.CodPrest = Prestacions.Pre_CodPrest " + ;
	" Join Registracio On REG_nroregistrac = TurnosCancel.afiliado " + ;
	" Join TabAmbonco On (TabAmbonco.TAO_Registracio = Registracio.REG_nroregistrac"+;
	" and TabAmbonco.TAO_fturno = TurnosCancel.FechaTur)"+;
	" Join Entidades on Entidades.ENT_codent = TurnosCancel.codent"+;
	" Left join TabMotivos on (TabMotivos.id = TurnosCancel.codcancela and TabMotivos.sector = 0)"+;
	" Where Prestacions.Pre_codservicio = ?mserv" + ;
	" and TurnosCancel.FechaTur >= ?mfecdes and TurnosCancel.fechatur <= ?mfechas group by TurnosCancel.codreserva","mwkamboncoCanc")	

If mret < 0
	Messagebox("EN CONSULTA DE HOSP. DE DIA ONCOLOGICO",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.

*mfnull  = ctod("01/01/1900")
*mfechas = mfechas + 1
*!*	mret = sqlexec(mcon1,"select TAO_fturno,TAO_flabor,"+;
*!*		"REGISTRACIO.REG_nombrepac,TAO_autesque ,TAO_autacomp,"+;
*!*		"TAO_autprqui,TAO_autfarm,TAO_obsesque,TAO_obsacomp,"+;
*!*		"TAO_obsprqui, TAO_fmedfarma,TAO_obsfarma,TAO_usuario,"+;
*!*		"TAO_fechamov,TAO_registracio,TabAmbOnco.id as lid"+;
*!*		" from TabAmbOnco join REGISTRACIO"+;
*!*		" on REG_nroregistrac = TabAmbOnco.TAO_registracio"+;
*!*		" where TAO_fturno >= ?mfecdes and TAO_fturno < ?mfechas"+;
*!*		" and TAO_fpasiva = ?mfnull","mwkambonco")
