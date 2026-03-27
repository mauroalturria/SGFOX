*
* CIAM, centros asistenciales, hospitales
*

If used("mwkcentros")
	Use in mwkcentros
Endif

mret = sqlexec(mcon1,"select Id,TCH_nombre,TCH_direccion,TCH_contacto,TCH_telef1,TCH_telef2,TCH_telfax,"+;
	"TCH_idlocalidad,TCH_idcodpostal,TCH_idprovincia,TCH_obser "+;
	"from TabCiamHosp where TCH_fechapasiva is null","mwkcentros")

If mret <= 0
	Messagebox("EN BUSQUEDA DE CENTROS ASISTENCIALES",16,"ERROR")
Endif
