*
* LEGALES PACIENTES EXTERNOS, INGRESO ó ACTUALIZACION
*
Parameter mnomb,mcodent,mcoddocu,mnrodoc,mnroafi,mdomici,mcodpos,mtel, ;
	mloca,mpcia,msexo,mfecnac,mid

*!* mid = 0 nuevo, = id actualiza

If vartype(mid)#"N"
	mid = 0
Endif

mdatet = sp_busco_fecha_serv('DT')
mfecha = sp_busco_fecha_serv('DD')

If mid = 0
	mret = sqlexec(mcon1, "insert into TabLGPrereg (TLP_afiliado, TLP_coddocu, TLP_codent, TLP_codloca, " + ;
		"TLP_codpcia, TLP_codpostal, TLP_direccion, TLP_fechaalta, TLP_fechahora, TLP_fechanac, " + ;
		"TLP_nombre, TLP_nrodocumento, TLP_telefono, TLP_usuario, TLP_sexo) " + ;
		"values(?mnroafi, ?mcoddocu, ?mcodent, ?mloca, ?mpcia, ?mcodpos, " + ;
		"?mdomici, ?mfecha, ?mdatet, ?mfecnac, ?mnomb, ?mnrodoc, ?mtel, " + ;
		"?midusu, ?msexo)")
Else
	mret = sqlexec(mcon1, "update TabLGPrereg set TLP_afiliado = ?mnroafi,TLP_coddocu = ?mcoddocu,"+;
		"TLP_codent = ?mcodent,TLP_codloca = ?mloca,TLP_codpcia = ?mpcia ,TLP_codpostal = ?mcodpos,"+;
		"TLP_direccion = ?mdomici,TLP_fechaalta = ?mfecha,"+;
		"TLP_fechahora = ?mdatet,TLP_fechanac = ?mfecnac," + ;
		"TLP_nombre = ?mnomb,TLP_nrodocumento = ?mnrodoc,TLP_telefono = ?mtel,"+;
		"TLP_usuario = ?midusu,TLP_sexo = ?msexo where id = ?mid")
Endif

If mret < 0
	Messagebox("ERROR EN LA ACTUALIZACION, REINTENTE",16, "Validación")
	mret=0
	Do prg_cancelo
Endif

mret = sqlexec(mcon1,"select  '0000000000' as REG_nrohclinica, TLP_nombre as REG_nombrepac, TLP_direccion as REG_domicilio, " + ;
	"entidades.ENT_descrient, TLP_nrodocumento as REG_numdocumento, " + ;
	"TLP_fechaalta as REG_fecaltapadron, TLP_fechabaja as AFI_fechabaja, TLP_fechanac as REG_fecnacimiento, " + ;
	"TLP_fechabaja as REG_fecbajapadron, " + ;
	"ENT_fecpas, ENT_turnoshabilit, entidades.ENT_codent, TabLGPrereg.id as REG_nroregistrac, " + ;
	"TLP_codpostal as REG_cpostal, tabpcia.descrip as REG_provincia, TLP_telefono as REG_telefonos, " + ;
	"TLP_coddocu as REG_tipodocumento,tabloca.descrip as REG_localidad, " + ;
	"TLP_afiliado as AFI_nroafiliado, TLP_sexo as REG_sexo " + ;
	"from TabLGPrereg, entidades, tabpcia, tabloca " + ;
	"where TabLGPrereg.TLP_codloca = tabloca.id and " + ;
	"TabLGPrereg.TLP_codpcia = tabpcia.id and " + ;
	"TabLGPrereg.TLP_codent  = entidades.ENT_codent and " + ;
	"TabLGPrereg.TLP_nrodocumento = ?mnrodoc " + ;
	"ORDER BY REG_nombrepac", "mwkbuspacie")

mrecien  = mwkbuspacie.REG_nroregistrac

mret = sqlexec(mcon1,"select REG_nrohclinica FROM registracio "+;
	" where REG_nroregistrac = ?mrecien  " ,"mwkcontrol" )

