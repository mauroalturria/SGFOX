Parameters tncodadmi

lncodadmi  = tncodadmi

* DEMORA DE INTERCONSULTA
mret = SQLExec(mcon1,"select tpde_Fechadesde as tpid_Fechadesde,tpde_estado as tpid_Estado,"+;
	" tpde_TextoDemora as tpid_Interconsulta,TabPacDemoras.id,estados.estado as tipodemora"+;
	" from TabPacDemoras " +;
	" inner join TabEstados as estados on tpde_Demora = estados.estado  and estados.propietario = 15 and estados.tipo = 11 and estados.descrip = 'INTERCONSULTA' "+;
	" inner join TabEstados on TabPacDemoras.tpde_Estado = TabEstados.estado and  TabEstados.propietario = 15 and TabEstados.tipo = 8 "+;
	" and tabestados.descrip = 'PENDIENTE'"+;
	" where tpde_codadmision = ?lncodadmi","mwkdeminter")

If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*= Aerror(eros)
	*Messagebox(eros(3))
Endif

Select tpid_Fechadesde, Iif(tpid_Estado = 1,0,1) As tpid_Estado ,;
	tpid_Interconsulta,Id,tipodemora;
	From mwkdeminter;
	INTO Cursor  mwkdeminter Readwrite

*DEMORA SOCIAL
mret = SQLExec(mcon1,"select tpde_Fechadesde as tpids_Fechadesde,tpde_estado as tpids_Estado,"+;
	" tpde_TextoDemora as tpids_SOCIAL,TabPacDemoras.id,estados.estado as tipodemora"+;
	" from TabPacDemoras " +;
	" inner join TabEstados as estados on tpde_Demora = estados.estado and estados.propietario = 15 and estados.tipo = 11 and estados.descrip = 'SOCIALES' "+;
	" inner join TabEstados on TabPacDemoras.tpde_Estado = TabEstados.estado and  TabEstados.propietario = 15 and TabEstados.tipo = 8 "+;
	" and tabestados.descrip = 'PENDIENTE'"+;
	" where tpde_codadmision = ?lncodadmi","mwkdemSocial")

If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*			= Aerror(eros)
	*!*			Messagebox(eros(3))
Endif

Select tpids_Fechadesde, Iif(tpids_Estado = 1,0,1) As tpids_Estado ,;
	tpids_social,Id,tipodemora;
	From mwkdemSocial;
	INTO Cursor  mwkdemSocial Readwrite

*DEMORA DE ESTUDIO
mret = SQLExec(mcon1,"select tpde_Fechadesde as tpide_Fechadesde,tpde_estado as tpide_estado,"+;
	" tpde_TextoDemora as tpide_ESTUDIO,TabPacDemoras.id,estados.estado as tipodemora"+;
	" from TabPacDemoras " +;
	" inner join TabEstados as estados on tpde_Demora = estados.estado  and estados.propietario = 15 and estados.tipo = 11 and estados.descrip ='ESTUDIOS' "+;
	" inner join TabEstados on TabPacDemoras.tpde_Estado = TabEstados.estado and  TabEstados.propietario = 15 and TabEstados.tipo = 8 "+;
	" and tabestados.descrip = 'PENDIENTE'"+;
	" where tpde_codadmision = ?lncodadmi","mwkdemEstudio")

If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*			= Aerror(eros)
	*!*			Messagebox(eros(3))
Endif

Select tpide_Fechadesde, Iif(tpide_Estado = 1,0,1) As tpide_Estado ,;
	tpide_estudio,Id,tipodemora;
	From mwkdemEstudio;
	INTO Cursor  mwkdemEstudio Readwrite

*DEMORA PROVISION
mret = SQLExec(mcon1,"select tpde_Fechadesde as tpidp_Fechadesde,tpde_estado as tpidp_Estado,"+;
	" tpde_TextoDemora as tpidp_provision,TabPacDemoras.id,estados.estado as tipodemora"+;
	" from TabPacDemoras " +;
	" inner join TabEstados as estados on tpde_Demora = estados.estado  and estados.propietario = 15 and estados.tipo = 11 and estados.descrip = 'PROVISION' "+;
	" inner join TabEstados on TabPacDemoras.tpde_estado = TabEstados.estado and  TabEstados.propietario = 15 and TabEstados.tipo = 8 "+;
	" and tabestados.descrip = 'PENDIENTE'"+;
	" where tpde_codadmision = ?lncodadmi","mwkdemProvision")

If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*			= Aerror(eros)
	*!*			Messagebox(eros(3))
Endif

Select tpidp_Fechadesde, Iif(tpidp_Estado = 1,0,1) As tpidp_Estado ,;
	tpidp_provision,Id,tipodemora;
	From mwkdemProvision;
	INTO Cursor  mwkdemProvision Readwrite