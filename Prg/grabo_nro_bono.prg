******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :13/11/2003
********************
parameters vr_serie,vr_nrodesde, vr_nrohasta, vr_proceden, vr_cant, vr_fecha,;
			vrfgraba, vr_idbono, vr_tipobono,vr_usu
			
			
mret=sqlexec(mcon1," INSERT INTO TabbonoRec( Bonoserie, NroDesde, NroHasta, procedencia,  "+;
				   " cantidad, Fecha, fechagraba, idbono, tipobono, usuario) "+;
				   " VALUES (?vr_serie,?vr_nrodesde,?vr_nrohasta,?vr_proceden,?vr_cant,"+; 
				   " ?vr_fecha, ?vrfgraba, ?vr_idbono, ?vr_tipobono, ?vr_usu ) ")

if mret < 0
	messagebox('ERROR AL GRABAR BonoRec, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
Endif
musuario = ''
for mnrobono = vr_nrodesde to vr_nrohasta
									
	mret=SQLExec(mcon1,"insert into TabbonoDet (BonoSerie, NroBono,TipoBono,usuario) "+;
		" values ( ?vr_serie, ?mnrobono, ?vr_idbono ,?musuario)")
	if mret<0 
		=aerr(eros)
		messagebox('ERROR '+eros(3)+'AL GRABAR BonoRec, AVISAR A SITEMAS',16,'VALIDACION')
	endif			
next
