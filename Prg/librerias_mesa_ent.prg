*!*	*********************************************************
*!*	* Libreria de procedimiento y funciones
*!*	*********************************************************
*!*	**************************
*!*	**************************

procedure EjecutoSql
parameters formulario, fecha1, fecha2

mf1 = prg_dtoc(fecha1)
mf2 = prg_dtoc(fecha2 + 1)

*!***********************
*!**Conecto los motivos
*!***********************
if formulario= 0
	mret = sqlexec(mcon1,"Select motivotext, idmotivo "+;
		"from motivos order by motivotext","mwkmotivos1")
	if mret < 0
		do log_errores with error(), message(), message(1), program(), lineno()
		messagebox("Los Motivos no estan  disponibles - Informar a Sistemas",0+64,"Conexion")
	endif
endif
*!*****************************************
*!*Connecto Personas que estan  sin atender
*!*****************************************

*!*
mTIPOPAC = "INT" && "AMB" "INT" "GUA"

if formulario = 1 or formulario = 0

	mret = sqlexec(mcon1,"SELECT	SOCIO.HoraLLegada, MOTIVOS.MotivoText,"+;
		" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
		" SOCIO.HoraAtencion,ObservaA, Horafinalizacion,"+;
		" paciente,MOTIVOS.MotivoText, operadora, OperadoraA, "+;
		" puestoatencion,  "+;
		" SOCIO.IdSocio, MOTIVOS.IdMotivo,SOCIO.PrioridadAt, "+;
		" ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl " + ;
		" FROM	SOCIO " + ;
		" inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo " + ;
		" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + ;
		" LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC " + ;
		" WHERE	SOCIO.HoraAtencion is Null AND SOCIO.Atendido=0 "+;
		" ORDER	BY SOCIO.HoraLLegada ","mwkLLegadas")

	if mret < 0
		do log_errores with error(), message(), message(1), program(), lineno()
		messagebox("No esta disponibles la lista de Esperas - Informar a Sistemas",0+64,"Conexion")
	endif

else

	mret = sqlexec(mcon1," SELECT HoraLLegada "+;
		" FROM	SOCIO where Atendido = 1 ","mwkctrldia")
	select mwkctrldia
	if reccount('mwkctrldia')>0
		calculate min(HoraLLegada) to limiteDia
	else
		limiteDia = dtot(ttod(mwkfecserv.fechahora))
	endif
	if fecha1 < fecha2
		vbusco =" AND SOCIO.HoraAtencion between ?mf1 and ?mf2 "
	else
		fecha2 = fecha1 +1
		vbusco =" AND SOCIO.HoraAtencion >= ?fecha1 and SOCIO.HoraAtencion < ?fecha2 "
	endif

	mret = sqlexec(mcon1," SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, "+;
		" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
		" SOCIO.HoraAtencion, ObservaA, Horafinalizacion,"+;
		" A.MotivoText, operadora, OperadoraA,"+;
		" puestoatencion, SOCIO.IdSocio, "+;
		" MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente,SOCIO.PrioridadAt, "+;
		" ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl " + ;
		" FROM	SOCIO " + ;
		" inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo " + ;
		" inner JOIN MOTIVOS as A ON SOCIO.IdMotivoA = A.IdMotivo " + ;
		" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + ;
		" LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC " + ;
		" WHERE	 SOCIO.Atendido = 1 "+ vbusco +;
		" ORDER	BY SOCIO.HoraLLegada ","mwkAtendidoA")
	if mret < 0
		do log_errores with error(), message(), message(1), program(), lineno()
		messagebox("No esta disponibles la lista de Atendidos - Informar a Sistemas",0+64,"Conexion")
	else
		if fecha1 < limiteDia
			mret = sqlexec(mcon1," SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, "+;
				" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
				" SOCIO.HoraAtencion, ObservaA, Horafinalizacion,"+;
				" A.MotivoText, operadora, OperadoraA,"+;
				" puestoatencion, SOCIO.IdSocio, "+;
				" MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente,SOCIO.PrioridadAt, "+;
				" ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl " + ;
				" FROM	SOCIOHIS as SOCIO " + ;
				" inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo " + ;
				" inner JOIN MOTIVOS as A ON SOCIO.IdMotivoA = A.IdMotivo " + ;
				" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + ;
				" LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC " + ;
				" WHERE	SOCIO.Atendido = 1 "+ vbusco +;
				" ORDER	BY SOCIO.HoraLLegada ","mwkAtendidoH")
			if mret < 0
				do log_errores with error(), message(), message(1), program(), lineno()
				messagebox("No esta disponible la lista de Atendidos - Informar a Sistemas",0+64,"Conexion")
			else
				select * from mwkAtendidoA;
					union;
					select * from mwkAtendidoh into cursor mwkAtendidos
			endif
		else

			select * from mwkAtendidoA;
				into cursor mwkAtendidos
		endif
	endif
