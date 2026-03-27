*!*	actualizo evolucion AKR/AKM
Parameters   mEIK_tipo ,mEIK_idevol ,mEIK_codmed , mEIK_evoluc 

mfechahor = sp_busco_fecha_serv("DT")

lcSql = "Insert into TabIntevolKine" + ;
	" (EIK_fechaHora , EIK_codmed , EIK_evoluc , EIK_idevol , EIK_tipo) " + ;
	" Values " + ;
	" (?mfechahor , ?mEIK_codmed , ?mEIK_evoluc , ?mEIK_idevol , ?mEIK_tipo ) "

if !Prg_EjecutoSql(lcSql,'',.f.)
	Return .f.
Endif 
