*****
* Busco ingresos al Ejecutable pedido
****
parameters mejec,mdesde,mhasta,mcontrolamb 
mbusco = alltrim(mejec)
if vartype(mcontrolamb)#"N"
	mcontrolamb = 0
endif
mcambjoin = ''
if mcontrolamb = 1 and mxambito>1
	mcambjoin = ' inner join TabPermisosAmbito on ( '+;
	' Tabpermisosambito.codambito = ?mxambito '+;
   	' AND Tabpermisosambito.codusuario = Tabusuario.ID )'
endif    

mwhere = " and TA_Exe = ?mbusco and Tabacceso.TA_Fechora >= ?mdesde "
mret = SQLEXEC(mcon1," select * from TabAcceso ,tabusuario "+mcambjoin+;
	" where Tabusuario.idusuario = Tabacceso.TA_Usuario "+mwhere+;
	" group by idusuario" ,"mwkAcceso")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif





