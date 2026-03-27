Parameters tnOpcion, tcWhere, tcCursor

*!*	tnOpcion = 1
*!*	tcWhere = " where tun_ipsvr = '127.0.0.1' "
*!*	tcCursor = "mwkT"

ldFecNull = Ctod("01/01/1900")

Do Case
	Case tnOpcion = 1
		lcSql = "Select TabTurnum.* " + ;
				"From TabTurnum " + ;
				" Where TabTurnum.TUN_FecPasiva = ?ldFecNull " + tcWhere

	Case tnOpcion = 2
		lcSql = "Select distinct TabTurnum.TUN_IPSVR " + ;
				"From TabTurnum " + ;
				" Where TabTurnum.TUN_FecPasiva = ?ldFecNull " + tcWhere
				


Endcase 

If !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 