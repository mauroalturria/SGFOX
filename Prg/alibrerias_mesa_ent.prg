*!*	*********************************************************
*!*	* Libreria de procedimiento y funciones
*!*	*********************************************************
*!*	**************************
*!*	**************************

*************************************
*************************************
Procedure GuardoMov
Parameters mape, midA, mobA,mdtF,mpac,midI,mobI,mdtll,mdtA,mopA,maten,mopI,mprio
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob);
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!************************************************************************************

mret =SQLEXEC(mcon1," INSERT INTO SocioMod(ApellidoNombre, Atendido, "+;
	" HoraAtencion, HoraFinalizacion, HoraLLegada, "+;
	" IdMotivo, IdSocio, ObservaA, Observacion, "+;
	" OperadoraA, Operadora, puestoAtencion, IdMotivoA, "+;
	" Paciente,PrioridadAt )"+;
	" VALUES (?mape,1,?mdtA,?mdtF,?mdtll,?midI,?midsocio,"+;
	" ?mobA,?mobI,?mopA,?mopI,?maten,?midA,?mpac,?mprio)")

If mret > 0
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .t.
Else
	Return .f.
Endif

*****************************************************
*****************************************************
Procedure GuardoDatosSQL
Parameters mape, mid, mob,mdt,mForm,meven,mpac,dq,mprio
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob);
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!*************************************************************************************
*!***********************************************
*!* Traigo el mayor Id para generar el autonumerico
*!***********************************************
mret=SQLEXEC(mcon1,"SELECT	MAX(IdSocio) as IdSocio FROM SOCIO","mwkrreg")

If mret < 0
	Do log_errores with error(), message(), message(1), program(), lineno()
	Messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
	GuardoDatosSQL = .f.
Else
	mnombre = allt(mwkusuario.idusuario)
	maten   = sys(0)
	mdtF    = sp_busco_fecha_serv('DT')


	If mForm = "frmMesa1"
		midpers= nvl(mwkrreg.IdSocio,0) + 1
		mret =SQLEXEC(mcon1,"INSERT INTO Socio(ApellidoNombre, Atendido, "+;
			"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad)"+;
			"VALUES (?mape,0,?mdt,?mid,?midpers,?mob,?mnombre,?maten,?mprio, ?mCodEnt)")
		If mret<0
			Do log_errores with error(), message(), message(1), program(), lineno()
		Endif
		mret_v =SQLEXEC(mcon1,"select OperadorA from Socio "+;
			" where Horallegada=?mdt and atendido = 0 "+;
			" and Operadora= ?mnombre "+;
			" and  IdSocio= ?midpers",'mwkQuienGraba')
		If mret_v<0
			Do log_errores with error(), message(), message(1), program(), lineno()
		Endif
	Else

		If meven=1
			If dq = 0
				mret =SQLEXEC(mcon1,"UPDATE Socio SET "+;
					"HoraFinalizacion=?mdtf, atendido=1, "+;
					"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
					"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
					"WHERE IdSocio= ?midSocio ")
				If mret<0
					Do log_errores with error(), message(), message(1), program(), lineno()
				Endif
			Else
				If dq = 8
					mObsR = mForm + ".pg.pgDatos.edtobservacion.Value"
					mObsR = &mObsR

					mret =SQLEXEC(mcon1,"UPDATE Socio SET "+;
						"HoraFinalizacion=?mdtf, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre, Paciente=?mpac, prioridadat = ?mprio, "+;
						"Observacion=?mobsr " + ;
						"WHERE IdSocio= ?midSocio ")
				Else

					mret =SQLEXEC(mcon1,"UPDATE Socio SET "+;
						"HoraFinalizacion=?mdtf, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
						"WHERE IdSocio= ?midSocio ")
				Endif
				If mret<0
					Do log_errores with error(), message(), message(1), program(), lineno()
				Endif
			Endif
		Else
			mret =SQLEXEC(mcon1,"UPDATE Socio SET HoraAtencion=?mdt,atendido =1, "+;
				" OperadoraA= ?mnombre "+;
				" WHERE IdSocio= ?midSocio and HoraAtencion is null ")

			If mret<0
				Do log_errores with error(), message(), message(1), program(), lineno()
			Endif

		Endif
	Endif

	If mret > 0
		If meven=1
			Messagebox("Se Guardaron los Datos Exitosamente!!!",0+64,"Usuario")
			GuardoDatosSQL = .t.
		Else
			mret_v =SQLEXEC(mcon1,"select OperadorA,horaAtencion from Socio "+;
				" where OperadoraA like ?mnombre "+;
				" and  IdSocio = ?midSocio and horaAtencion is not null ",'mwkQuienGraba')
			If mret_v > 0

				If eof('mwkQuienGraba')
					Messagebox("Este Paciente fue llamado por Otro Operador ",64,'Usuario')
					GuardoDatosSQL = .f.
				Else
					GuardoDatosSQL = .t.
				Endif
			Else
				Do log_errores with error(), message(), message(1), program(), lineno()
				GuardoDatosSQL = .f.
			Endif
		Endif
	Else

		Messagebox("No se Actualizaron, avisar a sistemas del siguiente error",0+64,"Usuario")
		GuardoDatosSQL = .f.
	Endif
