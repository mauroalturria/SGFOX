*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mbuscar

mfechanula = ctod("01/01/1900")
idinic = 58000
idifin = 59000

do while idinic<141600
	mret = sqlexec(mcon3,"select TabHCArchivo.* " + ;
		" FROM TabHCArchivo " + ;
		" where id>=?idinic and id<?idifin " , "mwkhistoria" )
	select mwkhistoria
	scan
		if ttod(hca_fechainic) = mfechanula
			mnroreg = hca_registrac
			hayalgo = .f.
			mid = id
			mfechast = ctot("01/01/2100")
			mfechact = ctot("01/01/2100")
			mret = sqlexec(mcon3,"select hcm_fechatur " + ;
				" from TabHCHiscT " +;
				" where hcm_registrac = ?mnroreg "+;
				" order by hcm_fechatur " , "mwkmov" )
			if mret < 0
				=aerr(eros)
				messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			endif
			if reccount ('mwkmov')>0
				mfecha = hcm_fechatur
				hayalgo = .t.
			else
				mret = sqlexec(mcon3,"select hcm_fechatur " + ;
					" from TabHCMovct " +;
					" where hcm_registrac = ?mnroreg "+;
					" order by hcm_fechatur " , "mwkmov" )

				if reccount ('mwkmov')>0
					mfechact = hcm_fechatur
					hayalgo = .t.
				endif
				mret = sqlexec(mcon3,"select hcm_fechatur " + ;
					" from TabHCMovst " +;
					" where hcm_registrac = ?mnroreg "+;
					" order by hcm_fechatur " , "mwkmov" )

				if reccount ('mwkmov')>0
					mfechast = hcm_fechatur
					hayalgo = .t.
				endif
				if hayalgo
					mfecha = iif(mfechast< mfechact , mfechast ,mfechact )
				endif
			endif
			if hayalgo
				mret = sqlexec(mcon3,"Update TabHCArchivo set hca_fechainic= ?mfecha " + ;
					" where id= ?mid " )
			endif
		endif
	endscan
	
	idinic = idifin 
	idifin = idifin + 10000
enddo
