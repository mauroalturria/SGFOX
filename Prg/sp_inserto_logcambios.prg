Lparameters mTLC_Dato, mTLC_FecMod, mTLC_Id, mTLC_Tabla, mTLC_Tipo, mTLC_Usuario, mTLC_ValorAct, mTLC_ValorAnt

*!*	mTLC_Dato = "AnestesiaTipo"    
mTLC_FecMod = sp_busco_fecha_serv("DT")
*!*	mTLC_Id = 5523  
*!*	mTLC_Tabla = "TabQuirof"    
*!*	mTLC_Tipo = ""    
*!*	mTLC_Usuario = mwkUsuario.codigovax  
*!*	mTLC_ValorAct = "1"    
*!*	mTLC_ValorAnt = "2" 
 
*!*	  ID, TLC_Dato, TLC_FecMod, TLC_Id, TLC_Tabla, TLC_Tipo, TLC_Usuario, TLC_ValorAct, TLC_ValorAnt  

mret = Sqlexec(mcon1,"Insert Into TabLogCambios (TLC_Dato, TLC_FecMod, TLC_Id, " + ;
	"TLC_Tabla, TLC_Tipo, TLC_Usuario, TLC_ValorAct, TLC_ValorAnt) " + ;
  	"Values " + ;
  	"(?mTLC_Dato, ?mTLC_FecMod, ?mTLC_Id, " + ;
  	"?mTLC_Tabla, ?mTLC_Tipo, ?mTLC_Usuario, ?mTLC_ValorAct, ?mTLC_ValorAnt  )")
  	
If mret <= 0
	=Aerror(EROS)
*!*		?EROS(3)
	Messagebox("ERROR AL ACTUALIZAR LOS DATOS",48,"VALIDACION")
	Return .F.
Endif 	