Endif
Return GuardoDatosSQL

Procedure GuardoMot
Parameters v_descriMot, midm

*********************************************************
*********************************************************
mret=SQLEXEC(mcon1,"insert into motivos values(?midm,?v_descriMot)")
If mret < 0
	Messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
	Return .f.
Else
	Messagebox("Se Actualizo la tabla, avisar a sistemas ",0+64,"Usuario")
	Return .t.
Endif


*********************************************
*********************************************

Procedure ActualizoGrid
Parameters mpage,V_Cursor, formulario, morden
*********************************************
* Carga la Grilla y el combo
*********************************************

If type('morden')#"C"
	morden = 'dia,horallegada'
Endif
With .pg.pgdatos
	.cbomotivos.controlsource = "mwkmotivos1.IdMotivo"
	.cbomotivos.rowsource     = "mwkmotivos1.MotivoText, IdMotivo"
Endwith
if mpage = 1
	With .pg.pgCatalogo.Grid1
		If used(V_Cursor)
			.enabled = .t.
			If formulario = 1 or formulario = 0
				Select IIF(NVL(prioridadat,'')= '1','!',' ') AS prioridadat, ;
					ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
					ApellidoNombre, MotivoText, Observacion, MotivoText1, ENT_descrient, ;
					ObservaA, paciente, IdSocio, IdMotivo, ;
					iif(isnull(fecpasiva_Excl),'  ','PE') As ESPE ;
					from &V_Cursor order by &morden into cursor mwkLLega

				.columncount  = 8
				.column1.header1.caption ='!'
				.column1.header1.Alignment = 2
				.column1.header1.ForeColor =RGB(255,0,0)
				.column1.header1.FontBold = .t.
				.column1.width = 18
				.column2.header1.caption ='Fecha'
				.column2.width = 50
				.column3.header1.caption = 'Hs Ll'
				.column3.width = 50
				.column4.header1.caption ='Apellido, Nombre'
				.column4.width = 120
				.column5.header1.caption ='Motivos'
				.column5.width = 85
				.column6.header1.caption ='Observacion'
				.column6.width = 280
				.column7.header1.caption =''
				.column7.width = 1
				.column8.header1.caption ='Entidad'
				.column8.width = 250

				.column2.header1.comment = 'dia'
				.column3.header1.comment = 'dia,horallegada'
				.column4.header1.comment = 'ApellidoNombre'
				.column5.header1.comment = 'MotivoText'
				.column6.header1.comment = 'Observacion'
				.column7.header1.comment = 'dia'
				.column8.header1.comment = 'Entidad'

				.recordsource ="Select * from mwkLLega " +;
					" into cursor mwkLLegadas1"
				.column3.controlsource	= "mwkllegadas1.horallegada"

			Else

				Select IIF(NVL(prioridadat,'')= '1','!',' ') AS prioridadat,;
					ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
					ApellidoNombre,MotivoText1,operadora, operadoraA,;
					ttoc(horaAtencion,2) as horaAtencion,;
					ttoc(horafinalizacion,2) as horafinalizacion,;
					MotivoText, ENT_descrient, puestoAtencion,;
					IdSocio, IdMotivo, IdMotivoA,ObservaA, Observacion, paciente, ;
					iif(isnull(fecpasiva_Excl),'  ','PE') As ESPE ;
					from &V_Cursor order by &morden into cursor mwkLLega

				.columncount  = 11
				.column1.header1.caption ='!'
				.column1.header1.Alignment = 2
				.column1.header1.ForeColor =RGB(255,0,0)
				.column1.header1.FontBold = .t.
				.column1.width = 18
				.column2.header1.caption ='Fecha'
				.column2.width = 50
				.column3.header1.caption ='Hs Ll'
				.column3.width = 50
				.column4.header1.caption ='Apellido, Nombre'
				.column4.width = 150
				.column5.header1.caption ='Motivo Atendido'
				.column5.width = 85
				.column6.header1.caption ='Operador Ingreso'
				.column6.width = 50
				.column7.header1.caption ='Operador Atendio'
				.column7.width = 50
				.column8.header1.caption ='Hora Atendido'
				.column8.width = 50
				.column9.header1.caption ='Hora finalizacion'
				.column9.width = 50
				.column10.header1.caption ='Motivo Ingreso'
				.column10.width = 60
				.column11.header1.caption ='Entidad'
				.column11.width = 250

				.column1.header1.comment = 'Prioridad'
				.column2.header1.comment = 'dia'
				.column3.header1.comment = 'dia,horallegada'
				.column4.header1.comment = 'ApellidoNombre'
				.column5.header1.comment = 'MotivoText1'
				.column6.header1.comment = 'operadora'
				.column7.header1.comment = 'operadoraA'
				.column8.header1.comment = 'horaAtencion'
				.column9.header1.comment = 'horafinalizacion'
				.column10.header1.comment= 'MotivoText'
				.column11.header1.comment= 'Entidad'

				.recordsource = "Select * from mwkLLega order by &morden "+;
					"into cursor mwkLLegadas1 "

				.column3.controlsource	= "mwkllegadas1.horallegada"
			Endif
		Else
			.enabled = .f.
		Endif

		Select mwkLLegadas1
		Go top
	*!*		.SetAll("dynamicBackColor","iif(idmotivo =15, "+;
	*!*					   	   	"RGB(255, 192, 0),RGB(255, 255, 255))", "Column")

		.SetAll("DynamicBackColor","iif(mwkllegadas1.idmotivo = 57, RGB(0,64,128), iif(mwkllegadas1.idmotivo = 15, RGB(255, 192, 0), " + ;
			"Iif(mwkllegadas1.ESPE = 'PE', Rgb(217,238,208), RGB(255, 255, 255))))", "Column")

		.SetAll("DynamicForeColor","iif(mwkllegadas1.idmotivo = 29, RGB(255, 0, 0),iif(mwkllegadas1.idmotivo = 57, RGB(255, 255, 255),RGB(0, 0, 0)))", "Column")
	Endwith
