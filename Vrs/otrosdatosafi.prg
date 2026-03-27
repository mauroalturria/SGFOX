padotrosdatos
SELECT Padotrosdatos.ID, Padotrosdatos.Campo, Padotrosdatos.Contenido,;
  Padotrosdatos.FechaDesde, Padotrosdatos.FechaHasta,;
  Padcabe.NroAfiliado, Padcabe.Documento, Padcabe.ApeyNom;
 FROM SQLUser.PadOtrosDatos Padotrosdatos, SQLUser.PadCabe Padcabe;
 WHERE Padcabe.ID = Padotrosdatos.IdPadCabe;
   AND (Padcabe.NroAfiliado = ?NRODOC;
   AND Padcabe.Entidad = 948)
busco primero por documento y si no lo encuentro por afiliado



select osvra
scan
	if empty(nombre)
		nrodoc= osvra.afi
		requery('padotrosdatos')
		select osvra
		if reccount('padotrosdatos')>0
			midato = padotrosdatos.contenido
			minombre = padotrosdatos.ApeyNom
			miafil	= padotrosdatos.NroAfiliado
			replace nombre with minombre,afil with miafil;
				,fecing with padotrosdatos->FechaDesde;
				,fecegr with padotrosdatos->FechaHasta
*!*			else
*!*				nrodoc= LEFT(nrodoc,LEN(nrodoc)-1)+'0'
*!*				requery('padotrosdatos')
*!*				select osvra
*!*				if reccount('padotrosdatos')>0
*!*					midato = padotrosdatos.contenido
*!*					minombre = padotrosdatos.ApeyNom
*!*					miafil	= padotrosdatos.NroAfiliado
*!*					replace obrasoc with midato,nombre with minombre,afiliado with miafil
*!*				else

*!*				endif

		endif
	endif
endscan
select verpdf
set step on
scan
	minfo = verpdf.id
	requery('informess')
	if reccount('informess')>0
		update informess set informepdfgenerado = .f.
	endif
	select verpdf
endscan
