*****************************
* AUTOR: Claudia C. Antoniow
*****************************
* Fecha :30/03/2004
********************
parameter v_idbono, v_nrobono1,v_serie, v_nrobono2

if type('vr_serie')#"C"
	v_serie=""
	v_bonoserie = " AND NVL(BonoSerie,'')= ?v_serie  "
else
	v_bonoserie = " AND BonoSerie = ?v_serie "	
endif

mret = sqlexec(mcon1," SELECT * FROM tabBonoAsig "+;
				     " WHERE idbono = ?v_idbono " + v_bonoserie +;
				     " AND (?v_nrobono1 BETWEEN Bonodesde AND BonoHasta "+;
				     " OR ?v_nrobono2 BETWEEN Bonodesde AND BonoHasta) ","MWKExisteBonoR")

if mret < 0
	messagebox('ERROR AL VALIDAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
	cancel
endif

mret = sqlexec(mcon1," SELECT * FROM tabBonoSector "+;
				     " WHERE idbono = ?v_idbono " + v_bonoserie +;
				     " AND (?v_nrobono1 BETWEEN Bonodesde AND BonoHasta "+;
				     " OR  ?v_nrobono2 BETWEEN Bonodesde AND BonoHasta)","MWKExisteBonoRR")

if mret < 0
	messagebox('ERROR AL VALIDAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
	cancel
endif


	