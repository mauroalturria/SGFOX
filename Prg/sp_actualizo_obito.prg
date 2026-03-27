*!*	actualizo obito
parameters   mnrocert,mentrega,mfecentrega
************************************************
mdtF    = sp_busco_fecha_serv('DT')

midSocio   	= mwkLLegadas1.IdSocio
mapenom    	= allt(mwkLLegadas1.ApellidoNombre)
mnroadm 	= iif(!empty(nvl(mwkLLegadas1.paciente,'')),mwkLLegadas1.paciente,substr(nvl(mwkLLegadas1.Observacion,space(30)),5,8))
mTIPOPAC 	= left(nvl(mwkLLegadas1.Observacion,space(30)),3)
mid = 0
mret = 0
mestado = iif(mwkLLegadas1.IdMotivo=15,2,11)
if used("mwkobito")
	if reccount("mwkobito")>0
		mid = mwkobito.id
	endif
endif
if mid = 0
	mret=sqlexec(mcon1,"SELECT	id from Tabpacobito where PO_admision = ?mnroadm ","mwkrreg")
	mid = mwkrreg.id
endif
if mret < 0
	=aerr(eros)
	messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
else

	if reccount("mwkrreg")=0 and reccount("mwkobito")= 0
		messagebox("ESTE OBITO NO FUE INGRESADO DESDE PISOS. NO SE EFECTUARA SEGUIMIENTO",64,"Alerta")
	else
		lcSql = "UPDATE Tabpacobito set PO_Estado = ?mestado  "+;
			", PO_NroCertif = ?mnrocert, PO_entregadoa = ?mentrega"+;
			", PO_FHEntrega = ?mfecentrega, PO_NroSocio = ?midSocio "+;
			" where id = ?mid "

		if !Prg_EjecutoSql(lcSql,'',.f.)
			return .f.
		endif

	endif
endif

