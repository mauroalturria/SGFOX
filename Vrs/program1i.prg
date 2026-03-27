PROCEDURE exportaexcel
PARAMETERS oleapp,aCampos

LOCAL nI 
LOCAL nCol
LOCAL xValor
LOCAL cFile2Xlt

IF thisform.lhistorial
   cFile2Xlt = Alltrim(zzvolumen)+"\qepd1a1\xlt\MesaEntradaH.xlt"
ELSE
   cFile2Xlt = Alltrim(zzvolumen)+"\qepd1a1\xlt\MesaEntrada.xlt"
ENDIF

oleapp.workbooks.open(cFile2Xlt)

SELECT mwkllega
GO top
									 
oleapp.cells(4,2).value = "Período del " + Dtoc(thisform.txtfechad.value) +;
					 " al " + Dtoc(thisform.txtfechah.value)


**Recorremos el cursor.
nI = 6
SCAN all
    Wait "CARGANDO PLANILLA DE EXCEL"  + Str(Recno(), 5) Windows Nowait
*!*	    oleapp.cells(nI,2).value	= DIA
*!*		oleapp.cells(ni,3).value	= HORALLEGADA
*!*		oleapp.cells(ni,4).value	= alltrim(APELLIDONOMBRE)
*!*		oleapp.cells(ni,5).value	= STRTRAN(STRTRAN(alltrim(MOTIVOTEXT),CHR(13),""),CHR(10),"")
*!*		oleapp.cells(ni,6).value    = STRTRAN(STRTRAN(alltrim(OBSERVACION),CHR(13),""),CHR(10),"")
*!*		oleapp.cells(ni,7).value	= STRTRAN(STRTRAN(alltrim(MOTIVOTEXT1),CHR(13),""),CHR(10),"")
*!*		oleapp.cells(ni,8).value	= STRTRAN(STRTRAN(alltrim(ENT_DESCRIENT),CHR(13),""),CHR(10),"")
    FOR nCol = 1 TO ALEN(aCampos,0)
        xValor = mwkllega.&aCampos(nCol).
        IF VARTYPE(xValor) <> "X"
           IF VARTYPE(xValor) == "C"
              xValor = STRTRAN(STRTRAN(alltrim(mwkllega.&aCampos(nCol).),CHR(13),""),CHR(10),"")
           ENDIF
        Endif   
        oleapp.cells(ni,nCol+1).value	= xValor           
    NEXT
    
    nI = nI + 1
    
ENDSCAN

WAIT clear

oleapp.visible = .T.

ENDPROC
PROCEDURE exportaooffice
LPARAMETERS aCampos

LOCAL nI 
LOCAL nCol
LOCAL xValor
LOCAL cFile2Xlt

IF thisform.lHistorial
   cFile2Xlt = Alltrim(zzvolumen)+"\qepd1a1\xlt\MesaEntradaH.xlt"
ELSE
   cFile2Xlt = Alltrim(zzvolumen)+"\qepd1a1\xlt\MesaEntrada.xlt"
ENDIF
   
WITH thisform

If .CUSOPENOFFICE1.OOoIsInstalled()
	If File(cFile2Xls)
		Copy FILE(cFile2Xls) To "c:\temp\informes\MesaEntrada.xlt"

		*Do sp_control_aplicacion With "OpenOffice.org Calc"		
		mofarch = "c:/temp/informes/MesaEntrada.xlt"
		oDoc = .Cusopenoffice1.OOoOpenFile( mofarch,.T. )
		Local oSheet
		oSheet = oDoc.getSheets().GetByIndex( 0 )
		mfil = 3
		oSheet.getCellByPosition( 01, mfil ).setFormula("Período del " + Dtoc(thisform.txtfechad.value) +;
					 " al " + Dtoc(thisform.txtfechah.value))			
					 
		mfil = mfil + 2

		SELECT mwkLLega
		GO top		
		
		Scan
			Wait "CARGANDO ARCHIVO OPEN OFFICE" + Str(Recno(), 5) Windows Nowait
