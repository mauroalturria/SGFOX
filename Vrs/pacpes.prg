use pes in 0 exclusive alias hclipes
select hclipes
set step on
go top
scan
	mihc = hclipes.hclin
	requery('registel')
	select hclipes
	mipac = registel.REG_nombrepac
	mitel = registel.REG_telefonos
	wait windows transform(recno()) nowait
	if reccount('registel')> 0
		select registel
		scan
			mccad = ''
			if !isnull(registel.TRT_tipo) and !empty(nvl(registel.TRT_Numero,'')) and nvl(registel.TRT_Pasiva,ctod("01/12/2100")) = ctod("01/01/1900")
				mccad = mccad + chr(9)+;
					iif(registel.TRT_tipo=1,"PART1",iif(registel.TRT_tipo=2,"PART2",iif(registel.TRT_tipo=3,"LABORAL",iif(registel.TRT_tipo=4,"CELULAR",;
					iif(registel.TRT_tipo=5,"MENSAJES", "PART1") ) ) ) )+  "::" + alltrim(registel.TRT_Numero)
			endif
		endscan
		select hclipes
		replace nombre with mipac, telefono  with mitel,telefono2 with mccad ;

	endif
		mhcli = hclipes.hclin
		requery('afiliados')
		select afiliados
		i=1
		scan
			mient = afiliados.afi_codentidad
			mcampo = "codentaf" + transf(i,"9")
			select hclipes
			replace &mcampo with mient
			i = i +1
		
			select afiliados
		endscan

	select hclipes
endscan
copy to pacpes type xl5

select hclipes
set step on
go top
scan
	wait windows transform(recno()) nowait
endscan
use in hclipes

*!*	use in hclipes
*!*	select hclipes
*!*	set step on
*!*	go top
*!*	scan
*!*		wait windows transform(recno()) nowait
*!*		mihc = hclipes.hclin
*!*		requery('regishc')
*!*		mipac = regishc.REG_nroregistrac
*!*		if reccount('regishc')> 0
*!*			for i= 2 to 5
*!*				insert into vista3 (TRAM_codesp,TRAM_fechapasiva,TRAM_registracio,TRAM_tipo);
*!*					values ('',ctod("01/01/1900"),mipac,i)
*!*			next
*!*		endif
*!*		select hclipes
*!*	endscan
*!*	use in hclipes
