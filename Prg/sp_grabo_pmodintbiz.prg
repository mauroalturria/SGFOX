****
** Grabo Modulos Integrales
****
*!*		do sp_grabo_pmodint with .mabm,.mid, .Txtmod.value,;
*!*			.TxeDetalle.value, .TxtValor.value, .TxeObserva.value
lparameters cCodigom,mCodigo,InclExclm,Ordenm,mabm,bandera,mvalor
if mabm = 1 OR mabm = 4
	mid=0
endif
mfechacarga = sp_busco_fecha_srv2('DT')
	
*if !empty(mmodulo)


	do case
		case mabm = 1  OR mabm = 4 		&& Alta
		mret = sqlexec(mcon1, "select MAX(id) as maximo from tabpmodulo","Maximo")
		cCodigom = maximo
		     IF bandera
				mret = sqlexec(mcon1, "insert into tabprconce (cCodigo,CodConce,InclExcl,Orden)"+;
					" values(?cCodigom,?mCodigo,?InclExclm,?Ordenm)")
			 ELSE
			    mret = sqlexec(mcon1, "insert into tabprprest( pcodigo,codprest,orden,pvalor)"+;
					" values(?cCodigom,?mCodigo,?Ordenm,?mvalor)")
			 ENDIF 		
					
			IF mret < 0
			    MESSAGEBOX("LOS DATOS NO FUERON ACTUALIZADOS CORRECTAMENTE, COMUNIQUESE CON SISTEMAS",48,"CUIDADO")
			ENDIF 
		case mabm = 2

			 IF bandera
				mret = sqlexec(mcon1, "insert into tabprconce (cCodigo,CodConce,InclExcl,Orden)"+;
					" values(?cCodigom,?mCodigo,?InclExclm,?Ordenm)")
			 ELSE
			    mret = sqlexec(mcon1, "insert into tabprprest( pcodigo,codprest,orden,pvalor)"+;
					" values(?cCodigom,?mCodigo,?Ordenm,?mvalor)")
			 ENDIF 	

		case mabm = 3
			mret = sqlexec(mcon1, "delete from TabPModulo where id=?mid ")
	endcase
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif

*endif