************
*** Busco historias en rotacion con turno
********
mFecDes  =  sp_busco_fecha_serv('DD')
mcFecDes = prg_dtoc(mFecDes )
mfechanula = "1900-01-01 00:00:00"
** Dia anterior
mfectur_ant = mFecDes- iif( dow(mFecDes) = 2, 3, 1)
do while .t.
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_ant",'MWKFeriados')
	if reccount('MWKFeriados')>0 or inlist(dow(mfectur_ant),7,1)
		mfectur_ant = mfectur_ant -1
	else
		exit
	endif
enddo
if dow(mfectur_ant) = 6
	mfectur_ant = mfectur_ant-1
endif

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*, TabHCMovct.* " + ;
	",nombre as hcm_descMed, ESP_descripcion as hcm_descEsp ,REG_numdocumento,hcm_fechatur" +;
	" from TabHCMovct,TabHCArchivo, prestadores, registracio ,TabHCUbica ,especialid " +;
	"where hcm_registrac = hca_registrac and "+;
	"hca_registrac = REG_nroregistrac and codubi = hca_motfalta  and "+;
	"hcm_codmed = prestadores.id and "+;
	" trim(hcm_codesp) = trim(ESP_codesp) and " + ;
	" hcm_fechatur <?mcFecDes and hcm_fechatur >=?mfectur_ant " + ;
	" and hcm_fechaIngr = ?mfechanula " +;
	"  " , "mwkmovhist11" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif

select *,'C/T' as tipo,space(50) as hcm_retira;
	, iif(hcm_origen=0,"ARCH","CONS") as desde,left(right(alltrim(reg_nrohclinica), 4), 2) as termina ;
	,left(right(alltrim(reg_nrohclinica), 5), 1) as termina2 ;
	from mwkmovhist11 where !isnull(hcm_registrac) and !isnull(REG_nrohclinica) ;
	order by termina,termina2  into cursor mwkmovhist01


if used('mwkmovhist11')
	use in mwkmovhist11
endif
