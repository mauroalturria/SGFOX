******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :30/10/2003
********************
parameter vr_codbon, v_nrbonoD, v_nrbonoH, vr_usuario,vr_serie
if type("vr_serie")#"C"
	vr_serie=''
endif
if v_nrbonoH>0
	mret = sqlexec(mcon1," SELECT count(*) as cbonos  FROM TabBonoDet WHERE tipobono =?vr_codbon "+;
						 " AND nrobono>=?v_nrbonoD AND nrobono<=?v_nrbonoH "+;
						 " and bonoserie = ?vr_serie " ,"MWKnoVendido")
else
	mret = sqlexec(mcon1," SELECT count(*) as cbonos  FROM TabBonoDet WHERE tipobono =?vr_codbon "+;
						 " AND nrobono=?v_nrbonoD "+;
						 " and bonoserie = ?vr_serie ","MWKnoVendido")
endif
if mret < 0
	messagebox('ERROR DE CURSOR MWKVendido, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
endif

					  