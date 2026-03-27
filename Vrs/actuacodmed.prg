set step on
select tabinthces
do while !eof()
	mid = id 
	
	requery('hceevolm')
	if reccount('hceevolm')>0
		if tabinthces.ih_fechahoraing<date()
			select hceevolm
			go top
			mimed = eim_codmed
			select tabinthces
			do while !eof() and mid = id
				skip 1 in tabinthces
			enddo
			requery('hcecodmed')
			if reccount('hcecodmed')>0
				update hcecodmed set ih_codmed = mimed
			endif
		else
			do while !eof() and mid = id
				skip 1 in tabinthces
			enddo
		endif
	endif
	select tabinthces
enddo
