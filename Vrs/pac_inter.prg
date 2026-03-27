select beibis
scan 
	for ndia = 1 to iif(beibis.lug_fechaegreso = {  /  /  },date(),beibis.lug_fechaegreso) - beibis.lug_fechaingreso+1
		mdia = beibis.lug_fechaingreso + ndia -1
		ment = 0
		msec = 'NNT'
		select * from intxent where codentidad = ment and sector = msec and dia = mdia into cursor pacientes
		if reccount('pacientes')>0
			npac = pac +1
			update intxent set pac = npac 	where codentidad = ment and sector = msec and dia = mdia 
		else
			insert into intxent (codentidad ,pac,sector,dia ) values ( ment, 1, msec,mdia) 
		endif	
	next 
endscan	