****
** busco usuarios en tabusuarios
****
lparameters mexe, mbusco, mctrlambito,mcursor
if vartype(mbusco)#"C"
	mbusco = ''
endif
if vartype(mcursor)#"C"
	mcursor = 'mwkusuarios'
endif
if vartype(mctrlambito)#"1"
	mctrlambito= 0
endif
mfecpas = ctod('01/01/1900')
if used(mcursor )
	use in &mcursor 
endif
if type('mexe')#'C'
 	mret = sqlexec(mcon1, 'select * from tabusuario  where fecpasiva = ?mfecpas '+mbusco+;
	' and id<10000000   order by nomape',mcursor )
else
	mret = sqlexec(mcon1, "select tabusuario.* from tabusuario " + ;
		" left join tabpermisosexe on tabpermisosexe.codusuario = tabusuario.id " + ;
		" left join tabexe on tabpermisosexe.codexe = tabexe.id " + ;
		" where tabusuario.fecpasiva = ?mfecpas and tabexe.nomexe=?mexe " + ; 
		" and tabpermisosexe.fecpasiva = ?mfecpas " + mbusco+;
		" and tabusuario.id<10000000 group by tabusuario.id order by nomape ", mcursor )
endif				
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif	