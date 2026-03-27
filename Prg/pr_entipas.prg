************
*Entidades pasivadas a una fecha
************
* 13/06/2003
************
do sp_conexion
mret=sqlexec(mcon1,"select * from entidades " +;
				"where ENT_fecpas > to_date('01/01/1903','DD/MM/YYYY') "+;
                "and ENT_fecpas < to_date('31/12/1903','DD/MM/YYYY') ","MwkEntiPas")
                
if mret < 0
	messagebox('No Genero',64,'Valid')
	cancel
else
	copy to entidaedesPasivas type xls
endif
=sqldisconnect(mcon1)		                