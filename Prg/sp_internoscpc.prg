Do sp_conexion
do sp_busco_estados with 7,' and tipo = 68 ','mwkVdc0001'&&
Do sp_busco_archivos_calidad with 'frminternos',0,mwkVdc0001.Estado
Use In Select("mwkVdc0001")
Do sp_desconexion