endif
*************************************
*************************************
procedure GuardoMov
parameters mape, midA, mobA,mdtF,mpac,midI,mobI,mdtll,mdtA,mopA,maten,mopI,mprio
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob);
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!************************************************************************************

mret =sqlexec(mcon1," INSERT INTO SocioMod(ApellidoNombre, Atendido, "+;
	" HoraAtencion, HoraFinalizacion, HoraLLegada, "+;
	" IdMotivo, IdSocio, ObservaA, Observacion, "+;
	" OperadoraA, Operadora, puestoAtencion, IdMotivoA, "+;
	" Paciente,PrioridadAt )"+;
	" VALUES (?mape,1,?mdtA,?mdtF,?mdtll,?midI,?midsocio,"+;
	" ?mobA,?mobI,?mopA,?mopI,?maten,?midA,?mpac,?mprio)")

if mret > 0
	do log_errores with error(), message(), message(1), program(), lineno()
	return .t.
else
	return .f.
endif

*****************************************************
*****************************************************
procedure GuardoDatosSQL
parameters mape, mid, mob,mdt,mForm,meven,mpac,dq,mprio
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob);
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!*************************************************************************************
*!***********************************************
*!* Traigo el mayor Id para generar el autonumerico
*!***********************************************
mret=sqlexec(mcon1,"SELECT	MAX(IdSocio) as IdSocio FROM SOCIO","mwkrreg")

if mret < 0
	do log_errores with error(), message(), message(1), program(), lineno()
	messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
	GuardoDatosSQL = .f.
