select pacvip
set step on
scan
	if rat("/201",tpv_observa)>0
		mid = id
		mifecha = ctot(alltrim(left(substr(tpv_observa,rat("/201",tpv_observa)-6,20),30)))
		if mifecha>ctod("01/01/1995")
			wait window transform(mid) nowait
			update vista2 set tpv_fechamod = mifecha  where id = mid and tpv_fechamod < mifecha
			go top in vista2
		endif
	endif
endscan