else
	With .pg.PGCambios.Grid1
		If used(V_Cursor)
			.enabled = .t.
			If formulario = 1 or formulario = 0
				Select IIF(NVL(prioridadat,'')= '1','!',' ') AS prioridadat, ;
					ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
					ApellidoNombre, MotivoText, Observacion, MotivoText1, ENT_descrient, ;
					ObservaA, paciente, IdSocio, IdMotivo, ;
					iif(isnull(fecpasiva_Excl),'  ','PE') As ESPE ;
					from &V_Cursor order by &morden into cursor mwkLLega

				.columncount  = 8
				.column1.header1.caption ='!'
				.column1.header1.Alignment = 2
				.column1.header1.ForeColor =RGB(255,0,0)
				.column1.header1.FontBold = .t.
				.column1.width = 18
				.column2.header1.caption ='Fecha'
				.column2.width = 50
				.column3.header1.caption = 'Hs Ll'
				.column3.width = 50
				.column4.header1.caption ='Apellido, Nombre'
				.column4.width = 120
				.column5.header1.caption ='Motivos'
				.column5.width = 85
				.column6.header1.caption ='Observacion'
				.column6.width = 280
				.column7.header1.caption =''
				.column7.width = 1
				.column8.header1.caption ='Entidad'
				.column8.width = 250

				.column2.header1.comment = 'dia'
				.column3.header1.comment = 'dia,horallegada'
				.column4.header1.comment = 'ApellidoNombre'
				.column5.header1.comment = 'MotivoText'
				.column6.header1.comment = 'Observacion'
				.column7.header1.comment = 'dia'
				.column8.header1.comment = 'Entidad'

				.recordsource ="Select * from mwkLLega " +;
					" into cursor mwkLLegadas1"
				.column3.controlsource	= "mwkllegadas1.horallegada"

			Else

				Select IIF(NVL(prioridadat,'')= '1','!',' ') AS prioridadat,;
					ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
					ApellidoNombre,MotivoText1,operadora, operadoraA,;
					ttoc(horaAtencion,2) as horaAtencion,;
					ttoc(horafinalizacion,2) as horafinalizacion,;
					MotivoText, ENT_descrient, puestoAtencion,;
					IdSocio, IdMotivo, IdMotivoA,ObservaA, Observacion, paciente, ;
					iif(isnull(fecpasiva_Excl),'  ','PE') As ESPE ;
					from &V_Cursor order by &morden into cursor mwkLLega

				.columncount  = 11
				.column1.header1.caption ='!'
				.column1.header1.Alignment = 2
				.column1.header1.ForeColor =RGB(255,0,0)
				.column1.header1.FontBold = .t.
				.column1.width = 18
				.column2.header1.caption ='Fecha'
				.column2.width = 50
				.column3.header1.caption ='Hs Ll'
				.column3.width = 50
				.column4.header1.caption ='Apellido, Nombre'
				.column4.width = 150
				.column5.header1.caption ='Motivo Atendido'
				.column5.width = 85
				.column6.header1.caption ='Operador Ingreso'
				.column6.width = 50
				.column7.header1.caption ='Operador Atendio'
				.column7.width = 50
				.column8.header1.caption ='Hora Atendido'
				.column8.width = 50
				.column9.header1.caption ='Hora finalizacion'
				.column9.width = 50
				.column10.header1.caption ='Motivo Ingreso'
				.column10.width = 60
				.column11.header1.caption ='Entidad'
				.column11.width = 250

				.column1.header1.comment = 'Prioridad'
				.column2.header1.comment = 'dia'
				.column3.header1.comment = 'dia,horallegada'
				.column4.header1.comment = 'ApellidoNombre'
				.column5.header1.comment = 'MotivoText1'
				.column6.header1.comment = 'operadora'
				.column7.header1.comment = 'operadoraA'
				.column8.header1.comment = 'horaAtencion'
				.column9.header1.comment = 'horafinalizacion'
				.column10.header1.comment= 'MotivoText'
				.column11.header1.comment= 'Entidad'

				.recordsource = "Select * from mwkLLega order by &morden "+;
					"into cursor mwkLLegadas1 "

				.column3.controlsource	= "mwkllegadas1.horallegada"
			Endif
		Else
			.enabled = .f.
		Endif

		Select mwkLLegadas1
		Go top
	*!*		.SetAll("dynamicBackColor","iif(idmotivo =15, "+;
	*!*					   	   	"RGB(255, 192, 0),RGB(255, 255, 255))", "Column")

		.SetAll("DynamicBackColor","iif(mwkllegadas1.idmotivo = 57, RGB(0,64,128), iif(mwkllegadas1.idmotivo = 15, RGB(255, 192, 0), " + ;
			"Iif(mwkllegadas1.ESPE = 'PE', Rgb(217,238,208), RGB(255, 255, 255))))", "Column")

		.SetAll("DynamicForeColor","iif(mwkllegadas1.idmotivo = 29, RGB(255, 0, 0),iif(mwkllegadas1.idmotivo = 57, RGB(255, 255, 255),RGB(0, 0, 0)))", "Column")
	Endwith
