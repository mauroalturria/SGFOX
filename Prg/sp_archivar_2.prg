**********************************
* Archivo en Historico los Bonos 
**********************************
* Fecha :02/08/2004
* Actaulizado :
*********************************

parameters vr_nroBon1, vr_nroBon2, vr_idbonoR, vr_serie


* copio al historico
if vr_nroBon1 > 0
	mret = sqlexec(mcon1," insert into tabDetalleFacHist ( Bonoserie, BonoDesde,BonoHasta,"+;
						 " Cantidad,ImporteB,LetraComp,NroFactura,PtoVta,TipoBono, "+;
						 " TipoComp,ValorUni,fechagraba,usuario) "+; 
						 " SELECT Bonoserie,BonoDesde,BonoHasta,Cantidad,ImporteB, "+;
						 " LetraComp,NroFactura,PtoVta,TipoBono,TipoComp, "+;
						 " ValorUni, fechagraba, usuario"+; 
						 " FROM TabDetalleFac " +;
						 " Where BonoDesde between ?vr_nroBon1 And ?vr_nroBon2 "+;
						 " and (Bonoserie is null or Bonoserie= ?vr_serie)","MwkDFHist")  

	if mret < 0					 
		messagebox('ERROR EN GENERACION DE TABLA, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	else
	
		mret =sqlexec (mcon1,"DELETE FROM tabDetalleFac " +;
					 	" Where BonoDesde between ?vr_nroBon1 "+;
					 	" And ?vr_nroBon2 and (Bonoserie is null or Bonoserie= ?vr_serie) ")		
		if mret < 0
			messagebox('ERROR EN PASAJE AL HISTORICO DEL id: ' + allt(str(round(vr_nroBon1,0))) +;
						 '-'+ allt(str(round(vr_nroBon2,0))) +' TOME NOTA y AVISE A SISTEMAS',64,'Validacion')
			mret = 0
			cancel	
		endif	
	endif						 
endif
		
if vr_idbonoR > 0
	
	vr_fecdep =allt(str(year(mwkfecserv.fechahora)))+ '-' + allt(str(month(mwkfecserv.fechahora))) + '-' +;
				allt(str(day(mwkfecserv.fechahora))) + space(1) + allt(str(hour(mwkfecserv.fechahora))) + ':' +;
				allt(str(minute(mwkfecserv.fechahora))) + ':' + allt(str(sec(mwkfecserv.fechahora)))
				
	mret = sqlexec(mcon1," insert into tabbonorechist (BonoSerie,NroHasta,Nrodesde,Procedencia, "+;
						 " cantidad,fecha,fechadepura,fechagraba,idbono,tipobono,usuario, usuariodep) "+;
						 " SELECT BonoSerie, NroHasta, Nrodesde, Procedencia, cantidad,"+;
						 " fecha, '" + vr_fecdep + "' as fechadepura, fechagraba, idbono,"+;
						 " tipobono, usuario, '" + allt(Mwkusuario.idusuario)   + "' as usuariodep "+;
						 " FROM TabBonoRec " +;
						 " WHERE tabBonoRec.id = ?vr_idbonoR ","MwkBRHist")
							 
	if mret < 0					 
		messagebox('ERROR EN PASAJE AL HISTORICO DEL ID: ' + allt(str(round(vr_idbonoR,0))) + ' TOME NOTA y AVISE A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	else
	
		mret =sqlexec (mcon1,"DELETE FROM tabBonoRec " +;
			 	" Where id = ?vr_idbonoR")	
	endif				 	
endif
