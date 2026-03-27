****
**** Armo la Conexion a la base
****
mcon3= sqlconnect('ConecCentral','_system','sys')
if mcon3 < 0
	Messagebox("Falta conexion a Central",48,"Aviso")
endif




