*****
** Busco Protocolo -
****

Parameter madmision,msec,mred
If Vartype(mred)#"N"
	mred=0
Endif
mifeclim = sp_busco_fecha_serv("DT")-24*3600
mifeclim2 = mifeclim -48*3600
mcfeclim = prg_dtoc(mifeclim)
mcfeclim2 = prg_dtoc(mifeclim2)
mret = SQLExec(mcon1, "select pac_codadmision, REG_nombrepac, IH_fechaHoraIng , IH_horaCierre , IH_secuencia," + ;
	" nombre,IH_codestado, IH_codcie, IH_codmed,  IH_codmedcie,REG_nroregistrac, IH_motIngreso,REG_nrohclinica,"+;
	" REG_domicilio,reg_email,reg_telefonos,reg_fecnacimiento,TPV_Estado,reg_sexo," + ;
	" reg_localidad,reg_provincia,TabIntHCE.id,IH_procedencia,IH_reingre,IH_secagrup,IH_resumen,reg_numdocumento "+;
	" from pacientes "+;
	" inner join registracio on pac_codhci = REG_nroregistrac  "+ ;
	" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
	" left join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" left outer join prestadores on TabIntHCE.IH_codmed = prestadores.id " + ;
	" left outer join motivoegreso on TabIntHCE.IH_codestado = motivoegreso.id " + ;
	"where pac_codadmision = ?madmision"  , "mwkintevol")
&&	" left outer join TabIntEvol on tabintHCE.id = TabIntEvol.EI_idevol " +

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Messagebox(eros(3))
	Do sp_desconexion With "Err sp_busco_protocolo_historia"
	Cancel
Endif
If !Used('mwkMedicointall')
	Do sp_busco_med_pisos && with sp_busco_fecha_serv("DD") saco esto porque omite los pasivos!!!
	Select  Id, nombre,codesp,matricula As matriculas  From mwkmedicoint Where 1=2 Into Cursor mwkMedicouno
	Use In Select("mwksinmed")
	Use Dbf('mwkMedicouno') In 0 Again Alias mwksinmed
	Select mwksinmed
	Insert Into mwksinmed (Id, nombre,codesp,matriculas  ) Values (1,"SIN ANAMNESIS","",0)
	Select  Id, nombre,codesp,matricula As matriculas  From mwkmedicoint Union All;
		select * From mwksinmed Into Cursor mwkMedicointall
	Use In Select("mwksinmed")
	Use In Select("mwkMedicouno")

Endif

If mred = 0
	Use In Select("mwkintevolpro")
	mret = SQLExec(mcon1, "select * from TabIntHCE "+;
		" where IH_admision = ?madmision and IH_secuencia = ?msec", "mwkintevolpro" )
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif
	Select * From mwkintevol  Where Nvl(IH_secuencia,1)=msec Into Cursor  mwkveoproto
	Go Top
	midevol = mwkveoproto.Id

	mret = SQLExec(mcon1, "select  * "+;
		" from TabIntAnam "+;
		"where IA_idevol= ?midevol"  , "mwkanam")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif

	mret = SQLExec(mcon1, "select ID, EATB_dias, EATB_esquema, EATB_fechafin, EATB_fechaini, EATB_idevol "+;
		" from TabIntEsquemas "+;
		"where EATB_idevol= ?midevol"  , "mwkatbesq")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif

