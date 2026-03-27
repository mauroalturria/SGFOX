********
*		Busco altacomplejidad en Maria
********
parameters xmpresta,mcursor
if vartype(mcursor)#"C"
	mcursor = "mwkcritAC"
endif
mret = sqlexec(mcon1, "SELECT ID , PRE_codprest , IDcomplejidadBP , IDcomplejidadSG , ENT_codagrup , Observ "+;
 				 	"  FROM MDB.TabComplejidadBP WHERE   pre_codprest = ?xmpresta and  Fec_pasiva ='1900-01-01'",mcursor)

if mret<1
	=aerr(eros)
	messagebox(eros(3))

endif
