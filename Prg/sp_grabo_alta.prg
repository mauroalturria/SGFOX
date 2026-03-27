******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :09/10/2003
********************
parameter v_nonbono, v_imp, v_tipobono, v_usu, v_fechaHora, v_fecdesde, v_fechasta,vr_bonoasoc,mabm,mmotivo 
if mabm = 1
	mret = sqlexec(mcon1,"INSERT INTO TabBono (CodMotivo , Denominacion , Importe , TipoBono , "+;
				" Usuario , fechagraba , fecvigend , fecvigenh , idbonoasoc) "+;
				" values ( ?mmotivo,?v_nonbono,?v_imp, ?v_tipobono, "+;
				    " ?v_usu,?v_fechaHora,?v_fecdesde,?v_fechasta,?vr_bonoasoc )")
else
	v_id = IIF(USED('MWKantBono'),MWKantBono.id,MWKExisteBono.id)
	mret = sqlexec(mcon1,"UPDATE TabBono set CodMotivo = ?mmotivo, Denominacion = ?v_nonbono, Importe = ?v_imp, TipoBono = ?v_tipobono, "+;
				" Usuario = ?v_usu, fechagraba =?v_fechaHora, fecvigend = ?v_fecdesde, fecvigenh =?v_fechasta, idbonoasoc =?vr_bonoasoc  "+;
				    " where id = ?v_id ")
endif
if mret < 0
	messagebox('ERROR AL ACTUALIZAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
	do prg_cancelo
else
	messagebox('LOS DATOS FUERON ACTUALIZADOS',64,'VALIDACION')
Endif


			   