endif
*GuardoDatosobito (mape, mid, mobN, mdtN, mForm, 1, mpacN, dq,mnrocert,mnroadm ,mTIPOPAC )

************************************************
************************************************
Procedure VoyAlosDatos
Parameters formu, pNo_Form,npage 
************************************************
*mueve el foco a la grilla de la primera pagina
************************************************
mdtF    = sp_busco_fecha_serv('DT')

midSocio   = mwkLLegadas1.IdSocio
mapenom    = allt(mwkLLegadas1.ApellidoNombre)
mmot_ini   = iif(isnull(mwkLLegadas1.MotivoText1),mwkLLegadas1.MotivoText,;
	mwkLLegadas1.MotivoText1)


Select mwkmotivos1
Go top
Locate for IdMotivo = mwkLLegadas1.IdMotivo
mmotIng   = iif(found(), mwkmotivos1.MotivoText,'ERROR AVISAR A SISTEMAS')

mobsI= iif(isnull(mwkLLegadas1.Observacion),'',allt(mwkLLegadas1.Observacion))
mobsA= iif(isnull(mwkLLegadas1.ObservaA),'',allt(mwkLLegadas1.ObservaA))
mpacA= iif(isnull(mwkLLegadas1.paciente),'',allt(mwkLLegadas1.paciente))
mnrocert = 0
if inlist(mwkLLegadas1.IdMotivo,2,15)
	mpacA = substr(nvl(mwkLLegadas1.Observacion,space(30)),5,8)
	mbusco = " PO_admision = '"+mpacA +"' and PO_FechaObito>= '"+ prg_dtoc(mwkLLegadas1.dia)+"' "
	Do sp_busco_denuncia_ob With iif(mwkLLegadas1.IdMotivo=15,1,2),mbusco
