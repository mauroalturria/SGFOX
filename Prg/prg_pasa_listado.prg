****
** Pasa dato en cursor mwklista a archivo de texto
****
lparameters mcarch

cfolderwork = justpath(mcarch)
mcpathact = allt(sys(5))+sys(2003)
if !empty(cfolderwork)
	cd alltrim(cfolderwork)
endif
mnarch = fcreate(mcarch)
cd alltrim(mcpathact)
if mnarch > 0
	select mwklista
	scan
		mccad =  dato
		fputs(mnarch, mccad)
	endscan
	fclose(mnarch)
endif

