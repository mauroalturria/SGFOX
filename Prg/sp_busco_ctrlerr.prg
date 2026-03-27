Parameters mfecdes, mfechas

mcon1 = Sqlexec(mcon1,"select Id, Cast(left(Tc_code,60) as char(100)) as lcode, Tc_error, " + ;
	"Tc_form, Tc_usuario, Tc_fecha, Tc_code " + ;
	"from tabCtrlErr " + ;
	"where tc_fecha Between ?mfecdes and ?mfechas " + ;
	"order by tc_fecha desc ","mwkCtrlErr")

If mcon1 <= 0
	Aerror(eros)
	Messagebox("ERROR DE LECTURA DE ERRORES",48,"VALIDACION")
	Return .f.
Endif 	