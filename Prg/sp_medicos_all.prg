*************************************************************************
* Trae nombre y codigo de todos los médicos y arma una tabla de cargos
*************************************************************************
lparameters mfnull,tcCursor
if vartype(tcCursor) # "C"
	tcCursor= 'mwkMedicosall'
endif
mwheref = ''
if vartype(mfnull) = "D"
	mfecnul = ctod("01/01/1900")
	mwheref = " and (Prestadores.fecpasivap = ?mfecnul or Prestadores.fecpasivap > ?mfnull)"
endif

use in select(tcCursor)
use in select("mwkmedcargo")

mret = SQLExec(mcon1,"SELECT prestadores.id,nombre,matriculas,fecpasiva,usuarpas,"+;
	" fecpasivap,fecpasivai,dambula,dguardia,dinterna,TPF_filtro,cuil,nroproveedor,email as e_mail,emailcorp " + ;
	" FROM Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" where prestadores.id < 100000 " + mwheref +;
	" ORDER BY nombre",tcCursor )

if mret < 0
*   =aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validación")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif

mret = SQLExec(mcon1,"SELECT Prestadores.ID, Tabprofesp.CodCargo ,Tabcargo.descrip,Tabprofesp.codarea,TPF_filtro,cuil,email as e_mail,emailcorp " + ;
	" FROM Tabcargo,Tabprofesp,Prestadores "+;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" WHERE Tabprofesp.CodCargo = Tabcargo.ID"+;
	" AND Prestadores.ID = Tabprofesp.CodProf"+mwheref +;
	" group by Prestadores.ID" ,"mwkmedcargo")

if mret < 0
*   =aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validación")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
