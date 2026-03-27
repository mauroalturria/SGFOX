****
** Estadístico pacientes internados x fecha desde/hasta
****
select * from ciamaud where left(entidad,8)='OSUTHGRA' and (fecha_egr=ctod("  /  /  ") or fecha_egr>=ctod("01/01/2011"))  order by fecha into cursor ciamaudita1

if used('mwkpacint2')
	use in mwkpacint2
endif
create cursor mwkpacint2 (lfecha d, lclinica c(30),lentidad c(50), ldias n(10),tipointer c(30))
*
select ciamaudita1
scan
	mfdesde = fecha
	mfhasta = iif(fecha_egr=fecha,fecha+1,iif(fecha_egr=ctod("  /  /  "),date()+1,fecha_egr))
	mclin = clinica	 
	ment = entidad
	mtipo = sec_descri
	mveces  = mfhasta - mfdesde 
	for mndia = 1 to mveces
		mdia = mfdesde + mndia - 1
		select * from mwkpacint2 where lfecha = mdia and lentidad = ment;
		and tipointer = mtipo into cursor ciamaudita13
		if reccount('ciamaudita13')=0
			insert into mwkpacint2 (lfecha, lentidad, ldias,tipointer,lclinica) values;
				(mdia,ment,1,mtipo,mclin)
		else
			mdias = ciamaudita13.ldias+1
			update mwkpacint2 set ldias = mdias;
				where lfecha = mdia and lentidad = ment;
			and tipointer = mtipo
		endif
	endfor
endscan
