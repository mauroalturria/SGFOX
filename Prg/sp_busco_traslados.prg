*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mrespsel
	mcFecDes = prg_dtoc(mFecDes ) 
	mcFecHas = prg_dtoc(mFecDes +1 )
	mfechanula = "1900-01-01 00:00:00"

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*, TabHCMovct.* " + ;
	",nombre as hcm_descmed, ESP_descripcion as hcm_descesp " +;
	" from especialid, tabhcmovct  " +;
	"left outer join tabhcarchivo on tabhcmovct.hcm_registrac = tabhcarchivo.hca_registrac "+;
	"left outer join registracio on tabhcarchivo.hca_registrac = registracio.REG_nroregistrac "+;
	"left outer join prestadores on tabhcmovct.hcm_codmed = prestadores.id "+;
	" where hca_estado >= 3 and trim(hcm_codesp) = trim(ESP_codesp) " + ;
	" and hcm_fechaIngr = ?mfechanula and hcm_fechatur >= ?mcFecDes " + ;
	" and hcm_fechatur < ?mcFecHas order by hca_registrac " , "mwkmovhist11" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif

select *,'C/T' as tipo from mwkmovhist11 ;
	where !isnull(hcm_registrac)  ;
	into cursor mwkmovhist01

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*,TabHCMovst.* "+;
	"from TabHCMovst " +;
	"left outer join tabhcarchivo on tabhcarchivo.hca_registrac = tabhcmovst.hcm_registrac "+;
	"left outer join registracio on tabhcarchivo.hca_registrac = registracio.REG_nroregistrac "+;
	" where hca_estado >= 3 and hcm_fechaIngr = ?mfechanula " + ;
	"and hcm_fechatur >= ?mcFecDes and hcm_fechatur < ?mcFecHas " , "mwkmovhist22" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
select *,'S/T' as tipo from mwkmovhist22 ;
	where !isnull(hcm_registrac)  ;
	into cursor mwkmovhist02


select hcm_fechatur, REG_nombrepac,REG_nrohclinica, hcm_descmed;
	, tipo, hcm_descesp  from mwkmovhist01 ;
	union ;
	select hcm_fechatur, REG_nombrepac,REG_nrohclinica, hcm_descmed;
	, tipo, hcm_descesp from mwkmovhist02 ;
	into cursor mwkmovhist1

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

&& genero los traslados

select distinc REG_nrohclinica,hcm_descmed ;
	from mwkmovhist1;
	into cursor mwkturnospac

select REG_nrohclinica,count(REG_nrohclinica) as canttur;
	from mwkturnospac;
	group by REG_nrohclinica order by REG_nrohclinica;
	into cursor mwkcantur

if used('mwkturnospac')
	use in mwkturnospac
endif

select * from mwkmovhist1 ;
	where mwkmovhist1.REG_nrohclinica in ;
	( select REG_nrohclinica from mwkcantur ;
	where canttur >1 and mwkcantur.REG_nrohclinica = mwkmovhist1.REG_nrohclinica  ) ;
	order by REG_nrohclinica,hcm_fechatur into cursor mwktrasla

if used('mwkcantur')
	use in mwkcantur
endif

if used('mwkmovhist1')
	use in mwkmovhist1
endif



create cursor traslado (hcm_fechatur t, hcm_fechaturd t;
	, REG_nombrepac c(40), REG_nrohclinica c(10);
	, hcm_descMed c(40), tipo c (3), hcm_descEsp c(30);
	, hcm_descmedd c(40), tipod c (3), hcm_descespd c(30))
select mwktrasla 
mhorao 	= hcm_fechatur
mmedo	= hcm_descmed
mespo 	= hcm_descesp
mnrohc	= REG_nrohclinica
mpac 	= REG_nombrepac
mtipoo 	= tipo 
if !eof()
	skip 
endif	
do while !eof()
	if mnrohc	= REG_nrohclinica
		mhorad 	= hcm_fechatur
		mmedd	= hcm_descmed
		mespd 	= hcm_descesp
		mtipod 	= tipo 
		insert into traslado (hcm_fechatur, hcm_fechaturd, REG_nombrepac, REG_nrohclinica;
			, hcm_descmed, tipo, hcm_descesp;
			, hcm_descmedd, tipod, hcm_descespd) values ;
			( mhorao, mhorad, mpac, mnrohc, mmedo, mtipoo,mespo, mmedd, mtipod, mespd )
		mhorao 	= mhorad 	
		mmedo	= mmedd	
		mespo 	= mespd 	
		mtipoo 	= mtipod 	
		skip
		loop
	else
		mhorao 	= hcm_fechatur
		mmedo	= hcm_descmed
		mespo 	= hcm_descesp
		mnrohc	= REG_nrohclinica
		mpac 	= REG_nombrepac
		mtipoo 	= tipo 
		skip 
		loop
	endif
enddo
select * from traslado where &mrespsel ;
order by hcm_fechatur into cursor mwktraslados