*!*				oSheet.getCellByPosition( 01, mfil ).setValue(DIA)
*!*				oSheet.getCellByPosition( 02, mfil ).setString(HORALLEGADA)
*!*				oSheet.getCellByPosition( 03, mfil ).setString(APELLIDONOMBRE)
*!*				oSheet.getCellByPosition( 04, mfil ).setString(STRTRAN(STRTRAN(alltrim(MOTIVOTEXT),CHR(13),""),CHR(10),""))
*!*				oSheet.getCellByPosition( 05, mfil ).setString(STRTRAN(STRTRAN(alltrim(OBSERVACION),CHR(13),""),CHR(10),""))
*!*				oSheet.getCellByPosition( 06, mfil ).setString(STRTRAN(STRTRAN(alltrim(MOTIVOTEXT1),CHR(13),""),CHR(10),""))
*!*				oSheet.getCellByPosition( 07, mfil ).setString(NVL(STRTRAN(STRTRAN(alltrim(ENT_DESCRIENT),CHR(13),""),CHR(10),""),""))

            FOR nCol = 1 TO ALEN(aCampos,0)
                xValor = mwkllega.&aCampos(nCol).
                IF VARTYPE(xValor) <> "X"
                   IF VARTYPE(xValor) == "C"
                      xValor = STRTRAN(STRTRAN(alltrim(mwkllega.&aCampos(nCol).),CHR(13),""),CHR(10),"")
                      oSheet.getCellByPosition( nCol, mfil ).setString(xValor)
                   ELSE
                      oSheet.getCellByPosition( nCol, mfil ).setValue(xValor)
                  ENDIF
                ENDIF   
            NEXT
            
			mfil = mfil + 1
			
		Endscan
		.Cusopenoffice1.Visible(.T.)
		Release oDoc
	Else
		Messagebox("PLANILLA OPENOFFICE NO UBICADA"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif
Else
	Messagebox("OPENOFFICE NO ESTA INSTALADO"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
ENDIF

ENDWITH

ENDPROC
PROCEDURE cargagrid
parameters npage, V_Cursor, formulario, morden
*********************************************
* Carga la Grilla y el combo
*********************************************

if type('morden')#"C"
	morden = 'dia,horallegada'
endif
with .pg
	if npage= 1
		with  .pgCatalogo.Grid1
			if used(V_Cursor)
				.enabled = .t.
				if formulario = 1 or formulario = 0
					select iif(nvl(prioridadat,'')= '1','!',' ') as prioridadat, ;
						ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
						ApellidoNombre, MotivoText, Observacion, MotivoText1, ENT_descrient, ;
						ObservaA, paciente, IdSocio, IdMotivo, ;
						iif(isnull(fecpasiva_Excl),'  ','PE') as ESPE ;
						from &V_Cursor where !inlist(idmotivo,66,58) order by &morden into cursor mwkLLega

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
					.parent.txtcant.Value = Reccount('mwkllegadas1')

				else

					select iif(nvl(prioridadat,'')= '1','!',' ') as prioridadat,;
						ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
						ApellidoNombre,MotivoText1,operadora, operadoraA,;
						ttoc(horaAtencion,2) as horaAtencion,;
						ttoc(horafinalizacion,2) as horafinalizacion,;
						MotivoText, ENT_descrient, puestoAtencion,;
						IdSocio, IdMotivo, IdMotivoA,ObservaA, Observacion, paciente, ;
						iif(isnull(fecpasiva_Excl),'  ','PE') as ESPE ;
						from &V_Cursor where !inlist(idmotivo,66,58) order by &morden into cursor mwkLLega

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
					.parent.txtcant.Value = Reccount('mwkllegadas1')

				endif
			else
				.enabled = .f.
			endif

			select mwkLLegadas1
			go top
*!*		.SetAll("dynamicBackColor","iif(idmotivo =15, "+;
*!*					   	   	"RGB(255, 192, 0),RGB(255, 255, 255))", "Column")

			.setall("DynamicBackColor","iif(mwkllegadas1.idmotivo = 57, RGB(9,132,255), iif(mwkllegadas1.idmotivo = 15, RGB(255,179,102), " + ;
				"iif(inlist(mwkllegadas1.idmotivo,66,58), Rgb(255,204,204), iif(mwkllegadas1.ESPE = 'PE', Rgb(217,238,208), RGB(255, 255, 255)))))", "Column")

			.setall("DynamicForeColor","iif(mwkllegadas1.idmotivo = 29, RGB(255, 0, 0),iif(mwkllegadas1.idmotivo = 57, RGB(255, 255, 255),RGB(0, 0, 0)))", "Column")
		endwith
	else
		with .PGCambios.Grid1
			if used(V_Cursor)
				.enabled = .t.
				if formulario = 1 or formulario = 0
					select iif(nvl(prioridadat,'')= '1','!',' ') as prioridadat, ;
						ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
						ApellidoNombre, MotivoText, Observacion, MotivoText1, ENT_descrient, ;
						ObservaA, paciente, IdSocio, IdMotivo, ;
						iif(isnull(fecpasiva_Excl),'  ','PE') as ESPE ;
						from &V_Cursor where inlist(idmotivo,66,58) order by &morden into cursor mwkLLegacc

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

					.recordsource ="Select * from mwkLLegacc " +;
						" into cursor mwkLLegadascc1"
					.column3.controlsource	= "mwkllegadascc1.horallegada"
					.parent.txtcant.Value = Reccount('mwkllegadascc1')

				else

					select iif(nvl(prioridadat,'')= '1','!',' ') as prioridadat,;
						ttod(HoraLLegada) as dia, ttoc(HoraLLegada,2) as HoraLLegada,;
						ApellidoNombre,MotivoText1,operadora, operadoraA,;
						ttoc(horaAtencion,2) as horaAtencion,;
						ttoc(horafinalizacion,2) as horafinalizacion,;
						MotivoText, ENT_descrient, puestoAtencion,;
						IdSocio, IdMotivo, IdMotivoA,ObservaA, Observacion, paciente, ;
						iif(isnull(fecpasiva_Excl),'  ','PE') as ESPE ;
						from &V_Cursor where inlist(idmotivo,66,58)  order by &morden into cursor mwkLLegacc

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

					.recordsource = "Select * from mwkLLegacc order by &morden "+;
						"into cursor mwkLLegadascc1 "

					.column3.controlsource	= "mwkllegadascc1.horallegada"
					.parent.txtcant.Value = Reccount('mwkllegadascc1')
				endif
			else
				.enabled = .f.
			endif

			select mwkLLegadas1
			go top
*!*		.SetAll("dynamicBackColor","iif(idmotivo =15, "+;
*!*					   	   	"RGB(255, 192, 0),RGB(255, 255, 255))", "Column")

			.setall("DynamicBackColor","iif(mwkllegadascc1.ESPE = 'PE', Rgb(217,238,208), RGB(255, 255, 255) )", "Column")
		endwith
	endif
*GuardoDatosobito (mape, mid, mobN, mdtN, mForm, 1, mpacN, dq,mnrocert,mnroadm ,mTIPOPAC )
endwith

************************************************

ENDPROC
PROCEDURE Unload
With This
	If .Disconnec
		Do sp_desconexion WITH .Name
	EndIf 
Endwith 

Release mhoy

If Used('Mwkllegadas1')
	Sele Mwkllegadas1
	Use
Endif
If Used('Mwkllegadas')
	Sele Mwkllegadas
	Use
Endif
If Used('Mwkllega')
	Sele Mwkllega
	Use
Endif
If Used('MwkAtendidos')
	Sele MwkAtendidos
	Use
Endif
If Used('Mwkmotivos1')
	Sele Mwkmotivos1
	Use
ENDIF
 
ENDPROC
PROCEDURE Init
public mcantexe,mhoy
mcantexe = 0

with thisform

	if !used("mwkserver1")
		do sp_conexion
		.Disconnec = .t.
	endif


	.corden = "dia, horallegada"
	.cmdsave.enabled  =(type('m' + alltrim(thisform.name) + 'cmdsave')  = 'U')
	.cmdmodif.enabled =(type('m' + alltrim(thisform.name) + 'cmdmodif') = 'U')
	mhoy = sp_busco_fecha_serv('DD')

	do sp_busco_socio  with 0,,'mwkLLegadas', mhoy, mhoy

	do sp_tablas_mesa
	select descripcion, SectorAgrup  from mwkSecagruppanel;
		group by  SectorAgrup  order by descripcion into cursor mwksectores

	with .pg
		.pgCatalogo.grid1.recordsource = ""
		.pgCambios.grid1.recordsource = ""
		with .pgdatos
			.enabled =.f.
			.cbomotivos.controlsource = "mwkmotivos1.IdMotivo"
			.cbomotivos.rowsource     = "mwkmotivos1.MotivoText, IdMotivo"
		endwith
		with .pgCambios
			.enabled =.f.
			.cbosectores.controlsource = "mwksectores.SectorAgrup"
			.cbosectores.rowsource     = "mwksectores.descripcion, SectorAgrup"
		endwith
		.activepage = 1
	endwith

	.txtfechad.value = mhoy
	.txtfechah.value = mhoy

	.cargagrid(1,'mwkLLegadas', 0, .corden)
	.cargagrid(2,'mwkLLegadas', 0, .corden)

	.mcursor = 'mwkLLegadas'
	.mformu  = 0
	.timer1.enabled = .t.

endwith

ENDPROC
PROCEDURE Image1.Click
*!*	ThisForm.timer1.Enabled=.f.
*!*	Set step on	
ENDPROC
PROCEDURE cmdmodif.Init
with thisform
	if type('m' + alltrim(thisform.name) + 'cmdmodif') = 'U'  && INV
		.cmdmodif.enabled = .F. 
	else
*		.cmdmodif.enabled = .T.
	endif
endwith
ENDPROC
PROCEDURE cmdmodif.Click
With ThisForm
	If .mformu = 0 Or .mformu = 8
		If .PG.PgDatos.EdtObservacion.ReadOnly
			.PG.PgDatos.EdtObservacion.ReadOnly = .f.
			.mformu = 8 && Solo para edicion
		Else
			.PG.PgDatos.EdtObservacion.ReadOnly = .t.
			.mformu = 0 && Comun
			.PG.PgDatos.EdtObservacion.SetFocus()
		Endif 	
	Endif 	
Endwith 	
ENDPROC
PROCEDURE cmdundo.Click
With Thisform 
    .lHistorial = .f.  
	.timer1.enabled = .f.
	.cmdsave.Enabled    = (Type('m' + Alltrim(Thisform.Name) + 'cmdsave') = 'U') And .pg.ActivePage = 2
	.pg.pgdatos.Enabled = .F.
	.pg.pgCatalogo.label3.Caption = 'Cantidad De Personas En Espera:'

	Sele mwkLLegadas
	Go Top
	.cargagrid('mwkLLegadas',0, .corden)
	.mcursor = 'mwkLLegadas'
	.mformu  = 0
	.pg.pgCatalogo.SetFocus()
	.timer1.reset()
	.timer1.Enabled = .t.
	.timer1.timer()
	.cmdexcel.enabled = .t.
Endwith
ENDPROC
PROCEDURE cmdsave.KeyPress
LPARAMETERS nKeyCode, nShiftAltCtrl
if nkeyCode = 13
	thisform.cmdsave.click()
endif	
ENDPROC
PROCEDURE cmdsave.Click
With Thisform

	If .pg.pgdatos.edtObservacion.ReadOnly
		.timer1.enabled = .f.
		Do VoyAlosDatos With .mformu, .t. 
		.timer1.reset()
		.timer1.Enabled = .t.
	Endif 

	dq = .mformu
	If .mformu = 3
***		set step on  Esta opcion no se usa nunca!!!!
		With .pg.pgdatos
			Sele mwkllegadas1

			mapenom  = Allt(mwkllegadas1.ApellidoNombre)
			mdFA     = mwkllegadas1.horaAtencion
			mdHF     = mwkllegadas1.horafinalizacion
			mdHLL    = mwkllegadas1.horaLlegada
			mmotIng  = mwkllegadas1.IdMotivo
			midSocio = mwkllegadas1.IdSocio
			mobsA    = Iif(Isnull(mwkllegadas1.ObservaA),'',Allt(mwkllegadas1.ObservaA))
			mobsI    = Iif(Isnull(mwkllegadas1.Observacion),'',Allt(mwkllegadas1.Observacion))
			mopI     = Allt(mwkllegadas1.Operadora)
			mopA     = Allt(mwkllegadas1.OperadoraA)
			mpuesA   = Allt(mwkllegadas1.puestoAtencion)
			mmotA    = Iif(Nvl(mwkllegadas1.idMotivoA,0)=0,mmotIng ,mwkllegadas1.idMotivoA)
			mpacA    = Iif(Isnull(mwkllegadas1.paciente),'',Allt(mwkllegadas1.paciente))
			mnrocert = 0
			mquien	 = ''
			mhoraret = ctod("  /  /  ")

		Endwith

		mok = GuardoMov (mapenom,mmotA,mobsA,mdFA,mpacA,mmotIng,mobsI,mdHLL,mdFA,mopA,mpuesA,mopI)

	Else
		If .mformu = 8 && Solo para Edicion
			
			&& Guardo los Cambios
			With .pg.pgdatos
				mape  = Iif(Isnull(.txtapeNom.Value),'',Alltrim(.txtapeNom.Value))
				mid   = .cbomotivos.Value
				mobN  = Iif(Isnull(.edtobservaA.Value),'',Alltrim(.edtobservaA.Value))
				mForm = "frmMesa2"
				mpacN = Iif(Isnull(.txtpaciente.Value),'',Allt(.txtpaciente.Value))
				mdtN  = sp_busco_fecha_serv('DT')
				mnrocert = .Txtnrocert.value 					
				mquien	 = .txtSeg.value 					 
				mhoraret = .txtFechaentrega.value 					 
				If GuardoDatosSQL (mape, mid, mobN, mdtN, mForm, 1, mpacN, dq)
					lobito = .f.
					if used("mwkobito")
						lobito =(reccount("mwkobito")>0 )
					else 
						lobito = (mnrocert >0)
					endif
					if lobito
						GuardoDatosobito (mnrocert,mquien,mhoraret )
					endif
					.txtapeNom.Value = ""
					.cbomotivos.Value = ""
					.edtobservacion.Value = ""
					.txtpaciente.Value = ""
					.edtobservaA.Value = ""
					.Txtnrocert.Value = 0
					.txtSeg.value	= '' 					 
					.txtFechaentrega.value = MWKFecServ.fechaHora
				Else
					.cbomotivos.SetFocus()
					&& Los Datos no se guardaron !!! ????
					Return .f.
				Endif
			Endwith
			&& 
			.PG.PgDatos.EdtObservacion.ReadOnly = .T.
			.timer1.reset()
			.timer1.Enabled = .t.
			.mformu = 0
			mok = .F.
		Else
		
			&& 0
			
			&& 
		
		
			mok = .T.
		Endif 	
	Endif

	If mok
		With .pg.pgdatos
			mape  = Iif(Isnull(.txtapeNom.Value),'',Alltrim(.txtapeNom.Value))
			mid   = .cbomotivos.Value
			mobN  = Iif(Isnull(.edtobservaA.Value),'',Alltrim(.edtobservaA.Value))
			mForm = "frmMesa2"
			mpacN = Iif(Isnull(.txtpaciente.Value),'',Allt(.txtpaciente.Value))
			mdtN  = sp_busco_fecha_serv('DT')
			mnrocert = .Txtnrocert.Value 
			mquien	 = .txtSeg.value 					 
			mhoraret = .txtFechaentrega.value 					 
			If GuardoDatosSQL (mape, mid, mobN,mdtN,mForm,1,mpacN,dq)
				lobito = .f.
				if used("mwkobito")
					lobito =(reccount("mwkobito")>0 )
				else 
					lobito = (mnrocert >0)
				endif
				if lobito
					GuardoDatosobito (mnrocert,mquien,mhoraret )
				endif
				.txtapeNom.Value =""
				.cbomotivos.Value =""
				.edtobservacion.Value =""
				.txtpaciente.Value=''
				.Txtnrocert.Value = 0
				.edtobservaA.Value =""
				.txtSeg.value = ''					 
				.txtFechaentrega.value = MWKFecServ.fechaHora

			Else
				.cbomotivos.SetFocus()
			Endif
		Endwith
	Endif

	.pg.pgcatalogo.Enabled 	= .T.
	.pg.pgdatos.Enabled 	= .F.
	.pg.ActivePage	= 1
	.cmdsave.Enabled    	= (Type('m' + Alltrim(Thisform.Name) + 'cmdsave') = 'U') 
	.cmdmodif.enabled	= (type('m' + alltrim(thisform.name) + 'cmdmodif') = 'U')
	.cmdclose.Enabled   	= .T.
	.cmdundo.Enabled    	= .T.
	.cmdfind.Enabled    	= .T.
	.cmdexcel.Enabled       = .t.
	
Endwith
***********************************************************
*Este codigo se repite en el Keypress para la tecla enter
***********************************************************
ENDPROC
PROCEDURE cmdprint.Init
with thisform

	if type('m' + alltrim(thisform.name) + 'cmdprint') = 'U'
		.cmdprint.enabled = .t.
	else
		.cmdprint.enabled = .f.
	endif

endwith
ENDPROC
PROCEDURE cmdfind.Click
With Thisform
	If mwkusuario.idusuario = 'CFUNES'
		Set step on
	Endif
	.lhistorial = .t.
*.cmdexcel.enabled = .f.
	.timer1.Enabled = .F.
*.pg.pgCatalogo.txtcant.value  = 0
	.pg.pgCatalogo.txtcant.Value = 0
	.pg.pgcambios.txtcant.value = 0


	.pg.pgCatalogo.label3.Caption ='Cantidad De Personas Atendidas:'
	do sp_busco_socio  With 2,,'mwkAtendidos',.txtfechad.Value,.txtfechah.Value
*	select * from mwkAtendidos where

	Sele mwkAtendidos
	Go Top
	.cargagrid('mwkAtendidos',3, .corden)
	.mcursor = 'mwkAtendidos'
	.mformu  = 3
	If .pg.ActivePage < 3
		.cmdundo.Enabled = .T.
		.pg.pgCatalogo.SetFocus()
	Endif
	.timer1.Reset()
*	.timer1.Enabled = .t.

Endwith

ENDPROC
PROCEDURE Pg.PgCatalogo.Deactivate
this.FontBold = .f.
ENDPROC
PROCEDURE Pg.PgCatalogo.Activate
this.FontBold = .t.
do sp_busco_socio  With 1,,'mwkLLegadas', mhoy, mhoy
With Thisform
	.cmdsave.Enabled = .F.
	.cmdmodif.Enabled = .F.
	.cargagrid(1,'mwkLLegadas', 1, .corden)
	.cargagrid(2,'mwkLLegadas', 1, .corden)
	.cmdundo.Enabled = Iif(.mformu=3,.T.,.F.)
	.cmdfind.Enabled = Iif(.mformu=3,.F.,.T.)
Endwith

ENDPROC
PROCEDURE Pg.PGCambios.Activate
this.FontBold = .t.

ENDPROC
PROCEDURE Pg.PGCambios.Deactivate
this.FontBold = .f.

ENDPROC
PROCEDURE Pg.PgDatos.Activate
this.FontBold = .f.
with thisform
	with .pg.Pgdatos
		.cbomotivos.setfocus
	endwith	
	if .mformu = 3
		.cmdfind.enabled = .t.
	endif
endwith
ENDPROC
PROCEDURE Pg.PgDatos.Deactivate
this.FontBold = .f.
ENDPROC
