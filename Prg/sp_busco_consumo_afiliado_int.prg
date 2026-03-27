*****************************
* Autor: Claudia C. Antoniow
*****************************
* Fecha Creación :24/09/2003
*****************************
* para :frmprep04

parameter vr_afi, vr_grup, vr_fecha_d, vr_fecha_h

IF !empty(vr_afi)
	 		mret=sqlexec(mcon1,"SELECT i.FechaAdmision, i.fechaAlta, i.diagnosticoIngreso, "+;
 					  	"SUM(CASE  WHEN d.idsectorinternacion ='INT' THEN d.cantidaddias "+;
					  	" ELSE 0 END) as c_gral, "+;
					  	"SUM(CASE  WHEN d.idsectorinternacion ='CEG' THEN d.cantidaddias "+;
					  	" ELSE 0 END) as c_Hdia, "+;
					  	"SUM(CASE WHEN d.idsectorinternacion ='PED' THEN d.cantidaddias "+;
					 	" ELSE 0 END) as c_ped, "+;
					 	"SUM(CASE WHEN d.idsectorinternacion ='UTI' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_uti, "+;
 						"SUM(CASE WHEN d.idsectorinternacion ='UCO' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_uco, "+;
						"SUM(CASE WHEN d.idsectorinternacion ='NNT' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_nnt, "+;
						"SUM(CASE WHEN d.idsectorinternacion ='TEP' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_tep, i.nrointernacionext, i.credencial, "+;
						" a.id as idafiliado "+;
						"FROM internaciones as i, detalleInternaciones as d, "+;
						" credenciales as c ,afiliados as a "+;
						"WHERE  a.id = ?vr_afi "+;
				   		" AND i.id=d.idinternacion and i.credencial=c.nrocredencial "+;
						" AND c.idafiliado=a.id "+;
						" AND FechaAdmision <= ?vr_fecha_H and (i.fechaAlta >=?vr_fecha_D OR i.fechaAlta IS NULL )"+;
						"GROUP BY a.id, d.idsectorinternacion  "+;
						"ORDER BY fechaAdmision ","MwkConsafiInt")
						
						
		if mret < 0
			messagebox('ERROR DE CURSOR, AVISAR A SISTEMAS ',64,'Validacion')
			cancel
			mret=0
		endif
endif
if !empty(vr_grup)
	mret=sqlexec(mcon1," SELECT a.Nombre, i.FechaAdmision, i.fechaAlta, i.diagnosticoIngreso, "+;
						"SUM(CASE  WHEN d.idsectorinternacion ='INT' THEN d.cantidaddias "+;
					  	" ELSE 0 END) as c_gral, "+;
					  	"SUM(CASE  WHEN d.idsectorinternacion ='CEG' THEN d.cantidaddias "+;
					  	" ELSE 0 END) as c_Hdia, "+;
					  	"SUM(CASE WHEN d.idsectorinternacion ='PED' THEN d.cantidaddias "+;
					 	" ELSE 0 END) as c_ped, "+;
					 	"SUM(CASE WHEN d.idsectorinternacion ='UTI' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_uti, "+;
 						"SUM(CASE WHEN d.idsectorinternacion ='UCO' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_uco, "+;
						"SUM(CASE WHEN d.idsectorinternacion ='NNT' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_nnt, "+;
						"SUM(CASE WHEN d.idsectorinternacion ='TEP' THEN d.cantidaddias "+;
						" ELSE 0 END) as c_tep, i.nrointernacionext, i.credencial, a.id as idafiliado "+;
						"FROM internaciones as i, detalleInternaciones as d, "+;
						" credenciales as c ,afiliados as a "+;
 						" WHERE c.idgrupo = ?vr_grup "+;
 						" AND i.id=d.idinternacion and i.credencial=c.nrocredencial "+;
						" AND c.idafiliado=a.id "+;
						" AND FechaAdmision <= ?vr_fecha_H and (i.fechaAlta >=?vr_fecha_D OR i.fechaAlta IS NULL )"+;
						"GROUP BY a.id, d.idsectorinternacion "+;
						"ORDER BY nombre, fechaAdmision  ","MwkConsafiInt")
						
						
	if mret < 0
		messagebox('ERROR DE CURSOR, AVISAR A SISTEMAS ',64,'Validacion')
		cancel
		mret=0
	endif				   
endif					   

*" AND (FechaAlta between ?vr_fecha_d and ?vr_fecha_h OR FechaAlta is null ) "+;