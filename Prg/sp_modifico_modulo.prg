PARAMETERS cCodigom,mCodigo,Idm,InclExclm,Ordenm,mabm,bandera,mvalor


mfechacarga = sp_busco_fecha_srv2('DT')
			  	mret = sqlexec(mcon1, "update tabprprest set FECHAUA =?mfechacarga , CODPREST = ?mCodigo,PCODIGO =?cCodigom,PVALOR =?mvalor,ORDEN =0"+;
					" where id=?idm")
					
					 
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("NO SE PUDO ACTUALIZAR CORRECTAMENTE, COMUNIQUECE CON SITEMAS", 48, "Validacion")
endif