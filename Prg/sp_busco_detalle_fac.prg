******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :09/10/2003
********************
parameter vr_nroFac

mret= sqlexec(mcon1,'select b.denominacion as nombrebono, a.bonodesde as nrodesde,'+;
					' a.bonohasta as nrohasta, '+;
					' a.cantidad, a.importeb as importe, '+;
					' a.tipobono, a.valorUni, a.usuario, a.fechagraba '+;
					' from TabdetalleFac as a,tabbono as b '+;
					' where a.NroFactura=?vr_nroFac and a.tipobono = b.id ','MWKfactSelec')
		
if mret < 0
	messagebox('ERROR AL ACTUALIZAR Detalle de Facuras, AVISAR A SITEMAS',16,'VALIDACION')
	mret=0
endif					



