Parameters ldfechoy,lncodadmision,codigovax,lnid,lcestado,ldfecdesde,lcsocial,lcaccion

Do Case
Case lcaccion = "BORRO"
	mret = SQLExec(mcon1,"delete from TabPacDemoras where TabPacDemoras.id = ?lnid")
Case lcaccion = "MODIFICO"
	mret = SQLExec(mcon1,"update TabPacDemoras set tpde_CargaFechaHora = ?ldfechoy,tpde_TextoDemora= ?lcsocial,"+;
		" tpde_Estado = ?lcestado,tpde_Fechadesde = ?ldfecdesde " +;
		" where TabPacDemoras.id = ?lnid ")
Case lcaccion = "INSERTO"
	mret = SQLExec(mcon1,"insert into TabPacDemoras (tpde_CodigoVax,tpde_CargaFechaHora,tpde_codadmision,"+;
		" tpde_TextoDemora,tpde_Estado,tpde_Fechadesde,tpde_Demora) " +;
		" values (?codigovax,?ldfechoy,?lncodadmision,?lcsocial,?lcestado,?ldfecdesde,?lndemora)")
Endcase

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*	= Aerror(eros)
	*	Messagebox(eros(3))
	Return .F.
Endif