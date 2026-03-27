lParameters mfechaO, mfechah

LCCONSOLE = SET("CONSOLE")
SET CONSOLE OFF

Set alternate to c:\temp\PasaEstad.txt
Set Alternate on
&& abrir un Archivo y generar un Log con los dias que no se puedieron pasar

mfecha = sp_busco_fecha_serv('DT') 

? "INICIO DEL PROCESO DE PASAJE ESTADISTICO " + ttoc(mfecha)	

Do While mfechaO < mfechah + 1
		
	Wait wind "Procesando el día " + dtoc(mfechaO) NoWait
	
	&& controlo si existe
	do sp_busco_est_group With mfechaO, mfechaO
	

	If Reccount("mwkProxyGroup") > 0
		? "YA EXISTE INFORMACION PARA LA FECHA -> " + DTOC(mfechaO)
		mfechaO = mfechaO + 1 && incremento un dia 
		loop
	Endif 

	&& controlo si existe
	do sp_busco_est_proxy With 2, mfechaO, mfechaO
	
	Select mwkProxyLog && datos a pasar
	Scan all
		
		murl = alltrim(mwkProxyLog.Tpl_url)
		mestado = alltrim(mwkProxyLog.Tpl_estado)
		muser = alltrim(mwkProxyLog.Tpl_user)
		mip = alltrim(mwkProxyLog.Tpl_Ip)
		
		mresu = SqlExec(mcon1, "Insert into TabProxyGroup " + ;
					"( tpg_fecha, tpg_hora, tpg_ip, tpg_usuario, tpg_url, tpg_estado, tpg_cantidad, tpg_mb ) Values " + ;
					"( ?mwkProxyLog.Tpl_fecha, " + ;
					" ?mwkProxyLog.Tpl_hh, " + ;
					" ?mip, " + ;
					" ?muser, " + ;
					" ?murl, " + ;
					" ?mestado, " + ;
					" ?mwkProxyLog.Cant, " + ;
					" ?mwkProxyLog.Mb )" )

		If mresu <= 0
		
		&& ver que hacer aca ----------------
			 ? "ERROR AL AGREGAR "
			 ? " Fecha   - " + DTOC(mwkProxyLog.Tpl_fecha)
			 ? " Hora    - " + Str(mwkProxyLog.Tpl_hh)
			 ? " Ip      - " + mwkProxyLog.Tpl_Ip
			 ? " Usuario - " + mwkProxyLog.Tpl_user
			 ? " Url     - " + mwkProxyLog.Tpl_url
			 ? " Estado  - " + mwkProxyLog.Tpl_estado
			 ? " Cant.   - " + Str(mwkProxyLog.Cant)
			 ? " MB      - " + Str(mwkProxyLog.Mb,16,2)
		Endif 	

		Select mwkProxyLog
	EndScan 	

	&& cambio de dia
	mfechaO = mfechaO + 1
Enddo 
mfecha = sp_busco_fecha_serv('DT') 
? "PROCESO DE PASAJE ESTADISTICO COMPLETADO " + ttoc(mfecha)	

Set Alternate off
Set alternate to 

SET CONSOLE &LCCONSOLE

modi file c:\temp\PasaEstad.txt noedit
