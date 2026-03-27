select tabinthces
scan
	mid = tabinthces.id
	requery('tabintevol')
	go top in tabintevol
	mimed = tabintevol.eim_codmed
	select tabinthces
	replace ih_codmed with mimed
endscan
