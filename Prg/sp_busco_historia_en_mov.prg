*********************************************************************************
* BUSCA historias en rotacion                                                    *
*!*	mfectur = ctod("11/10/2006")
*!*	mFecDes = ctod("14/02/2006")
*!*	mFecHas = ctod("14/03/2006")
*!*	mbuscar = ""
*********************************************************************************
lparameters mbuscar, mfectur

mcFecDes = prg_dtoc(mFecDes )
mcFecHas = prg_dtoc(mFecHas+1)
mfechanula = "1900-01-01 00:00:00"
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*, TabHCMovct.* " + ;
	",nombre as hcm_descMed, ESP_descripcion as hcm_descEsp, registracio.REG_nroregistrac " +;
	" from TabHCMovct,TabHCArchivo, prestadores, registracio ,TabHCUbica ,especialid " +;
	"where hcm_registrac = hca_registrac and "+;
	"hca_registrac = REG_nroregistrac and codubi = hca_motfalta  and "+;
	"hcm_codmed = prestadores.id and "+;
	" trim(hcm_codesp) = trim(ESP_codesp) " + ;
	" and hcm_fechatur >= ?mcFecDes " +;
	" and hcm_fechatur < ?mcFecHas " +;
	" and hcm_fechaIngr = ?mfechanula " +;
	"  " , "mwkmovhist11" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif

select *,'C/T' as tipo,space(50) as hcm_retira;
	, iif(hcm_origen=0,"ARCH","CONS") as desde ;
	from mwkmovhist11 where !isnull(hcm_registrac) &mbuscar ;
	order by hca_registrac into cursor mwkmovhist01

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*,TabHCMovst.* "+;
	" from TabHCMovst " +;
	"left outer join TabHCArchivo on TabHCArchivo.hca_registrac = TabHCMovst.hcm_registrac "+;
	"left outer join registracio on TabHCArchivo.hca_registrac = registracio.REG_nroregistrac "+;
	" where hcm_fechatur >= ?mcFecDes " +;
	" and hcm_fechatur < ?mcFecHas " +;
	" and hcm_fechaIngr = ?mfechanula " , "mwkmovhist22" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
select *,'S/T' as tipo, iif(hcm_origen=0,"ARCH","CONS") as desde ;
	from mwkmovhist22 where !isnull(hcm_registrac) &mbuscar ;
	order by hca_registrac into cursor mwkmovhist02
mbus = iif(mfectur <> ctod("01/01/1900"), " (hca_estado = 4 or hca_motfalta = 8) ", " hca_estado = 4 ")

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.* " + ;
	", registracio.REG_nroregistrac " +;
	" from TabHCArchivo, registracio ,TabHCUbica " +;
	"where hca_registrac = REG_nroregistrac and codubi = hca_motfalta  "+;
	" and " + mbus  , "mwkmovhist00" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif


select REG_nombrepac,REG_nrohclinica, hcm_fechatur, hcm_origen,hcm_descMed;
	, Tipo, hcm_descEsp, hcm_retira,desde, hca_registrac from mwkmovhist01 ;
	union ;
	select REG_nombrepac,REG_nrohclinica, hcm_fechatur, hcm_origen,hcm_descMed;
	, Tipo, padr(mwkmovhist02.hcm_descEsp,40) as hcm_descEsp, hcm_retira,desde, hca_registrac from mwkmovhist02 ;
	union ;
	select REG_nombrepac,REG_nrohclinica, ctot("01/01/1900") as hcm_fechatur, ;
	9 as hcm_origen,space(40) as hcm_descMed,iif(hca_motfalta= 8 ,'HCT','FAL') as  Tipo, ;
	space(40) as hcm_descEsp, space(50) as hcm_retira,iif(hca_motfalta= 8 ,'HCT','FAL') as desde;
	, hca_registrac from mwkmovhist00 ;
	into cursor mwkmovhist1

&& Busco los turnos

If mfectur <> ctod("01/01/1900")

	mret = SqlExec(mcon1, "Select Afiliado,codesp,CODprest "+;
		" from Turnos Where codserv <> 1130 and fechatur = ?mfectur and afiliado >1 ", "mwkturafi" )

	If mret <= 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
		Return .f.
	Endif 

	select afiliado from mwkturafi;
	where  codesp not in (&mfiltraesp 'CLIN','DERI','DERM','CARD','CARI','PEDI','CIRG', 'TRAU','KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOO', 'ECOC', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') ;
	and (at('28010', alltrim(str(CODprest))) # 1 or CODprest = 28010602);
	and at('20012', alltrim(str(CODprest)) )# 1 and !inlist(CODprest,78010600,78010601,67010201,22020300);
	group by afiliado into cursor mwktur
	
	
	select mwkmovhist1.* ;
		from mwkmovhist1, mwktur;
		where mwkmovhist1.hca_registrac = mwktur.Afiliado ;
		into cursor mwkmovhist1
		
	Use in mwktur	

Endif

*!*	if reccount('mwkmovhist02')>0 and reccount('mwkmovhist01')>0
*!*	else
*!*		mname = iif( reccount('mwkmovhist02')>0 ,'mwkmovhist02','mwkmovhist01')
*!*		select * from &mname into cursor mwkmovhist1
*!*	endif

if used('mwkmovhist01')
	use in mwkmovhist01
endif
if used('mwkmovhist02')
	use in mwkmovhist02
endif
if used('mwkmovhist11')
	use in mwkmovhist11
endif
if used('mwkmovhist22')
	use in mwkmovhist22
endif
