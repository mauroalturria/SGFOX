*!*	--------------------------------------------------------------------------
*!*	Cantidad de pacientes evolucionados | cuenta un paciente x hs
*!*	mbusco  = ""
*!*	mfecdes = Ctod("01/01/2009")
*!*	mfechas = Ctod("01/01/2010")
*!*	--------------------------------------------------------------------------
Parameters mfecdes, mfechas, mbusco
*!*	--------------------------------------------------------------------------

mret = SQLExec(mcon1, "SELECT TabGuaEvolnurse.egn_fechah, " + ;
	"idusuario, nomape, " + ;
	"TabGuaEvol.EG_nroregistrac " + ;
	"from TabGuaEvolnurse " + ;
	"left join tabusuario on TabGuaEvolnurse.EGN_usuario = tabusuario.codigovax " + ;
	"Left Join TabGuaEvol on TabGuaEvol.EG_protocolo = TabGuaEvolnurse.EGN_proto " + ;
	"where egn_fechah >= ?mfecdes and  egn_fechah < ?mfechas " + mbusco + ;
	" ", "mwkEvolNur01")

If mret < 0
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
	=Aerr(eros)
	Return .f.
Endif

Select Count(*) as cnt, Hour(egn_fechah) as hora, ttod(egn_fechah) as fecha, * ;
	From mwkEvolNur01 ;
	Group By hora, EG_nroregistrac, fecha, IdUsuario ;
	Into Cursor mwkNur02

*!*	Browse Fields cnt2, fecha, hora, EG_nroregistrac, idusuario, nomape  

Select Count(*) as cnt2, fecha, hora, idUsuario, NomApe ;
	From mwkNur02 ;
	Group By hora, fecha, IdUsuario ;
	Order By fecha, idUsuario, hora ;
	Into Cursor mwkNur03

*!*	Browse Fields cnt2, fecha, hora, idusuario, nomape  