If reccount('mwkcontrol')>0
	mret = sqlexec(mcon1,"delete from TabLGPrereg where id = ?mrecien ")

	mret = sqlexec(mcon1, "insert into TabLGPrereg (TLP_afiliado, TLP_coddocu, TLP_codent, TLP_codloca, " + ;
		"TLP_codpcia, TLP_codpostal, TLP_direccion, TLP_fechaalta, TLP_fechahora, TLP_fechanac, " + ;
		"TLP_nombre, TLP_nrodocumento, TLP_telefono, TLP_usuario, TLP_sexo) " + ;
		"values(?mnroafi, ?mcoddocu, ?mcodent, ?mloca, ?mpcia, ?mcodpos, " + ;
		"?mdomici, ?mfecha, ?mdatet, ?mfecnac, ?mnomb, ?mnrodoc, ?mtel, " + ;
		"?midusu, ?msexo)")

*!*		mret = sqlexec(mcon1,"select  '0000000000' as REG_nrohclinica, nombre as REG_nombrepac, direccion as REG_domicilio, " + ;
*!*			"entidades.ENT_descrient, nrodocumento as REG_numdocumento, " + ;
*!*			"fechaalta as REG_fecaltapadron, fechabaja as AFI_fechabaja, fechanac as REG_fecnacimiento, " + ;
*!*			"fechabaja as REG_fecbajapadron, " + ;
*!*			"ENT_fecpas, ENT_turnoshabilit, entidades.ENT_codent, preregistra.id as REG_nroregistrac, " + ;
*!*			"codpostal as REG_cpostal, tabpcia.descrip as REG_provincia, telefono as REG_telefonos, " + ;
*!*			"coddocu as REG_tipodocumento, tabloca.descrip as REG_localidad, " + ;
*!*			"afiliado as AFI_nroafiliado, sexo as REG_sexo " + ;
*!*			"from preregistra, entidades, tabpcia, tabloca " + ;
*!*			"where preregistra.codloca = tabloca.id and " + ;
*!*			"preregistra.codpcia = tabpcia.id and " + ;
*!*			"preregistra.codent  = entidades.ENT_codent and " + ;
*!*			"preregistra.nrodocumento = ?mnrodoc " + ;
*!*			"ORDER BY REG_nombrepac", "mwkbuspacie")

	mret = sqlexec(mcon1,"select  '0000000000' as REG_nrohclinica, TLP_nombre as REG_nombrepac, TLP_direccion as REG_domicilio, " + ;
		"entidades.ENT_descrient, TLP_nrodocumento as REG_numdocumento, " + ;
		"TLP_fechaalta as REG_fecaltapadron, TLP_fechabaja as AFI_fechabaja, TLP_fechanac as REG_fecnacimiento, " + ;
		"TLP_fechabaja as REG_fecbajapadron, " + ;
		"ENT_fecpas, ENT_turnoshabilit, entidades.ENT_codent, TabLGPrereg.id as REG_nroregistrac, " + ;
		"TLP_codpostal as REG_cpostal, tabpcia.descrip as REG_provincia, TLP_telefono as REG_telefonos, " + ;
		"TLP_coddocu as REG_tipodocumento,tabloca.descrip as REG_localidad, " + ;
		"TLP_afiliado as AFI_nroafiliado, TLP_sexo as REG_sexo " + ;
		"from TabLGPrereg, entidades, tabpcia, tabloca " + ;
		"where TabLGPrereg.TLP_codloca = tabloca.id and " + ;
		"TabLGPrereg.TLP_codpcia = tabpcia.id and " + ;
		"TabLGPrereg.TLP_codent  = entidades.ENT_codent and " + ;
		"TabLGPrereg.TLP_nrodocumento = ?mnrodoc " + ;
		"ORDER BY REG_nombrepac", "mwkbuspacie")

Endif

If used("mwkcontrol" )
	Use in mwkcontrol
Endif

If used('mwkplegales')
	Use in mwkplegales
Endif

Select mwkbuspacie
*msql = 'select *, 1 as preacre from mwkbuspacie into cursor mwkbuspacie1'
select *, 1 as preacre from mwkbuspacie into cursor mwkplegales

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0
	Do prg_cancelo
Endif
