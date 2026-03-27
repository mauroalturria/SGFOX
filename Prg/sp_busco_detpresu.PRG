
Parameters mid, mbusca

If vartype(mbusca) # "C"
	mbusca = " and tabpestado.tipo < 2"
Endif

mret = SQLEXEC(mcon1," SELECT fechaAutoPres as fecha,descripcion as estado,"+;
	" nomape as Usuario,observaciones,observestado,cast(0 as integer ) as UltEstado,"+;
	" tabusuario.codigovax ,tabusuario.idusuario,tabpestado.tipo,estadoActual,Tabpestado.tipo "+;
	" FROM TabPAUDITORIA"+;
	" join tabpestado on tabpestado.id = TabPAUDITORIA.estadoActual" + mbusca +;
	" left join tabusuario on tabusuario.id = TabPAUDITORIA.usuario"+;
	" where TabPAUDITORIA.idpres = ?mId order by TabPAUDITORIA.id", "mwkDetEstado")

If mret < 0
	Messagebox("FALLO LA CONEXION, LLAME A SISTEMAS",16,"VALIDACION")
Endif
