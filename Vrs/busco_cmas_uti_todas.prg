****
** Estadístico pacientes internados x fecha desde/hasta
*
do sp_conexion
select admisiones
mdesde = ctod("01/03/2013")
mhasta = ctod("23/03/2014")
create cursor camas (admision c(10),paciente c(50),sector c (3),hab c(4),cama c(4),fechaing d,horaing c(5) fechaegre d,horaegr c(5))
select admisiones
scan
	mcodadm = alltrim(admis)
	if !empty(mcodadm )
		mret = sqlexec(mcon1,"select PAC_codadmision as codadm,PAC_nombrepaciente,"+;
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
					mhorades = ttoc(mwklugar1.LUG_horaingreso,2)
					mfhasta = iif(mwklugar1.LUG_fechaegreso <= mhasta, mwklugar1.LUG_fechaegreso, mhasta)
					insert into camas values (mcda,mwkpacint.PAC_nombrepaciente,mwklugar1.LUG_codsector,mwklugar1.LUG_habitacion;
						,mwklugar1.LUG_cama,mfdesde,mhorades ,mfhasta  )
				endscan
				select admisiones
			endif
			select * from mwklugar where LUG_codsector = "TI5" into cursor mwklugar1
			if reccount('mwklugar1')>0
				mveces  =0	
				scan
					mfdesde = iif(mwklugar1.LUG_fechaingreso >= mdesde, mwklugar1.LUG_fechaingreso, mdesde)
					mhorades = ttoc(mwklugar1.LUG_horaingreso,2)
					mfhasta = iif(mwklugar1.LUG_fechaegreso <= mhasta, mwklugar1.LUG_fechaegreso, mhasta)
					insert into camas values (mcda,mwkpacint.PAC_nombrepaciente,mwklugar1.LUG_codsector,mwklugar1.LUG_habitacion;
						,mwklugar1.LUG_cama,mfdesde,mhorades ,mfhasta )
				endscan
				select admisiones
			endif
		endif
	endif
endscan

do sp_desconexion