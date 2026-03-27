****
** grabo un movimiento cuando hay inconsistencia de datos
****

Parameter mtecode, mteerror, mteusuario, mteform, mllinea, mlrutina, mlversion

if vartype(mlversion)#"C"
	mlversion = prg_version_exe()
endif
jj = Int(Len(Alltrim(mtecode))/250)
For i = 0 To jj
	clin = "linea"+Padl(i,3,"0")
	Public &clin
Next
cmtecode = prg_concat(mtecode)

mtefecha = sp_busco_fecha_serv('DT')

mret = SQLExec(mcon1, "insert into tabCtrlErr( tc_fecha, tc_code, tc_error, tc_usuario, tc_form,"+;
	" tc_linea, tc_rutina, tc_version ) " + ;
	"values(?mtefecha, " + cmtecode + ", ?mteerror, ?mteusuario, ?mteform,"+;
	" ?mllinea, ?mlrutina, ?mlversion)")

For i = 0 To jj
	clin = "linea"+Padl(i,3,"0")
	Erase &clin
Next
