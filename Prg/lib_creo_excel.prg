Procedure Creo_excel 
parameters url_arch_xlt, titulo, Vcursor_dat, Vcursor_nom
oleapp = createobject("excel.application")
		
oleapp.workbooks.open(&url_arch_xlt)
oleapp.cells(3,2).value = Titulo
i = 6
J = 0
	
do while !eof(Vcursor_dat)
	do while !eof(Vcursor_nom)
		j = j + 1
		oleapp.cells(5,j).value   = upper(&Vcursor_nom.TitCamp)
		oleapp.cells(i,j).value   = allt(&Vcursor_dat)+ '.' +allt(&Vcursor_nom.nomcamp)
		
		if !eof(Vcursor_nom)
			skip 1 in &Vcursor_nom
		else
			exit
		endif		
		
	enddo
	i = i + 1
	if !eof(Vcursor_dat)
		skip 1 in &Vcursor_dat
	else
		exit
	endif	
	
enddo

oleapp.visible = .t.	
