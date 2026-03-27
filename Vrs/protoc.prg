select nurse
set step on
scan
	if empty(prest1)
		mipro = protocolo
		select * from guardia_vales where protocolo = mipro ;
		group by pre_descriprest into cursor prestac
		select prestac
		i=1
		do while !eof('prestac') and i <= 3
			mcpo = "prest"+transf(i,"9")
			select nurse
			replace &mcpo with prestac.pre_descriprest
			i=i+1
			select prestac
			skip in prestac
		enddo
	endif
endscan
