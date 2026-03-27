*****
**  Ingreso una Pregistracion a la base
*****

Parameter mnomb, mcodent, mcoddocu, mnrodoc, mnroafi, mdomici, mcodpos, mtel, ;
	mloca, mpcia, msexo, mfecnac,mid,memail  &&&& mid = 0 nuevo, = id actualiza
If Vartype(mid)#"N"
	mid = 0
Endif
If Vartype(memail)#"C"
	memail  = ''
Endif
mdatet = sp_busco_fecha_serv('DT')
mfecha = sp_busco_fecha_serv('DD')

If mid = 0
	mret = SQLExec(mcon1, "insert into preregistra (afiliado, coddocu, codent, codloca, " + ;
		"codpcia, codpostal, direccion, fechaalta, fechahora, fechanac, " + ;
		"nombre, nrodocumento, telefono, usuario, sexo,email) " + ;
		"values(?mnroafi, ?mcoddocu, ?mcodent, ?mloca, ?mpcia, ?mcodpos, " + ;
		"?mdomici, ?mfecha, ?mdatet, ?mfecnac, ?mnomb, ?mnrodoc, ?mtel, " + ;
		"?midusu, ?msexo,?memail  )")
Else
	mret = SQLExec(mcon1, "update preregistra set afiliado = ?mnroafi  , coddocu = ?mcoddocu  "+;
		", codent = ?mcodent  , codloca = ?mloca, codpcia = ?mpcia  , codpostal = ?mcodpos  ,"+;
		" direccion = ?mdomici  , fechaalta = ?mfecha "+;
		" , fechahora = ?mdatet  , fechanac = ?mfecnac  , " + ;
		"nombre = ?mnomb  , nrodocumento = ?mnrodoc  , telefono = ?mtel  , "+;
		"usuario = ?midusu  , sexo= ?msexo, email = ?memail  where id = ?mid ")
Endif
If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA ACTUALIZACION, REINTENTE",16, "Validacion")
	mret=0
Endif

mret = SQLExec(mcon1,"select  '0000000000' as REG_nrohclinica, nombre as REG_nombrepac, direccion as REG_domicilio, " + ;
	"entidades.ENT_descrient, nrodocumento as REG_numdocumento, " + ;
	"fechaalta as REG_fecaltapadron, fechabaja as AFI_fechabaja, fechanac as REG_fecnacimiento, " + ;
	"fechabaja as REG_fecbajapadron, " + ;
	"ENT_fecpas, ENT_turnoshabilit, entidades.ENT_codent, preregistra.id as REG_nroregistrac, " + ;
	"codpostal as REG_cpostal, tabpcia.descrip as REG_provincia, telefono as REG_telefonos, " + ;
	"coddocu as REG_tipodocumento, tabloca.descrip as REG_localidad, " + ;
	"afiliado as AFI_nroafiliado, sexo as REG_sexo " + ;
	"from preregistra, entidades, tabpcia, tabloca " + ;
	"where preregistra.codloca = tabloca.id and " + ;
	"preregistra.codpcia = tabpcia.id and " + ;
	"preregistra.codent  = entidades.ENT_codent and " + ;
	"preregistra.nrodocumento = ?mnrodoc " + ;
	"ORDER BY REG_nombrepac", "mwkbuspacie")

mrecien  = mwkbuspacie.REG_nroregistrac
mret = SQLExec(mcon1,"select REG_nrohclinica FROM registracio "+;
	" where REG_nroregistrac = ?mrecien  " ,"mwkcontrol" )
If Reccount('mwkcontrol')>0
	mret = SQLExec(mcon1,"delete from preregistra where id = ?mrecien ")
	If mret < 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
	mret = SQLExec(mcon1, "insert into preregistra (afiliado, coddocu, codent, codloca, " + ;
		"codpcia, codpostal, direccion, fechaalta, fechahora, fechanac, " + ;
		"nombre, nrodocumento, telefono, usuario, sexo,email) " + ;
		"values(?mnroafi, ?mcoddocu, ?mcodent, ?mloca, ?mpcia, ?mcodpos, " + ;
		"?mdomici, ?mfecha, ?mdatet, ?mfecnac, ?mnomb, ?mnrodoc, ?mtel, " + ;
		"?midusu, ?msexo,?memail  )")
	If mret < 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

	mret = SQLExec(mcon1,"select  '0000000000' as REG_nrohclinica, nombre as REG_nombrepac, direccion as REG_domicilio, " + ;
		"entidades.ENT_descrient, nrodocumento as REG_numdocumento, " + ;
		"fechaalta as REG_fecaltapadron, fechabaja as AFI_fechabaja, fechanac as REG_fecnacimiento, " + ;
		"fechabaja as REG_fecbajapadron, " + ;
		"ENT_fecpas, ENT_turnoshabilit, entidades.ENT_codent, preregistra.id as REG_nroregistrac, " + ;
		"codpostal as REG_cpostal, tabpcia.descrip as REG_provincia, telefono as REG_telefonos, " + ;
		"coddocu as REG_tipodocumento, tabloca.descrip as REG_localidad, " + ;
		"afiliado as AFI_nroafiliado, sexo as REG_sexo, email as reg_email " + ;
		"from preregistra, entidades, tabpcia, tabloca " + ;
		"where preregistra.codloca = tabloca.id and " + ;
		"preregistra.codpcia = tabpcia.id and " + ;
		"preregistra.codent  = entidades.ENT_codent and " + ;
		"preregistra.nrodocumento = ?mnrodoc " + ;
		"ORDER BY REG_nombrepac", "mwkbuspacie")
	If mret < 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
Endif
If Used("mwkcontrol" )
	Use In mwkcontrol
Endif

Select mwkbuspacie
msql = 'select *, 1 as preacre from mwkbuspacie into cursor mwkbuspacie1'


If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0
Endif