else
	mnombre = allt(mwkusuario.idusuario)
	maten   = sys(0)
	mdtF    = sp_busco_fecha_serv('DT')


	if mForm = "frmMesa1"
		midpers= nvl(mwkrreg.IdSocio,0) + 1
		mret =sqlexec(mcon1,"INSERT INTO Socio(ApellidoNombre, Atendido, "+;
			"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad)"+;
			"VALUES (?mape,0,?mdt,?mid,?midpers,?mob,?mnombre,?maten,?mprio, ?mCodEnt)")
		if mret<0
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
		mret_v =sqlexec(mcon1,"select OperadorA from Socio "+;
			" where Horallegada=?mdt and atendido = 0 "+;
			" and Operadora= ?mnombre "+;
			" and  IdSocio= ?midpers",'mwkQuienGraba')
		if mret_v<0
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
	else

		if meven=1
			if dq = 0
				mret =sqlexec(mcon1,"UPDATE Socio SET "+;
					"HoraFinalizacion=?mdtf, atendido=1, "+;
					"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
					"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
					"WHERE IdSocio= ?midSocio ")
				if mret<0
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
			else
				if dq = 8
					mObsR = mForm + ".pg.pgDatos.edtobservacion.Value"
					mObsR = &mObsR

					mret =sqlexec(mcon1,"UPDATE Socio SET "+;
						"HoraFinalizacion=?mdtf, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre, Paciente=?mpac, prioridadat = ?mprio, "+;
						"Observacion=?mobsr " + ;
						"WHERE IdSocio= ?midSocio ")
				else

					mret =sqlexec(mcon1,"UPDATE Socio SET "+;
						"HoraFinalizacion=?mdtf, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
						"WHERE IdSocio= ?midSocio ")
				endif
				if mret<0
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
			endif
		else
			mret =sqlexec(mcon1,"UPDATE Socio SET HoraAtencion=?mdt,atendido =1, "+;
				" OperadoraA= ?mnombre "+;
				" WHERE IdSocio= ?midSocio and HoraAtencion is null ")

			if mret<0
				do log_errores with error(), message(), message(1), program(), lineno()
			endif

		endif
	endif

	if mret > 0
		if meven=1
			messagebox("Se Guardaron los Datos Exitosamente!!!",0+64,"Usuario")
			GuardoDatosSQL = .t.
		else
			mret_v =sqlexec(mcon1,"select OperadorA,horaAtencion from Socio "+;
				" where OperadoraA like ?mnombre "+;
				" and  IdSocio = ?midSocio and horaAtencion is not null ",'mwkQuienGraba')
			if mret_v > 0

				if eof('mwkQuienGraba')
					messagebox("Este Paciente fue llamado por Otro Operador ",64,'Usuario')
					GuardoDatosSQL = .f.
				else
					GuardoDatosSQL = .t.
				endif
			else
				do log_errores with error(), message(), message(1), program(), lineno()
				GuardoDatosSQL = .f.
			endif
		endif
	else

		messagebox("No se Actualizaron, avisar a sistemas del siguiente error",0+64,"Usuario")
		GuardoDatosSQL = .f.
	endif
endif
return GuardoDatosSQL

procedure GuardoMot
parameters v_descriMot, midm

*********************************************************
*********************************************************
mret=sqlexec(mcon1,"insert into motivos values(?midm,?v_descriMot)")
if mret < 0
	messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
	return .f.
else
	messagebox("Se Actualizo la tabla, avisar a sistemas ",0+64,"Usuario")
	return .t.
endif


*********************************************
*********************************************

procedure ActualizoGrid
parameters V_Cursor, formulario, morden
*********************************************
* Carga la Grilla y el combo
*********************************************

if type('morden')#"C"
	morden = 'dia,horallegada'
endif
with .pg.pgdatos
	.cbomotivos.controlsource = "mwkmotivos1.IdMotivo"
	.cbomotivos.rowsource     = "mwkmotivos1.MotivoText, IdMotivo"
endwith

with .pg.pgCatalogo.Grid1
	if used(V_Cursor)
		.enabled = .t.
		if formulario = 1 or formulario = 0
			select iif(nvl(prioridadat,'')= '1','!',' ') as prioridadat, ;
				ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
				ApellidoNombre, MotivoText, Observacion, MotivoText1, ENT_descrient, ;
				ObservaA, paciente, IdSocio, IdMotivo, ;
				iif(isnull(fecpasiva_Excl),'  ','PE') as ESPE ;
				from &V_Cursor order by &morden into cursor mwkLLega

			.columncount  = 8
			.column1.header1.caption ='!'
			.column1.header1.alignment = 2
			.column1.header1.forecolor =rgb(255,0,0)
			.column1.header1.fontbold = .t.
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

		else

			select iif(nvl(prioridadat,'')= '1','!',' ') as prioridadat,;
				ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
				ApellidoNombre,MotivoText1,operadora, operadoraA,;
				ttoc(horaAtencion,2) as horaAtencion,;
				ttoc(horafinalizacion,2) as horafinalizacion,;
				MotivoText, ENT_descrient, puestoAtencion,;
				IdSocio, IdMotivo, IdMotivoA,ObservaA, Observacion, paciente, ;
				iif(isnull(fecpasiva_Excl),'  ','PE') as ESPE ;
				from &V_Cursor order by &morden into cursor mwkLLega

			.columncount  = 11
			.column1.header1.caption ='!'
			.column1.header1.alignment = 2
			.column1.header1.forecolor =rgb(255,0,0)
			.column1.header1.fontbold = .t.
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
		endif
	else
		.enabled = .f.
	endif

	select mwkLLegadas1
	go top
	*!*		.SetAll("dynamicBackColor","iif(idmotivo =15, "+;
	*!*					   	   	"RGB(255, 192, 0),RGB(255, 255, 255))", "Column")

	.setall("DynamicBackColor","iif(mwkllegadas1.idmotivo = 15, RGB(255, 192, 0), " + ;
		"Iif(mwkllegadas1.ESPE = 'PE', Rgb(217,238,208), RGB(255, 255, 255)))", "Column")

	.setall("DynamicForeColor","iif(mwkllegadas1.idmotivo = 29, RGB(255, 0, 0),RGB(0, 0, 0))", "Column")
