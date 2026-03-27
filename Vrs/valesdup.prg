select ver
scan
	Scatter MEMVAR
	requery('vales_prestac')
	if reccount('vales_prestac')>1
		if used('valesdup')
			select * from vales_prestac union all select * from valesdup into cursor cosa
			select * from cosa into cursor valesdup
		else
			select * from vales_prestac into cursor valesdup
		endif
	endif
	select ver

endscan
