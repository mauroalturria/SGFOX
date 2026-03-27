****
** Estadístico pacientes internados x fecha desde/hasta
*
do sp_conexion
select admisiones
mdesde = ctod("01/03/2013")
mhasta = ctod("23/12/2013")
scan
	mcodadm = alltrim(admis)
	if !empty(mcodadm )
		mret = sqlexec(mcon1,"select PAC_codadmision as codadm,"+;
			"PAC_motivoalta,PAC_fechaalta,PAC_fechaadmision"+;
			" from pacientes "+;
			" where PAC_codadmision = ?mcodadm " ,"mwkpacint")
		if mret < 0
			messagebox("EN CONSULTA DE PACIENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			return
		endif
		if mcodadm = '374753-3'
		set step on
		endif
*
		select mwkpacint
		if used('mwklugar')
			use in mwklugar
		endif
		mcda = mwkpacint.codadm
		mfalta = nvl(mwkpacint.PAC_fechaalta,date())
		mfingr = mwkpacint.PAC_fechaadmision
		mobito = (nvl(mwkpacint.PAC_motivoalta,1) = 6)
		mret = sqlexec(mcon1,"select * from LUGARINTERN where LUG_pacientes = ?mcda","mwklugar")
		if reccount('mwklugar')>0
			select * from mwklugar where LUG_codsector = "UC6" into cursor mwklugar1
			if reccount('mwklugar1')>0
				mveces  =0	
				scan
					mfdesde = iif(mwklugar1.LUG_fechaingreso >= mdesde, mwklugar1.LUG_fechaingreso, mdesde)
					mfhasta = iif(mwklugar1.LUG_fechaegreso <= mhasta, mwklugar1.LUG_fechaegreso, mhasta)
					mveces  = mveces  + mfhasta - mfdesde + 1
				endscan
				select admisiones
				replace uco with mveces
			endif
			select * from mwklugar where LUG_codsector = "TI5" into cursor mwklugar1
			if reccount('mwklugar1')>0
				mveces  =0	
				scan
					mfdesde = iif(mwklugar1.LUG_fechaingreso >= mdesde, mwklugar1.LUG_fechaingreso, mdesde)
					mfhasta = iif(mwklugar1.LUG_fechaegreso <= mhasta, mwklugar1.LUG_fechaegreso, mhasta)
					mveces  = mveces  + mfhasta - mfdesde + 1
				endscan
				select admisiones
				replace uti  with mveces
			endif
		endif
	endif
endscan

do sp_desconexion