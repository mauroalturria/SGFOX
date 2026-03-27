******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :26/11/2003
********************
parameter vr_dia, vr_diah, vr_codent

if vr_codent >0
	mret = sqlexec(mcon1," SELECT b.nrodesde, b.nrohasta, b.procedencia, b.cantidad, "+;
						 " 	b.fecha, codent, denominacion,ENT_descrient " +;
						 " FROM tabBonorec as b, tabBonoEnti, tabbono, entidades  "+;
					     " WHERE b.idbono = tabbonoEnti.idbono "+;
					     " AND tabbonoenti.idbono = tabbono.id "+;
					     " AND tabbonoenti.codent = entidades.ENT_codent "+;
					     " AND b.fecha=?vr_dia AND codent=?vr_codent "+;
					     " Union "+;
					     " SELECT h.nrodesde, h.nrohasta, h.procedencia, h.cantidad, "+;
						 " 	h.fecha, codent, denominacion,ENT_descrient " +;
						 " FROM tabBonorechist as h, tabBonoEnti, tabbono, entidades  "+;
					     " WHERE h.idbono = tabbonoEnti.idbono "+;
					     " AND tabbonoenti.idbono = tabbono.id "+;
					     " AND tabbonoenti.codent = entidades.ENT_codent "+;
					     " AND h.fecha=?vr_dia AND codent=?vr_codent ","MWKBonoRec")
					     
else
	mret = sqlexec(mcon1," SELECT a.nrodesde, a.nrohasta, a.procedencia, a.cantidad, "+;
						 " 	a.fecha, codent, denominacion,ENT_descrient, "+;
						 "	a.fecha, a.usuario " +;
						 " FROM tabBonorec as a, tabBonoEnti, tabbono, entidades  "+;
					     " WHERE a.idbono = tabbonoEnti.idbono "+;
					     " AND tabbonoenti.idbono = tabbono.id "+;
					     " AND tabbonoenti.codent = entidades.ENT_codent "+;
					     " AND fecha between ?vr_dia AND ?vr_diah "+;
						 " GROUP BY a.idbono,nrodesde,nrohasta,fecha,a.usuario "+;
						 " Union "+;
						 " SELECT h.nrodesde, h.nrohasta, h.procedencia, h.cantidad, "+;
						 " 	h.fecha, codent, denominacion,ENT_descrient, "+;
						 "	h.fecha, h.usuario " +;
						 " FROM tabBonorecHist as h, tabBonoEnti, tabbono, entidades  "+;
					     " WHERE h.idbono = tabbonoEnti.idbono "+;
					     " AND tabbonoenti.idbono = tabbono.id "+;
					     " AND tabbonoenti.codent = entidades.ENT_codent "+;
					     " AND fecha between ?vr_dia AND ?vr_diah "+;
						 " GROUP BY h.idbono,nrodesde,nrohasta,fecha,h.usuario ","MWKBonoRec")

endif
if mret < 0
	messagebox('ERROR AL VALIDAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
endif



  
 
 
  