else
	Do sp_busco_denuncia_ob With 1," Tabpacobito.id = 1 "
endif

Select mwkmotivos1
mDesEnti = iif(isnull(mwkLLegadas1.ENT_descrient),'',allt(mwkLLegadas1.ENT_descrient))

With .pg

	If formu = 0
		If GuardoDatosSQL(mwkLLegadas1.ApellidoNombre,;
				mwkLLegadas1.IdMotivo, mwkLLegadas1.Observacion,;
				mdtF,"frmmesa2",0,'',formu)

			.activepage = 2
			If !pNo_Form
				With .pgdatos

					.txtapenom.value         = mapenom
					.cbomotivos.displayvalue = mmot_ini
					.cbomotivos.value        = mwkLLegadas1.IdMotivo
					.txtmotivoI.value        = mmotIng
					.ChkPrior.value			 = IIF(mwkLLegadas1.prioridadat ='!',1,0)
					.Txtnrocert.enabled 	 = (mwkLLegadas1.IdMotivo = 15)
					.txtSeg.enabled 		 = (mwkLLegadas1.IdMotivo = 15)
					.txtFechaentrega.enabled = (mwkLLegadas1.IdMotivo = 15)
					.edtobservacion.value = mobsI
					.edtobservaA.value    = mobsA
					.txtpaciente.value    = mpacA
					.Txtnrocert.value	 =	mnrocert
					.txtSeg.value			= ''
					.txtFechaentrega.value 	= MWKFecServ.fechaHora
					.txtentidad.Value     	= mDesEnti
				Endwith
			Endif
		Else
			.pgdatos.enabled = .f.
			.activepage = 1
		Endif
	Else
		.activepage = 2
		If !pNo_Form
			With .pgdatos
				.txtapenom.value         = mapenom
