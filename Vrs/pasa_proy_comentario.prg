select ARCHIVO
scan
	if !empty(comments)
		mcomm=comments
		mkey = key
		select b
		locate for key=mkey
		if found()
			replace comments with mcomm
		endif
		select ARCHIVO
	endif	
endscan