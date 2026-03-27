*****
* Busco contraseñas de usuarios
*****
lparameters mtipusu,codigo

if mtipusu = 1 
	mwhere = " where codmed = ?codigo "
else
	mwhere = " where usuario = ?codigo "
endif
do sp_busco_estados with 7,' and tipo = 0 ','mwkestclaves'&&
GO top
mkant = transform(mwkestclaves.estado)
mret = sqlexec(mcon1,'SELECT top &mkant Password,FechaAct  from TabResgPass '+;
	mwhere + ' order by FechaAct desc', 'mwkresgpass')
if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
endif
