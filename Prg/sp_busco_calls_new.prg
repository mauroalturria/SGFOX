***
*** Busqueda de llamadas
***
lparameters mfdes, mfhas, mcinterno
mfechad = ttod(mfdes)
mfechah = ttod(mfhas)
mret = sqlexec(mcon1 ,"SELECT * FROM TraficoTelefonico where tipo = 1 "+ ;
	" and fecha between ?mfechad and ?mfechah and ((interno>= 710 and interno<1999) or (interno > 9000)) " + mcinterno ,"control")
**codigo='0' and
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
select fecha, hora,hour(duracion)*3600+ minute(duracion)*60 + sec(duracion)-15 as segundos;
	,ttoc(hora,2) as horafin, ctot( dtoc( fecha)+ ' '+ ttoc( hora, 2)) as fecha_captura;
	, troncal,nrotelefono as telefono, interno,duracion ;
	from control having fecha_captura >= mfdes and fecha_captura <= mfhas into cursor mwkllamadas
