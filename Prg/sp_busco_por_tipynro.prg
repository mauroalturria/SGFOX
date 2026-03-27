****
* BUSCA PACIENTES
****
Parameter mbusco1
Do sp_busco_estados With 57,' and Tipo = 3 ','mwkbloqueaplan'
mcpoplan = ''
If mwkbloqueaplan.estado = 0
	mcpoplan = ',AFI_idplan '
ENDIF

mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, "+;
	"entidades.ENT_descrient, reg_tipodocumento, " + ;
	"REG_numdocumento, REG_fecaltapadron, AFI_fechabaja, " + ;
	"AFI_nroafiliado, REG_fecnacimiento, REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
	"entidades.ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
	" REG_localidad, REG_sexo, REG_telefonos,reg_cuit , " + ;
	"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
	", TPV_Audit , TPV_Observa,reg_email,REG_fechamod  "+mcpoplan +;
	"FROM afiliacion, entidades, registracio left outer join bloqregist on " + ;
	" registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
	" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
	"where &mbusco1 " + ;
	"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
	"afiliacion.AFI_codentidad = entidades.ENT_codent " + ;
	"ORDER BY REG_nombrepac, AFI_fechabaja, ENT_turnoshabilit", "mwkbuscopa")

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
	Do prg_cancelo
Endif

