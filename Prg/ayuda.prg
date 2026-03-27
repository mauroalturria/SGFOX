do sp_conexion
vr_campos =' nombre, sala '
vr_Condicion = ' where prestadores.id=codmed and diasem >0 '+;
	 		   ' and fecvigenh > to_date("20/10/2004","dd/mm/yyyy") '+;
 			   ' group by codmed,sala ' +;
 			   '	order by nombre,sala '
vr_tablalist =' Prestadores,medpresta '

do sp_listo_tabla_2 with vr_campos,vr_Condicion ,vr_tablalist, 'MwkPresta'


if !eof('MwkPresta')
	copy to c:/desaguemes/prestadores.xls type xls
	wait 'YA está' windows 
endif

=sqldisconnect(mcon1)	