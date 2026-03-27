
lparameters midGrup,midUsu


*********************************************************************************
* BUSCA Datos x grupos x usuario o tabla entera TabGcusugrup 
*********************************************************************************

SqlCmd = IIF(EMPTY(midGrup)and EMPTY(midUsu) ,"",IIF(EMPTY(midUsu)and !EMPTY(midGrup), "IdGrupo = ?midGrup and " , +;
 	     IIF(!EMPTY(midUsu)and EMPTY(midGrup),"IdUsuario = ?midUsu and",+;
	     " IdGrupo = ?midGrup  and idUsuario = ?midUsu and ")))
	     
mfecpas = ctod('01/01/1900')     

if mcual = 0	    
	mret = sqlexec(mcon1,"select * from TabGcusugrup "+;
				   " inner join tabusuario on tabusuario.id = TabGcUsuGrup.IdUsuario "+;
					"where fecpasiva = ?mfecpas " + SqlCmd  ,"mwkGrupo" )
ELSE
	mret = sqlexec(mcon1,"select * from TabGcusugrup "+;
				   " inner join tabusuario on tabusuario.id = TabGcUsuGrup.IdUsuario "+;
					"where fecpasiva <> ?mfecpas " + SqlCmd  ,"mwkGrupo" )
ENDIF 

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF

