*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mfecdes,mFecHas,mopcion

mcFecDes = prg_dtoc(mFecDes )
mcFecHas = prg_dtoc(mFecHas+1 )
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

if mopcion=1
	mret = sqlexec(mcon1,"select hcm_registrac,hcm_fechatur from TabHCMovct "+;
		" where hcm_fechatur >= ?mcFecDes and hcm_fechatur < ?mcFecHas " +;
		" group by hcm_registrac,hcm_fechatur " , "mwkmovhist1" )

	if mret < 0
		=aerr(eros)
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

	endif
	mret = sqlexec(mcon1,"select hcm_registrac,hcm_fechatur from TabHCMovst "+;
		" where hcm_fechatur >= ?mcFecDes and hcm_fechatur < ?mcFecHas " +;
		" group by hcm_registrac,hcm_fechatur " , "mwkmovhist2" )


	select * from mwkmovhist1 ;
		union select * from mwkmovhist2 ;
		into cursor mwkmovhist0

	select *,ttod(hcm_fechatur) as fechatur  from mwkmovhist0  ;
		group by hcm_registrac,fechatur;
		into cursor mwkmovhist

	select fechatur ,count(hcm_registrac) as total from mwkmovhist;
		order by fechatur group by fechatur into cursor mwktotxdia
else
	mret = sqlexec(mcon1, "select * from turnos "+;
		"where tipoturno < 9 and " +;
			" codesp not in("+mfiltraesp +" 'CLIN','DERI','DERM','CARD','CARI','PEDI','CIRG', 'TRAU','NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') and " + ;
			" (not (CODprest like '28010%') or CODprest = 28010602 ) and " + ;
			" not (CODprest like '20012%') and " + ;
			" fechatur = ?mFecDes and " + ;
			" afiliado > 0 " + ;
		"group by fechatur, afiliado, codreserva " , "mwkmovhist1")

	select * from mwkmovhist1  ;
		group by afiliado,fechatur;
		into cursor mwkmovhist

	select fechatur ,count(afiliado) as total from mwkmovhist;
		order by fechatur group by fechatur into cursor mwktotxdia

endif
if used('mwkmovhist1')
	use in mwkmovhist1
endif
if used('mwkmovhist2')
	use in mwkmovhist2
endif
if used('mwkmovhist')
	use in mwkmovhist
endif
if used('mwkmovhist0')
	use in mwkmovhist0
endif