*
* Busqueda de version en linea
*
lparameters mvlauncher
Use in select("mwkctrvers")
mfecant = sp_busco_fecha_serv("DD")-2
mret = sqlexec(mcon1,"SELECT TCS_Memoria, TCS_IPaddress,TCS_Device, TCS_ClientName,"+;
  	" TCS_Fechah, TCS_Name,NroConsultorio"+;
	" FROM  Tabctrlserver LEFT OUTER JOIN Tabstpuesto "+;
   	" ON  TCS_IPaddress = Puesto "+;
	" WHERE TCS_Fechah >= ?mfecant and TCS_Memoria<> ?mvlauncher"+;
	"   AND TCS_Program = 'sp_conexion' "+;
	" GROUP BY TCS_IPaddress, TCS_Device "+;
 	" ORDER BY TCS_IPaddress, TCS_Fechah" ,"mwkctrvers")

If mret < 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
select *,padr(ALLTRIM(upper(left(STRTRAN(TCS_Device,'-',''),at(" ",STRTRAN(TCS_Device,'-',''))))),20) as eje ;
	from mwkctrvers group by tcs_ipaddress,eje into cursor mwkctrversion

Return .T.


