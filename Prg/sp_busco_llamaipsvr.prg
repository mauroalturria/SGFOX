*!* Program:
*!* Author: Gustavo Fittipaldi
*!* Date: 11/01/13 11:15:19 AM
*!* Copyright:
*!* Description:
*!* Revision Information:
*!* --------------------------------------------------------------------------- 
Parameters tcIpServer

lcSql = "select tabllamaip.lla_ippuesto, tabstpuesto.nroconsultorio, tabllamaip.lla_ipserver, tabllamaip.Id " + ;
		"from TabLlamaIp " + ;
	"left join TabStPuesto on tabstpuesto.puesto = tabllamaip.lla_ippuesto " + ;
	"where tabllamaip.lla_ipserver = ?tcIpServer " 



If !Prg_EjecutoSql(lcSql,"mwkTabllamaIp1Svr")
	Return .f.
Endif 