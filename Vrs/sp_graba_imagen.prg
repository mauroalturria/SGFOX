DO sp_conexion
DO Sp_BuscoPuesto_ST
SELECT mwkPuesto
SCAN 
  IF !ISNULL(imagen)
       IF !EMPTY(imagen)
		    parchi = imagen
		    mid = id
			mopen =FOPEN(parchi,0)
			FSEEK(mopen ,0,0)
			mMovPuntero = FSEEK(mopen ,0,2)
			FSEEK(mopen ,0,0)
			d=fread(mopen ,mMovPuntero )
			mimagen =STRCONV(d,15)
			FCLOSE(mopen )
					mret =	sqlexec(mcon1,"update tabStPuesto set imagen2 = ?mimagen "+;
									  "  where id = ?mid ")
	  ENDIF							  
  ENDIF 	  
ENDSCAN 
DO sp_desconexion