*!*		mret = SQLExec(mcon1, "select IS_codmed , IS_fechaHD , IS_fechaHH , IS_idevol , IS_responsable , IS_secagrup , IS_servicio,Codesp"+;
*!*			" from TabIntServ left join Zapservespec on IS_servicio   = Zapservespec.NroServicio "+;
*!*			"where IS_idevol = ?midevol"  , "mwkservresp")
mret = sqlexec(mcon1, "select IS_codmed , IS_fechaHD , IS_fechaHH , IS_idevol , IS_responsable , IS_secagrup , IS_servicio,ser_descripserv  "+;
		" from TabIntServ left join servicios on IS_servicio   = ser_codserv "+;
		"where IS_idevol = ?midevol"  , "mwkservresp")
	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif
	mret = SQLExec(mcon1, "select TabIntevolIC.*,"+;
		" EIC_usuario->nomape,EIC_usuario->idcodmed "+;
		" from TabIntevolIC "+;
		"where EIC_idevol = ?midevol and EIC_fechaHora >= ?mcfeclim order by id desc "  , "mwkevolIC")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif
	Select mwkevolIC.* ,matriculas  From mwkevolIC Left Join mwkMedicointall On idcodmed = mwkMedicointall.Id Into Cursor mwkevolICd
	Select * From mwkevolICd Into Cursor mwkevolIC
	Use In Select("mwkevolICd" )
	Select mwkevolIC

	mret = SQLExec(mcon1, "SELECT top 5 TabIntResumenHC.*,nomape as nombre,idcodmed "+;
		" FROM TabIntResumenHC"+;
		" inner join tabusuario on tabusuario.id = TabIntResumenHC.RH_usuario " +;
		" where TabIntResumenHC.RH_idevol = ?midevol  "+;
		"order by TabIntResumenHC.id desc ", "mwkEvolResHC")
	If Reccount("mwkEvolResHC")  = 0
		mret = SQLExec(mcon1, "SELECT top 5 TabIntResumenHC.*,nomape as nombre ,idcodmed "+;
			" FROM TabIntResumenHC "+;
			" inner join tabusuario on tabusuario.id = TabIntResumenHC.RH_usuario " + ;
			" inner join TabintHCE on  tabintHCE.id = TabIntResumenHC.RH_idevol" + ;
			" where tabintHCE.IH_admision = ?madmision group by TabIntResumenHC.id order by TabIntResumenHC.id desc" , "mwkEvolResHC")

	Endif
	Select mwkEvolResHC.* ,matriculas From mwkEvolResHC Left Join mwkMedicointall On idcodmed = mwkMedicointall.Id Into Cursor mwkEvolResHCd
	Select * From mwkEvolResHCd  Into Cursor mwkEvolResHC
	Use In Select("mwkEvolResHCd" )
	Select mwkEvolResHC

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif


	mret = SQLExec(mcon1, "SELECT top 20 TabIntEvolKine.*,nomape as nombre,idcodmed "+;
		" FROM TabIntEvolKine"+;
		" inner join tabusuario on tabusuario.idcodmed = TabIntEvolKine. EIK_codmed " + ;
		" where TabIntEvolKine.EIK_idevol = ?midevol  "+;
		"", "mwkEvolAKtodo")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif
	Select mwkEvolAKtodo.* ,matriculas From mwkEvolAKtodo Left Join mwkMedicointall On idcodmed = mwkMedicointall.Id Into Cursor mwkEvolAKtodod
	Select * From mwkEvolAKtodod  Into Cursor mwkEvolAKtodo
	Use In Select("mwkEvolAKtodod" )
	Select * From mwkEvolAKtodo Where EIK_tipo  = 1 ;
		order By Id Desc Into Cursor mwkEvolAKM
	Select * From mwkEvolAKtodo Where EIK_tipo  = 2 ;
		order By Id Desc Into Cursor mwkEvolAKR

	mret = SQLExec(mcon1, "select EIN_codCIENanda,EIN_evolNurse ,EIN_fechaH, EIN_parAdmF ,EIN_parAlerg "+;
		",EIN_parAlergQue ,EIN_parOtros ,EIN_idevol ,EIN_usuario->nomape from TabIntEvolNurse"+;
		" where 1=2 "  , "mwkevolNur")
*!*		mret = sqlexec(mcon1, "select EIN_codCIENanda,EIN_evolNurse ,EIN_fechaH, EIN_parAdmF ,EIN_parAlerg "+;
*!*			",EIN_parAlergQue ,EIN_parOtros ,EIN_idevol ,EIN_usuario->nomape from TabIntEvolNurse"+;
*!*			" where EIN_idevol = ?midevol and EIN_fechaH >= ?mcfeclim order by id desc "  , "mwkevolNur")


	mret = SQLExec(mcon1, "select TabIntEvolParcial.* ,EIP_usuario->nomape,EIP_usuario->idcodmed  "+;
		" from TabIntEvolParcial "+;
		" where EIP_idevol = ?midevol and EIP_fechaH>= ?mcfeclim  "  , "mwkevolparc")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif
	Select mwkevolparc.* ,matriculas From mwkevolparc Left Join mwkMedicointall On idcodmed = mwkMedicointall.Id Into Cursor mwkevolparcd
	Select * From mwkevolparcd Order By EIP_fechaH Desc ,mwkevolparcd.Id Desc Into Cursor mwkevolparc
	Use In Select("mwkevolNurScorini" )
	mret = SQLExec(mcon1, "select EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario "+;
		",EIS_valor ,EIS_usuario->nomape,EIS_usuario->idcodmed from TabIntScorNur"+;
		" where EIS_idevol = ?midevol  and  EIS_tiposcore in (7,8,9,10,21) "  , "mwkevolNurScorini")  &&order by EIS_tiposcore ,id desc
	Use In Select("mwkevolNurScorfin" )
	mret = SQLExec(mcon1, "select EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario "+;
		",EIS_valor ,EIS_usuario->nomape,EIS_usuario->idcodmed from TabIntScorNur"+;
		" where EIS_idevol = ?midevol and  EIS_tiposcore not in (7,8,9,10,21) and EIS_fechaH >= ?mcfeclim  "  , "mwkevolNurScorfin")  &&order by EIS_tiposcore ,id desc

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif
	Select * From mwkevolNurScorfin Union All Select * from mwkevolNurScorini Into Cursor mwkevolNurScor
	
	Select mwkevolNurScor.* ,matriculas From mwkevolNurScor Left Join mwkMedicointall On idcodmed = mwkMedicointall.Id Into Cursor mwkevolNurScord
	Select * From mwkevolNurScord Order By EIS_tiposcore , EIS_fechaH Desc  Into Cursor mwkevolNurScor
	Use In Select("mwkevolNurScord" )
Endif
