*
* BUSCA PACIENTES EXTERNOS DE LEGALES
*
Parameter mnrodoc, mnroid

if mnrodoc > 0
  mwhere = "TLP_nrodocumento = ?mnrodoc and " + ;
	"TLP_nroregistracio is null"
else
  mwhere = "TabLGPrereg.id = ?mnroid"
endif	

mret = sqlexec(mcon1,"select *,ENT_descrient,TabLGPrereg.id as lidregis,TLP_codent as ent_codent from TabLGPrereg,entidades where TLP_codent=entidades.ENT_codent and "+mwhere , "mwkencontrado")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
else
	if mnroid > 0
	 msql = "select TLP_nombre as REG_nombrepac, TLP_nrodocumento as REG_numdocumento, TLP_fechaalta as REG_fecaltapadron,"+;
    "TLP_fechabaja as AFI_fechabaja, TLP_fechanac as REG_fecnacimiento,TLP_fechabaja as REG_fecbajapadron,"+;
    "ENT_descrient,TLP_codpostal as REG_cpostal,TLP_telefono as REG_telefonos," +;
	"TLP_coddocu as REG_tipodocumento,"+;
	"TLP_afiliado as AFI_nroafiliado,TLP_sexo as REG_sexo,lidregis as REG_nroregistrac,ENT_codent "+;
	"from mwkencontrado into cursor mwkbuspacie1"

*	tabloca.descrip as REG_localidad,
*   tabpcia.descrip as REG_provincia, 
	
	&msql		
	endif
Endif

