select franja
set step on
scan
	if id <13261
		mid = franja.id
		scatter to datos
		select franja350
		locate for id=mid
		GATHER FROM datos
	endif
endscan	