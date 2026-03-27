*
* Busco Demandas con un documento
*
lparameters mbuscadoc

mbusca = ctod("01/01/1900")

if vartype(mbuscadoc)<>"N"
  mbuscadoc = 0
endif

mwhere = " and REG_numdocumento=?mbuscadoc"

if used('mwklegalesA')
  use in mwklegalesA
endif  

mret = sqlexec(mcon1,"select TLD_freclamo,TLD_nroregistrac,TLD_idHecho,TAV_idasegura,TLD_idEstado,"+;
	" REG_nombrepac,REG_numdocumento,TLD_actor,TabLGDema.Id as TLG_idema"+;
	" from TabLGDEma,registracio,TabLGAsegv"+;
	" where TLD_nroregistrac=REG_nroregistrac and TLD_nroregistrac>0 and TLD_freclamo >= ?mbusca"+mwhere,"mwklegalesA")
If mret < 0

	=aerror(merror)
	
	Messagebox(merror(3),16,"ERROR")

	Messagebox("EN BUSQUEDA DE DEMANDAS, AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

if used('mwklegalesB')
  use in mwklegalesB
endif  

mwhere = " and TLP_nrodocumento=?mbuscadoc"

mret = sqlexec(mcon1,"select TLD_freclamo,TLD_nroregistrac,TLD_idHecho,TAV_idasegura,TLD_idEstado,"+;
	" TLP_nombre as REG_nombrepac,TLP_nrodocumento as REG_numdocumento,TLD_actor,TabLGDema.Id as TLG_idema"+;
	" from TabLGDEma,TabLGPrereg,TabLGAsegv"+;
	" where TLD_nroregisext=TabLGPrereg.id and TLD_nroregisext>0 and TLD_freclamo >= ?mbusca"+mwhere,"mwklegalesB")
If mret < 0
	Messagebox("EN BUSQUEDA DE DEMANDAS, AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

select * from mwklegalesA union select * from mwklegalesB into cursor mwklegales


