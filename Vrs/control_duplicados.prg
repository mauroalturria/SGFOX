public mcon3,mcon1
do sp_conexion_tablas
mfecdes =ctod("08/03/2005")

mret = sqlexec(mcon3, "select valesasist.* " + ;
						",presinsuvas.* " + ;	
						"from valesasist, presinsuvas " + ;
 						"where  valesasist = pia_valesasist and " + ;
 							"val_fechasolicitud >= ?mfecdes and " + ;
      						"val_codservvale=2200 " , "sinlabo")

=sqldiscon(mcon3)

select count(val_circuitoorigen) as mal, val_codservvale,val_circuitoorigen,val_codadmision;
	,val_fechasolicitud ,val_operadorcarga,valesasist,pia_codprest ;
	  from sinlabo ;
	group by val_codservvale,val_codadmision,val_fechasolicitud,pia_codprest into cursor distins

select * from distins where mal>1 into cursor malos

select * from sinlabo  ;
	where val_codadmision  in ;
	(select val_codadmision  from malos where ;
	sinlabo.val_codservvale = malos.val_codservvale ;
	and sinlabo.val_circuitoorigen = malos.val_circuitoorigen ;
	and sinlabo.val_codadmision = malos.val_codadmision;
	and sinlabo.pia_codprest = malos.pia_codprest;
	and sinlabo.val_fechasolicitud = malos.val_fechasolicitud);
	order by val_fechasolicitud,val_horasolicitud, val_codadmision into cursor filtrados
browse last 

public mcon3,mcon1
do sp_conexion_tablas
mret = sqlexec(mcon3, "select val_fechasolicitud ,val_horasolicitud,val_operadorcarga,valesasist, val_codservvale , pia_cantsolicitada" + ;
		 " , val_circuitoorigen" + ;
		 " from valesasist, presinsuvas" + ;
		 " where  valesasist = pia_valesasist " + ;
		 " and  pia_cantsolicitada>1 and val_codservvale =2200" + ;
		 " and val_fechasolicitud >= to_date('14/02/2005','dd/mm/yyyy')" , "doblecons")
browse last 

