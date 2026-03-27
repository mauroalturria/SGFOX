select tabreservados
scan
	mdiasem = diasem
	mcodmed = codmed
	mhoradesde = val(strtran(left(ttoc(horadesde,2),5),":",""))
	mhorahasta = val(strtran(left(ttoc(horahasta,2),5),":",""))
	requery('franja')
	select franja
	if reccount('franja')>0
		mifecha = franja.Fecvigenh
		if franja.Fecvigenh<date()
			select tabreservados 
			replace Fecvigenh with mifecha
		endif	
	endif
endscan