endwith

GuardoDatosobito (mape, mid, mobN, mdtN, mForm, 1, mpacN, dq,mnrocert,mnroadm ,mTIPOPAC )

************************************************
************************************************
procedure VoyAlosDatos
parameters formu, pNo_Form
************************************************
*mueve el foco a la grilla de la primera pagina
************************************************
mdtF    = sp_busco_fecha_serv('DT')

midSocio   = mwkLLegadas1.IdSocio
mapenom    = allt(mwkLLegadas1.ApellidoNombre)
mmot_ini   = iif(isnull(mwkLLegadas1.MotivoText1),mwkLLegadas1.MotivoText,;
	mwkLLegadas1.MotivoText1)


select mwkmotivos1
go top
locate for IdMotivo = mwkLLegadas1.IdMotivo
mmotIng   = iif(found(), mwkmotivos1.MotivoText,'ERROR AVISAR A SISTEMAS')

mobsI= iif(isnull(mwkLLegadas1.Observacion),'',allt(mwkLLegadas1.Observacion))
mobsA= iif(isnull(mwkLLegadas1.ObservaA),'',allt(mwkLLegadas1.ObservaA))
mpacA= iif(isnull(mwkLLegadas1.paciente),'',allt(mwkLLegadas1.paciente))
mnrocert = 0

mDesEnti = iif(isnull(mwkLLegadas1.ENT_descrient),'',allt(mwkLLegadas1.ENT_descrient))

with .pg

	if formu = 0
		if GuardoDatosSQL(mwkLLegadas1.ApellidoNombre,;
				mwkLLegadas1.IdMotivo, mwkLLegadas1.Observacion,;
				mdtF,"frmmesa2",0,'',formu)

			.activepage = 2
			if !pNo_Form
				with .pgdatos

					.txtapenom.value         = mapenom
					.cbomotivos.displayvalue = mmot_ini
					.cbomotivos.value        = mwkLLegadas1.IdMotivo
					.txtmotivoI.value        = mmotIng
					.ChkPrior.value			 = iif(mwkLLegadas1.prioridadat ='!',1,0)
					.Txtnrocert.enabled 	 = (mwkLLegadas1.IdMotivo = 15)
					.txtSeg.enabled 		 = (mwkLLegadas1.IdMotivo = 15)
					.txtFechaentrega.enabled = (mwkLLegadas1.IdMotivo = 15)
					.edtobservacion.value = mobsI
					.edtobservaA.value    = mobsA
					.txtpaciente.value    = mpacA
					.Txtnrocert.value	 =	mnrocert
					.txtSeg.value			= ''
					.txtFechaentrega.value 	= MWKFecServ.fechaHora
					.txtentidad.value     	= mDesEnti
				endwith
			endif
		else
			.pgdatos.enabled = .f.
			.activepage = 1
		endif
	else
		.activepage = 2
		if !pNo_Form
			with .pgdatos
				.txtapenom.value         = mapenom
				.cbomotivos.displayvalue = mmot_ini
				.cbomotivos.value        = mwkLLegadas1.IdMotivo
				.txtmotivoI.value        = mmotIng
				.ChkPrior.value			 = iif(mwkLLegadas1.prioridadat ='!',1,0)
				.edtobservacion.value 	= mobsI
				.edtobservaA.value    	= mobsA
				.txtpaciente.value    	= mpacA
				.txtentidad.value     	= mDesEnti
				.Txtnrocert.value	 =	mnrocert
				.Txtnrocert.enabled 	= (mwkLLegadas1.IdMotivo = 15)
				.txtSeg.enabled 		= (mwkLLegadas1.IdMotivo = 15)
				.txtFechaentrega.enabled= (mwkLLegadas1.IdMotivo = 15)
				.txtSeg.value	= ''
				.txtFechaentrega.value = MWKFecServ.fechaHora

			endwith
		endif
	endif

