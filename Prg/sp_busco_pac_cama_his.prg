****
** Estadístico pacientes internados x fecha desde/hasta
****

parameter mdesde, mhasta

if used('mwkpacint2')
	use in mwkpacint2
endif
create cursor mwkpacint2 (ladmi c(8), lpaciente c(50),lfecha d, lhorai n(4), ;
	lfechae d, lentidad n(6), lsector c(3), lhab c(4),lcama c(2),lcat c(1),lfecalta t)
*
if used('mwkpacint1')
	use in mwkpacint1
endif
mret = sqlexec(mcon1, "select ENT_descrient,ENT_codent  " + ;
	"from entidades " , "mwkpacent")
mret = sqlexec(mcon1,"select PAC_nombrepaciente, PIN_codadmision as codadm,PIN_codentidad as codent"+;
	" ,pac_habitacion,pac_cama "+;
	" from PACINTERNAD 	"+;
	" left join  pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +;
	" order by PIN_codentidad,PIN_codadmision","mwkpacint1")
if mret < 0
	messagebox("EN CONSULTA DE PACIENTES INTERNADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	return
endif
*
if used('mwkpacint0')
	use in mwkpacint0
endif
mret = sqlexec(mcon1,"select PAC_nombrepaciente ,PAC_codadmision as codadm,COB_codentidad as codent"+;
	" ,pac_habitacion,pac_cama ,PAC_motivoalta,PAC_fechaalta,PAC_horaalta,PAC_fechaadmision "+;
	" from pacientes, coberturas "+;
	" where PAC_codadmision = COB_pacientes and"+;
	" PAC_tipopac = 1 and" +;
	" PAC_fechaalta >= ?mdesde and" +;
	" PAC_fechaadmision <= ?mhasta","mwkpacint0")
if mret < 0
	messagebox("EN CONSULTA DE PACIENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	return
endif
*
if used('mwkpacint')
	use in mwkpacint
endif

select *,9  as PAC_motivoalta,date()+1 as PAC_fechaalta,datetime() as PAC_horaalta,date() as PAC_fechaadmision ;
	from mwkpacint1 ;
	union select * from mwkpacint0 ;
	group by codent,codadm into cursor mwkpacint

select mwkpacint
scan
	if used('mwklugar')
		use in mwklugar
	endif
	mcda 	= mwkpacint.codadm
	ment 	= mwkpacint.codent
	mhoraa 	= mwkpacint.PAC_horaalta
	mfalta 	= mwkpacint.PAC_fechaalta
	mpac  	= mwkpacint.PAC_nombrepaciente
	mfingr 	= mwkpacint.PAC_fechaadmision
	mobito 	= (mwkpacint.PAC_motivoalta = 6)
 	mfecalta = iif( PAC_motivoalta = 9,ctot("01/01/1900"), ;
		ctot(dtoc(mfalta )+" "+left(ttoc(mhoraa,2),5)))
	mret = sqlexec(mcon1,"select * from LUGARINTERN where LUG_pacientes = ?mcda","mwklugar")
	if reccount('mwklugar')>0
		select * from mwklugar where LUG_fechaingreso <= mhasta and;
			(LUG_fechaegreso >= mdesde or isnull(LUG_fechaegreso)) ;
			into cursor mwklugar
		select mwklugar
		scan
			mfdesde = iif(mwklugar.LUG_fechaingreso >= mdesde, mwklugar.LUG_fechaingreso, mdesde)
			mfhasta = iif(mwklugar.LUG_fechaegreso <= mhasta, mwklugar.LUG_fechaegreso, mhasta)
			msector = mwklugar.LUG_codsector
			mhora	= val(strtran(left(ttoc(mwklugar.LUG_horaingreso,2),5),":",""))
			mhab 	= nvl(mwklugar.LUG_habitacion,mwkpacint.pac_habitacion)
			mcama 	= nvl(mwklugar.LUG_cama,mwkpacint.pac_cama )
			mcat 	= mwklugar.LUG_categoria
			mveces  = mfhasta - mfdesde + 1
			mfalta = mwkpacint.PAC_fechaalta
			mfingr = mwkpacint.PAC_fechaadmision
			insert into mwkpacint2 (ladmi, lpaciente,lfecha, lhorai, ;
				lfechae, lentidad ,lsector,lhab, lcama,lcat,lfecalta ) ;
				values (mcda,mpac,mfdesde,mhora,mfhasta,ment,msector,mhab,mcama,mcat,mfecalta )
		endscan
	endif
endscan

if used('mwklugar')
	use in mwklugar
endif

if used('mwkpacint')
	use in mwkpacint
endif

if used('mwkpacint0')
	use in mwkpacint0
endif

if used('mwkpacint1')
	use in mwkpacint1
endif

if used('mwkpacint3')
	use in mwkpacint3
endif

return
