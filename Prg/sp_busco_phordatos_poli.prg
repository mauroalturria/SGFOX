***
***  busqueda de los datos para las planillas
***
use in select('mwkpent')
use in select('mwkpesp')
use in select('mwkpmed')
use in select('mwkppres')
use in select("mwkespecag")
use in select("mwkpser")
use in select("mwkentexc")
opcion = 2
if used('mwkexe')
	if mwkexe.nomexe = "PISOS"
		opcion = 1
	endif
endif
if opcion = 1
	mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ent_turnoshabilit, ent_fecpas " + ;
		" from entidades ", "mwkpent")
	if used('mwkmedicoint')
		select * from mwkmedicoint into cursor mwkpMed
	else
		mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " + ;
			"", "mwkpMed" )
	endif
	mret=sqlexec(mcon1,"SELECT PRE_codprest, PRE_descriprest, PRE_especialidad,Pre_retiroestudios,PRE_TipoMuestra "+;
		',PRE_EdadDesde, PRE_EdadHasta,PRE_duracion '+;
		" FROM prestacions  " + ;
		"WHERE pre_fechapasiva is Null  ","Mwkppres")

	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
		" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

	mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
		" WHERE ESP_descripcion is not Null " ,"MWKpesp")

	mret = sqlexec(mcon1,"select ser_codserv, ser_descripserv from servicios ","mwkpser")

	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "select codent, tipoturno,fecpasiva from entidexclu " + ;
		"where id <100000 and fecpasiva = ?mfecpas and tpopac = 'INT' " , "mwkentexc")
else
	mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ent_turnoshabilit, ent_fecpas " + ;
		" from entidades ", "mwkpent")

	mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " + ;
		"WHERE dambula = 1 and id > 1 ", "mwkpMed" )

	mret=sqlexec(mcon1,"SELECT PRE_codprest, PRE_descriprest, PRE_especialidad,PRE_TipoMuestra "+;
		" FROM prestacions  " + ;
		"WHERE PRE_agendaturnos='S' ","Mwkppres")

	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
		" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

	mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
		" WHERE ESP_descripcion is not Null " ,"MWKpesp")

	mret = sqlexec(mcon1,"select ser_codserv, ser_descripserv from servicios ","mwkpser")

	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "select codent, tipoturno,fecpasiva from entidexclu " + ;
		"where id <100000 and fecpasiva = ?mfecpas and tipoturno = 7 and tpopac = 'AMB' " , "mwkentexc")
endif
