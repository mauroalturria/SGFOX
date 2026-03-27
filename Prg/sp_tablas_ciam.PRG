*
* Tablas Ciam, consulta de distribución de camas
*
If used('mwksectorint')
	Use in mwksectorint
Endif
If used('mwksecint')
	Use in mwksecint
Endif
If used('mwkautoriza')
	Use in mwkautoriza
Endif
If used('mwkcategoria')
	Use in mwkcategoria
Endif
mret = sqlexec(mcon1, "select sec_codsector,sec_descripsec,sec_habitsala,SEC_secquirur,SEC_internacion "+;
	"from sectores " +;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")
If mret > 0
	mret = sqlexec(mcon1, "select * from tabsectorint where id <> 16 and id <100000 order by descrip", "mwksecint")
Else
	mpaso = .t.
Endif
If mret > 0
	mret = sqlexec(mcon1, "select * from tabautoriza where codsector = 16 order by descrip", "mwkautoriza")
Else
	mpaso = .t.
Endif
If mret > 0
	mret = sqlexec(mcon1, "select * from tabcategoria where id <100000 order by descrip", "mwkcategoria")
Else
	mpaso = .t.
Endif
