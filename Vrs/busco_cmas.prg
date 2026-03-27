****
** Estadístico pacientes internados x fecha desde/hasta
****

if used('mwkpacint2')
	use in mwkpacint2
endif
create cursor mwkpacint2 (ladmi c(8), lfecha d, lsector c(3), ltipo n(1),lhab c(6),lcama c(6))
*
if used('mwkpacint1')
	use in mwkpacint1
endif
if used('mwkpacint0')
	use in mwkpacint0
endif
*do sp_conexion
select camas0710
mdesde = ctod("01/07/2010")
mhasta = ctod("01/08/2010")-1
scan
	mcodadm = alltrim(admision)
	mret = sqlexec(mcon1,"select PAC_codadmision as codadm,"+;
		"PAC_motivoalta,PAC_fechaalta,PAC_fechaadmision"+;
		" from pacientes "+;
		" where PAC_codadmision = ?mcodadm " ,"mwkpacint")
	if mret < 0
		messagebox("EN CONSULTA DE PACIENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		return
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
	if mret > 0
		if used('mwklugar')
			if reccount('mwklugar')>0
				select * from mwklugar where LUG_fechaingreso <= mhasta and;
					(LUG_fechaegreso >= mdesde or isnull(LUG_fechaegreso)) into cursor mwklugar
				select mwklugar
				scan
					mfdesde = iif(mwklugar.LUG_fechaingreso >= mdesde, mwklugar.LUG_fechaingreso, mdesde)
					mfhasta = iif(mwklugar.LUG_fechaegreso <= mhasta, mwklugar.LUG_fechaegreso, mhasta)
					msector = mwklugar.LUG_codsector
					mhab = mwklugar.LUG_habitacion
					mcama = mwklugar.LUG_cama

					mveces  = mfhasta - mfdesde + 1
					for mndia = 1 to mveces
						mdia = mfdesde + mndia - 1
						if used('mwkpacint3')
							use in mwkpacint3
						endif
						mtipo = 2
						insert into mwkpacint2 (ladmi,lfecha,lsector,ltipo,lhab,lcama) values;
							(mcda,mdia,msector,mtipo,mhab,mcama)
					endfor
					mfalta = mwkpacint.PAC_fechaalta
					mfingr = mwkpacint.PAC_fechaadmision
					if  !mobito and mfalta <= mhasta and mfalta # mfingr
						update mwkpacint2 set ltipo=1 ;
							where lfecha = mdia and ladmi = mcda ;
							and lhab = mhab and lsector=msector and lcama = mcama
					endif
				endscan
			endif
		endif
	else
		messagebox("EN CONSULTA DE LUGAR INTERNACION"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		return
	endif
endscan
if used('mwkpacint3')
	use in mwkpacint3
endif
select mwkpacint2
select *,sum(iif(ltipo=2,1,0)) as cantf from mwkpacint2 ;
	group by ladmi,lsector,lfecha,lhab,lcama;
 	order by lfecha into cursor mwkpacint3
 	
*!*	select *,sum(cantf) as cuantos , count(*) as cantu from mwkpacint3 ;
*!*		group by lsector,lfecha,lhab,lcama;
*!*	 	order by lfecha into cursor mwkpacint4

copy to jul10 type xl5

