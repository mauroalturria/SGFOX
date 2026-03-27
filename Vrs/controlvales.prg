*!*	create cursor valeshce (nrovale n(12),fechora t)
*!*	append from c:\desaguemes\valesima.txt delimited with tab 
set step on
select valeshce
scan
	mivale=nrovale
	requery('estudiosol')
	select valeshce
	if reccount('estudiosol')>0
		replace fechora with estudiosol->ep_fechoralta
	endif	
endscan