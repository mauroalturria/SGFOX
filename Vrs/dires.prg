narch = adir(adires,"*.*","D")
if narch>0
	otrodir = ascan(adires,"....D")
	if otrodir > 0
			
	else
		lhayalgo = .f.
		for i = 1 to narch
			if at(".DOC",adires(i,1)) > 0
				lhayalgo = .t.
				acopy (adires,adocs)
				exit
			endif
		next 
	endif	
