*!*	Acualizacion de Estado de las derivaciones a otros centros
*!*	==========================================================		
Lparameters mId, mEstado, mFechaI 

mfhingr = sp_busco_fecha_serv("DT")		

mRet = SQLExec(mcon1, "Update TabDerivaSal Set Estado = ?mEstado " + ;
			",fechahoraingreso = ?mfhingr " + ;
			"Where id = ?mId")
			
If mRet < 0 
	MessageBox("ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS",16, "Validacion") 
EndIf		
 
mesta = 200 + mestado
midusu = mwkusuario.idusuario
mobserv = "Cancelación"
mret = sqlexec(mcon1,"insert into TabDerivaObs "+;
	"(TDO_idderiva,TDO_idusuario,TDO_fechamov,TDO_categoria,TDO_Observ) "+;
	"values (?mid,?midusu ,?mfhingr,?mesta,?mobserv)")
If mRet < 0 
	MessageBox("ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS",16, "Validacion") 
EndIf		