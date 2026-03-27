PARAMETERS mhcmnrohCli
mret = sqlexec(mcon1,"SELECT REG_NOMBREPAC,reg_nrohclinica,reg_nroregistrac"+;
" FROM registracio where reg_nrohclinica =?mhcmnrohCli ", "mwkDatPac" )
if mret < 0
	messagebox('Error De Cursor <Sector>, avisar a sistemas',16,'Validacion')
	cancel 
	mret=0
	retur 
endif
