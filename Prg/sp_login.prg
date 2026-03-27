***
*** infromacion de Login
***
If Vartype(mxcentromedico)<>"N"
	PUBLIC mxcentromedico
	mxcentromedico =1
Endif
maidusu	= mwkusuario.idusuario
maexe	= Alltrim(mwkexe.nomexe)+Transform(mxcentromedico)
mahora	= sp_busco_fecha_serv('DT')
mret = SQLExec(mcon1, "insert into TabAcceso (TA_Exe,TA_Fechora,TA_Tipo,TA_Usuario)" +;
" values (?maexe, ?mahora, 1, ?maidusu )" )
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
Endif
mipc =  Sys(0)
mipc = Left(Left(mipc,At("#",mipc)-1)+Strtran(myip,'172.16.',''),50)
If Left(mwkusuario.sector,4) = 'CALL' And mwkexe.nomexe ="TURNOS"
	maidusu		= mwkusuario.codigovax
	maexe		= mwkexe.nomexe
	mhoranul 	= Ctot("01/01/1900")
	mahora		= sp_busco_fecha_serv('DT')
	mret = SQLExec(mcon1, "insert into TabAccesoInt (Comentarios , HoraDesde , HoraHasta , "+;
	"IPpuesto , Interno , Usuario )" +;
	" values ('', ?mahora, ?mhoranul, ?mipc, ?mintcall, ?maidusu )" )
Endif