endwith

************************************************
************************************************
procedure GuardoDatosobito
parameters mnrocert,mentrega,mfecentrega
************************************************
*mueve el foco a la grilla de la primera pagina
************************************************
mdtF    = sp_busco_fecha_serv('DT')

midSocio   	= mwkLLegadas1.IdSocio
mapenom    	= allt(mwkLLegadas1.ApellidoNombre)
mnroadm 	= substr(nvl(mwkLLegadas1.Observacion,space(30)),5,8)
mTIPOPAC 	= left(nvl(mwkLLegadas1.Observacion,space(30)),3)
if !empty(mnroadm)
	mret=sqlexec(mcon1,"SELECT	id from Tabpacobito where PO_admision = ?mnroadm ","mwkrreg")
	mid = mwkrreg.id
	if mret < 0
		=aerr(eros)
		messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
	else
		if reccount("mwkrreg")=0
			messagebox("ESTE OBITO NO FUE INGRESADO DESDE PISOS. NO SE EFECTUARA SEGUIMIENTO",64,"Alerta")
		else
			mret =sqlexec(mcon1,"UPDATE Tabpacobito set PO_Estado = 1 "+;
				", PO_NroCertif = ?mnrocert, PO_entregadoa = ?mentrega"+;
				", PO_FHEntrega = ?mfecentrega, PO_NroSocio = ?midSocio "+;
				" where id = ?mid ")

		endif
	endif

endif

************************************************
function sp_busco_fecha_serv(vr_tipo)

mret=sqlexec(mcon1,"SELECT {fn convert({fn TIMESTAMPADD(SQL_TSI_DAY,dias,current_timestamp)},SQL_timestamp)} as fechaHora "+;
	"from deltfec ","MWKFecServ")

if mret < 0
	if vr_tipo = 'DT'
		vr_fdia = datetime()
	else
		vr_fdia = date()
	endif
else

	if vr_tipo = 'DT'
		vr_fdia = mwkfecserv.fechahora
	else
		vr_fdia = ttod(mwkfecserv.fechahora)
	endif

endif

return vr_fdia

procedure Creo_excel
parameters url_arch_xlt, titulo, Vcursor_dat, Vcursor_nom, TitCamp, nomcamp
oleapp = createobject("excel.application")

oleapp.workbooks.open(url_arch_xlt )
oleapp.cells(2,2).value  =  titulo
i = 6
J = 0
pto='.'

sele &Vcursor_dat
go top
do while !eof(Vcursor_dat)
	sele &Vcursor_nom
	go top
	do while !eof(Vcursor_nom)
		J = J + 1

		oleapp.cells(5,J).value   = &Vcursor_nom &pto &TitCamp
		nomb =&Vcursor_nom &pto &nomcamp
		oleapp.cells(i,J).value   =&Vcursor_dat &pto &nomb


		if !eof(Vcursor_nom)
			skip 1 in &Vcursor_nom
		else
			exit
		endif

	enddo
	J = 0
	i = i + 1
	if !eof(Vcursor_dat)
		skip 1 in &Vcursor_dat
	else
		exit
	endif

enddo

oleapp.visible = .t.