*				.cbomotivos.displayvalue = mmot_ini
*				.cbomotivos.value        = mwkLLegadas1.IdMotivo
				.txtmotivoI.value        = mmotIng
				.ChkPrior.value			 = IIF(mwkLLegadas1.prioridadat ='!',1,0)
				.edtobservacion.value 	= mobsI
				.edtobservaA.value    	= mobsA
				.txtpaciente.value    	= mpacA
				.txtentidad.Value     	= mDesEnti
				.Txtnrocert.value	 =	mnrocert
				.Txtnrocert.enabled 	= (mwkLLegadas1.IdMotivo = 15)
				.txtSeg.enabled 		= (mwkLLegadas1.IdMotivo = 15)
				.txtFechaentrega.enabled= (mwkLLegadas1.IdMotivo = 15)
				.txtSeg.value	= ''
				.txtFechaentrega.value = MWKFecServ.fechaHora

			Endwith
		Endif
	Endif

Endwith

************************************************
************************************************
Procedure GuardoDatosobito
Parameters mnrocert,mentrega,mfecentrega
************************************************
*mueve el foco a la grilla de la primera pagina
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
		mret=SQLEXEC(mcon1,"SELECT	id from Tabpacobito where PO_admision = ?mnroadm ","mwkrreg")
		mid = mwkrreg.id
	endif
	If mret < 0
		=aerr(eros)
		Messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
	Else
		If reccount("mwkrreg")=0 and reccount("mwkobito")= 0
			Messagebox("ESTE OBITO NO FUE INGRESADO DESDE PISOS. NO SE EFECTUARA SEGUIMIENTO",64,"Alerta")
		Else
			mret =SQLEXEC(mcon1,"UPDATE Tabpacobito set PO_Estado = ?mestado  "+;
				", PO_NroCertif = ?mnrocert, PO_entregadoa = ?mentrega"+;
				", PO_FHEntrega = ?mfecentrega, PO_NroSocio = ?midSocio "+;
				" where id = ?mid ")

		Endif
	Endif


************************************************
Function sp_busco_fecha_serv(vr_tipo)

mret=SQLEXEC(mcon1,"SELECT {fn convert({fn TIMESTAMPADD(SQL_TSI_DAY,dias,current_timestamp)},SQL_timestamp)} as fechaHora "+;
	"from deltfec ","MWKFecServ")

If mret < 0
	If vr_tipo = 'DT'
		vr_fdia = datetime()
	Else
		vr_fdia = date()
	Endif
Else

	If vr_tipo = 'DT'
		vr_fdia = mwkfecserv.fechahora
	Else
		vr_fdia = ttod(mwkfecserv.fechahora)
	Endif

Endif

Return vr_fdia

Procedure Creo_excel
Parameters url_arch_xlt, titulo, Vcursor_dat, Vcursor_nom, TitCamp, nomcamp
oleapp = createobject("excel.application")

oleapp.workbooks.open(url_arch_xlt )
oleapp.cells(2,2).value  =  titulo
i = 6
J = 0
pto='.'

Sele &Vcursor_dat
Go top
Do while !eof(Vcursor_dat)
	Sele &Vcursor_nom
	Go top
	Do while !eof(Vcursor_nom)
		J = J + 1

		oleapp.cells(5,J).value   = &Vcursor_nom &pto &TitCamp
		nomb =&Vcursor_nom &pto &nomcamp
		oleapp.cells(i,J).value   =&Vcursor_dat &pto &nomb


		If !eof(Vcursor_nom)
			Skip 1 in &Vcursor_nom
		Else
			Exit
		Endif

	Enddo
	J = 0
	i = i + 1
	If !eof(Vcursor_dat)
		Skip 1 in &Vcursor_dat
	Else
		Exit
	Endif

Enddo

oleapp.visible = .t.
