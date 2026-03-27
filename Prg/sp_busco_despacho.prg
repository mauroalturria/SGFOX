****
** Busto Datos de factura por nro de despacho
****

lparameters mNrodesp

mret = sqlexec(mcon1, "select entidad,estado,fechafactura,importe, "+;
	"nfact,nuin,operador,puven,tc,ticli "+;
	"from despachos where nuin = ?mNrodesp", "mwkdespacho")
if mret < 0
	messagebox("ERROR EN LA LECTURA, AVISAR A SISTEMAS", 16,"Validacion")
endif

