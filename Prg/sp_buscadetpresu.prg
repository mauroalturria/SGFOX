PARAMETERS mid


mret = SQLEXEC(mcon1," SELECT fechaAutoPres as fecha,descripcion as estado,"+;
	" nomape as Usuario,observaciones,cast(0 as integer ) as UltEstado "+;
	" FROM TabPAUDITORIA "+;
	" left join tabpestado on  tabpestado.id = TabPAUDITORIA.estadoActual "+;
	" left join tabusuario on tabusuario.id = TabPAUDITORIA.usuario "+;
	" where TabPAUDITORIA.idpres = ?mId  " , "mwkDetEstado")
	
IF mret < 0
   MESSAGEBOX("FALLO LA CONEXION, LLAME A SISTEMAS",16,"VALIDACION")
ENDIF 