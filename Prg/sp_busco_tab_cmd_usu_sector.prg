****
** busco los cmd del usuario en ese  sector
****

parameter nf,mcoduser, mcodsec

	mfecpas = ctod('01/01/1900')
							
	mret = sqlexec(mcon1, "select * from tabpermisosfrmcmd " + ;
							"where codusuario  = ?mcoduser and " + ;
								"codsector = ?mcodsec and " + ;
								"fecpasiva = ?mfecpas " , "mwkcmdx"+nf)
if mret<1
	=aerr(eros)
	messagebox(eros(2))
	
endif						
	
