mifecha = dtos(date())
mcon1= SQLCONNECT('informes','_system','sys')
mret = sqlexec(mcon1, "{call informes_StoreFile(74003,'C:\informes\ecografias\enero\740238.doc',11536205,11536209,"+mifecha+",7000 }", "mwkalgo")
if mret <1 
	=aerr(eros)
	messagebox(eros(3))
endif	
=sqldisconnect(mcon1)

mcon1= SQLCONNECT('informes','_system','sys')
mret = sqlexec(mcon1, "{call informes_GetFile(12845493,'\\P01_desa_carmen\Desa_n\pirulo.doc')}", "mwkalgo")
if mret <1 
	=aerr(eros)
	messagebox(eros(3))
endif	
=sqldisconnect(mcon1)
		
