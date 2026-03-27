***
*** Busqueda de proveedor
***
Lparameters mopcion, mproveedor

If used('mwkproveedor')
	Use in mwkproveedor
Endif

Local mwhere
mwhere = ''

mopcion = iif(vartype(mopcion)#"N",0,mopcion )

Do case
Case mopcion = 0  && todos
	mwhere = "where PRV_ESTADO = 'A' "
Case mopcion = 1  && codigo
	mbusca = mproveedor
	mwhere = "where PRV_ID = ?mbusca and PRV_ESTADO = 'A' "
Case mopcion = 2  && codigo
	mbusca = alltrim(mproveedor)
	mwhere = "where PRV_NOMBRE LIKE '&mbusca%' and PRV_ESTADO = 'A' "
Case mopcion = 3  && in codigo
	mbusca = alltrim(mproveedor)
	mwhere = "where PRV_ID in (" + mproveedor + ") and PRV_ESTADO = 'A' order by PRV_NOMBRE  "

Endcase

mret = sqlexec(mcon1, "select * from FBproveedores " + mwhere , "mwkproveedor")

If mret < 0

*!*	public mcon2
*!*	do sp_conexion_otras with "CATALOGO"
*!*	mret = sqlexec(mcon2, "select * from proveedores "+mwhere, "mwkproveedor")
*!*	if mret <1
*!*		messagebox("EN BUSQUEDA EN MAESTRO DE PROVEEDORES ",16,"ERROR")
*!*	endif

	Messagebox("ERROR DE LECTURA MAESTRO DE PROVEEDORES",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
	
Endif

