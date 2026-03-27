select diascama
scan
	nrodoc= diascama.documento
	requery('padotrosdatos')
	select diascama
	if reccount('padotrosdatos')>0
		midato = padotrosdatos.contenido
		minombre = padotrosdatos.ApeyNom
		miafil	= padotrosdatos.NroAfiliado
		replace obrasoc with midato,nombre with minombre,afiliado with miafil
	endif
endscan
