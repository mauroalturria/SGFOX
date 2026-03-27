************
*** Busco historias en rotacion sin  turno
********
mFecDes  =  sp_busco_fecha_serv('DD')
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

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*,TabHCMovst.*,hcm_retira as retira ,hcm_fechaSal, " +;
	" hcm_descEsp,hcm_descMed,REG_numdocumento from TabHCMovst " +;
	"left outer join TabHCArchivo on TabHCArchivo.hca_registrac = TabHCMovst.hcm_registrac "+;
	"left outer join registracio on TabHCArchivo.hca_registrac = registracio.REG_nroregistrac "+;
	" where hcm_fechaIngr = ?mfechanula and hcm_fechatur <?mFecDes " +;
	" and hcm_fechatur >=?mfectur_ant " , "mwkmovhist22" )


if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
select *,'S/T' as tipo, iif(hcm_origen=0,"ARCH","CONS") as desde,left(right(alltrim(reg_nrohclinica), 4), 2) as termina ;
	,left(right(alltrim(reg_nrohclinica), 5), 1) as termina2 ;
	from mwkmovhist22 where !isnull(hcm_registrac) and !isnull(REG_nrohclinica) ;
	order by termina,termina2  into cursor mwkmovhist02

if used('mwkmovhist22')
	use in mwkmovhist22
endif
