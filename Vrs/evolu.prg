select proto
scan
	requery('guaevolp')
	if used("evoluto")
		select * from evoluto union all select * from guaevolp  into cursor evoluto
	else
		select * from guaevolp into cursor evoluto
	endif	 
endscan
