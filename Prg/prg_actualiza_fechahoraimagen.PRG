Lparameters FechaDesde, FechaHasta, SoloCheck
Clear 



Close Tables
*Set Resource off



*!*	? 'Current resource file: ', SYS(2005)

** Parámetro CantDias: Cantidad de días que recorrer hacia atrás buscando vales YA CONFORMADOS.
IF EMPTY(FechaDesde)
	FechaDesde = DATE()
	FechaHasta = DATE()
ENDIF


*!*	? 'Current resource file: ', SYS(2005)

public mcon1, midusu, mpassw, msql_reg, mcon3,mconc,myip,miform,mxambito 
mxambito  = 1
set ansi on
set bell off
set cent on
set compatible off
set conf on
set date to french
set decimal to 2
set dele on
set exact on
set exclu off
set fdow to 1
set hours to 24
set near on
set notify off
set path to "Scx, Lib, Mnu, Prg, exe, Bmp, Rep" ADDITIVE
SET PATH TO "C:\desaguemes\prg" addit
set optimize on
set point to ","
set safety off
set separator to "."
*set status off
*set status bar off
set talk off
set sysmenu off
SET ENGINEBEHAVIOR 70
SET ESCAPE ON

*_screen.Icon = "awt.ico"
_screen.Caption = "Actualiza Fecha/Hora Imagen en Cabecera de Vales ya conformados"


*******************
*SET STEP ON
******************

do seteos_ip
myip = IPAddress()

do sp_busco_server_namespaces

Do sp_conexion 

Public g_codvax

*olevism = Newobject("Visual", "c:\desaguemes\lib\lib_cubito.vcx")
*olevism = olevism.olevism

*!*	moperador = 99999
*!*	g_codvax = 55615
*!*	lcsvr = Alltrim(mwktabcfg.OLEServer)
*!*	lcnasp = Alltrim(mwktabcfg.olespaces)
*!*	lcruti = "RTN031"
*!*	lcparr = "CONFTOTAL"
*!*	lnexec = 1


****** Proceso Principal: Barrida de los vales pendientes ****************************

mFecDesdeSolicit = FechaDesde - 20   && Barre por Solicitud, por carencia de índice de Conforme:

? 'Buscando vales de imágenes CONFORMADOS entre ',FechaDesde,' y ',FechaHasta, ' Solicitados desde el',mFecDesdeSolicit

** -RLV 16/10/2025: En el SELECT de abajo, que recorre los vales pendientes, 
*    ahora está calculando los días mediante la variable parámetro CantDias 
*    para que no se escapen los pendientes realizados con demora.
*    La línea original era:
*	where Val_fechasolicitud >= DATEADD('dd',-12,current_date) AND 
*  -RLV 16/10/2025: Agrego también la suma de las Cantidades de los items, para ver si hay vales que ANULAR completos:
TEXT To lcsql Textmerge Noshow Pretext 7
	select VAL_fechasolicitud, val_horasolicitud, ser_codserv, VAL_codmnemoserv,VAL_codvaleasist, val_tipopaciente, val_nroprotocolo ,ser_descripserv, pacientes.pac_codhce,
	   SUM(pia_cantsolicitada) as cantconformada, val_fechaconforme, val_horaconforme, val_operadorconforme
	from servicios, valesasist 
		inner join pacientes on pac_codadmision = val_codadmision
		inner join presinsuvas on pia_valesasist = val_codpun
	where Val_fechasolicitud between ?mFecDesdeSolicit and ?FechaHasta AND 
	    VAL_fechaconforme between ?FechaDesde and ?FechaHasta AND
		VAL_codservvale = ser_codserv and 
		val_estado = 3 AND
		VAL_fechahoraimagen is null AND
		VAL_codservvale 
		    in (SELECT SCV_codservicio
                    FROM ServCargVal
                    WHERE SCV_QuienConforma = 2)
    group by val_codvaleasist
    having SUM(pia_cantsolicitada) > 0
    order by val_codvaleasist
ENDTEXT
*!*    
*!*		    in (7900, 6300, 7700, 7100, 7400, 5163, 7200, 4403, 9100)
*!*
*!*			    in (SELECT SCV_codservicio
*!*	                    FROM ServCargVal
*!*	                    WHERE SCV_QuienConforma = 2)

*!*	CodServVale	SER_descripserv
*!*	7900	ECOGRAFIA
*!*	7700	TOMOGRAFIA COMPUTADA (TAC)
*!*	6300	RESONANCIA MAGNETICA
*!*	7400	ECOCARDIOGRAMA
*!*	5163	ECOGRAFIA PEDIATRICA
*!*	7100	RAYOS
*!*	7200	ELECTROCARDIOGRAFIA
*!*	4403	ECOCARDIOGRAFIA PEDIATRICA
*!*	9100	DOPPLER VASCULAR PERIFERICO


**********************
*SET STEP ON
**********************


If SqlExec(mcon1,lcSql,"mwkAux",laCount)<=0
	Aerror(eros)
	?eros(3)
	Return .F.
Endif

?"A PROCESAR " + Transform(laCount[1,2]),' vales.'
INKEY(3)

*******************
*SET STEP ON
******************

Select mwkAux
mcantvales = 0
Scan All 
	mcantvales = mcantvales + 1
	mvale = mwkaux.VAL_codvaleasist
	? mcantvales, mvale, mwkaux.VAL_fechasolicitud, mwkaux.val_horasolicitud, mwkaux.VAL_fechaconforme, mwkaux.VAL_horaconforme, mwkaux.Val_operadorconforme, mwkaux.VAL_codmnemoserv, mwkaux.pac_codhce, mwkaux.val_nroprotocolo, mwkaux.val_tipopaciente, mwkaux.cantconformada


		* -RLV 2025 Si hay vales relacionados, hay que analizar TODOS los vales, para imágenes, worklist e informes.
		ValesRelacionados(mvale, mwkaux.VAL_nroprotocolo) && Genera cursor con todos los vales relacionados, además del actual de la recorrida:
		
		IF RECCOUNT('mwkValRel')> 1
		  ?? '  Hay relac:', RECCOUNT('mwkValRel')
		  *SET STEP ON 
		ENDIF
		
		** Recorre  los vales relacionados:
		FlagConImagen = .F.
		FechaHoraImagen = CTOT('')
		FechaHoraRealizado = CTOT('')

		** 1) Busca en PACS Viejo:
		SELECT mwkValRel
		SCAN FOR NOT FlagConImagen
		    lccriterio = 'PACS old'
			PACS(mwkValRel.NroProtocolo, mwkAux.PAC_codhce, @FlagConImagen, @FechaHoraImagen)
			FechaHoraRealizado = FechaHoraImagen
			SELECT mwkValRel
		ENDSCAN

		** 2) Busca en PACS Paciente:
		SELECT mwkValRel
		SCAN FOR NOT FlagConImagen
		    lccriterio = 'PACS Paciente'
			PACSpaciente(mwkValRel.NroProtocolo, mwkAux.PAC_codhce, @FlagConImagen, @FechaHoraImagen)
			FechaHoraRealizado = FechaHoraImagen
			SELECT mwkValRel
		ENDSCAN

	
		IF FlagConImagen
		 	??  FechaHoraImagen, ' *** IMAGEN ENCONTRADA!  ',lccriterio
		 	****************
		 	*  Acá agregar el CONFORME **********
*!*			 	INKEY(1)
*!*			 	IF MWKAUX.VAL_TIPOPACIENTE = 'INT'
*!*			 	   *SUSPEND
*!*			 	ENDIF
			*SET STEP ON
			*SUSPEND

			FechaHoraImagen = ALLTRIM(FechaHoraImagen)
			** Grabo la Fecha/hora de la grabación de la imagen (PACS), si hubiera:
			IF NOT EMPTY(FechaHoraImagen) AND NOT ISNULL(FechaHoraImagen) AND NOT SoloCheck
				TEXT To lcUpdate Textmerge Noshow Pretext 7
					UPDATE ValesAsist
						SET VAL_FechaHoraImagen = '<<FechaHoraImagen>>'
						WHERE VAL_codvaleasist = <<mvale>>
				ENDTEXT
				If SqlExec(mcon1,lcUpdate) <= 0
					Aerror(eros)
					?eros(3)
				Endif			
			ENDIF

		ENDIF


*!*		If Vartype(olevism) = "O"
*!*			olevism.mserver = ""
*!*			olevism.namespace = ""
*!*			prg_olevism_reset(olevism)
*!*		Endif 

	Select mwkAux
Endscan 

*!*	olevism.parent.release
*!*	Release olevism

RETURN


*!*		lccode = "D CONFTOTAL^RTN031("+ Transform(lnexec) + ',' + Transform(mvale) + ',' + Transform(moperador) + ')'

*!*		If !Inlist(mwkAux.ser_codserv,7900, 7400, 5163, 4403, 9100)
*!*			If Val(mwkAux.CONFORMADO)=0
*!*				Do MPPS With lcsqlmpps 
*!*			Endif 	
*!*			If Val(mwkAux.CONFORMADO)=0
*!*				Do Pacs With lcsqlpacs
*!*			Endif 
*!*		Endif 
*!*		If Val(mwkAux.CONFORMADO)=0
*!*			Do Informe With lcsqlinf
*!*		Endif 
*!*		
*!*		If Val(mwkAux.CONFORMADO)=0
*!*			Do ValeRela
*!*		Endif
*!*			

*!*	If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
*!*		Return .f.
*!*	Endif 



***********************************************************************************************


*!*	----------------------------------------------------
PROCEDURE ValesRelacionados
*!*	----------------------------------------------------
PARAMETERS NroValeActual, NroProtocoloActual

CREATE CURSOR mwkValRel ;
	 (NroVale N(10,0), NroProtocolo N(10,0))

*1 - El vale que se está analizando
INSERT INTO mwkValRel (NroVale, NroProtocolo) ;
  values (NroValeActual, NroProtocoloActual)

*2 - Recorro Vales Relacionados a partir de éste:
TEXT To lcsqlrela1 Textmerge Noshow Pretext 7
	select DISTINCT a.NroValeRelacionado, val_nroprotocolo
		from TabValeRelacion a
		  	inner join informes b on a.NroValeRelacionado = b.nrovale
		  	inner join ValesAsist val on val_codvaleasist = a.NroValeRelacionado
		where a.NroValeOriginal = ?mwkaux.VAL_codvaleasist and 
		  	estadoinforme < 5 and FecPasiva = '1900-01-01'
Endtext
If SqlExec(mcon1,lcsqlrela1,"mwkAuxI") > 0 AND Reccount("mwkAuxI") > 0
	SELECT mwkAuxI
	SCAN
		SELECT mwkValRel
		LOCATE FOR mwkValRel.NroVale = mwkAuxI.NroValeRelacionado
		IF NOT FOUND()
			INSERT INTO mwkValRel (NroVale, NroProtocolo) ;
			  values (mwkAuxI.NroValeRelacionado, mwkauxi.val_nroprotocolo)
		ENDIF
		SELECT mwkAuxI
	ENDSCAN
ENDIF
*3 - Recorro vales suponiendo que éste es un relacionado:
TEXT To lcsqlrela2 Textmerge Noshow Pretext 7
	select DISTINCT a.NroValeOriginal, val_nroprotocolo
		from TabValeRelacion a
		 	inner join informes b on a.NroValeOriginal = b.nrovale
		  	inner join ValesAsist val on val_codvaleasist = a.NroValeOriginal
		where NroValeRelacionado = ?mwkaux.VAL_codvaleasist and 
		  	estadoinforme < 5 and FecPasiva = '1900-01-01'
Endtext
If SqlExec(mcon1,lcsqlrela2,"mwkAuxI") > 0 AND Reccount("mwkAuxI") > 0
	SELECT mwkAuxI
	SCAN
		SELECT mwkValRel
		LOCATE FOR mwkValRel.NroVale = mwkAuxI.NroValeOriginal
		IF NOT FOUND()
			INSERT INTO mwkValRel (NroVale, NroProtocolo) ;
			  values (mwkAuxI.NroValeOriginal, mwkauxi.val_nroprotocolo)
		ENDIF
		SELECT mwkAuxI
	ENDSCAN
ENDIF

RETURN


*!*	------------------------------------------------------------------------
Procedure Pacs
Parameters NroProtocolo, NroHistClin, FlagConformable, FechaHoraImagen
*!*	------------------------------------------------------------------------

** PACS viejo:
TEXT To lcsqlpacs Textmerge Noshow Pretext 7
	Select * 
	   from dbo.v_PatientsOnline 
	   Where dbo.v_PatientsOnline.accession_number = ?NroProtocolo
	        and rTrim(dbo.v_PatientsOnline.Real_patient_id) = ?ALLTRIM(NroHistClin)
ENDTEXT
If SqlExec(mcon1,lcsqlpacs,"mwkAuxP")>0 AND Reccount("mwkAuxP")>0
	FlagConformable = .T.
	FechaHoraImagen = mwkAuxP.study_date
endif	

RETURN



*!*	------------------------------------------------------------------------
Procedure PacsPaciente
Parameters NroProtocolo, NroHistClin, FlagConformable, FechaHoraImagen
*!*	------------------------------------------------------------------------


lclink = "https://servicios2.sg.com.ar/api/pacsrm/index.php?hc=" + ALLTRIM(NroHistClin) + "&proto=" + ALLTRIM(STR(NroProtocolo,10,0))
Local xmlHTTP As "Microsoft.XMLHTTP"


xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	*Messagebox( "No se pudo crear el objeto (XMLHTTP) - NOMBRE DEL EJECUTABLE.",48,"Aviso")
	RETURN
ENDIF

xmlHTTP.Open("GET", lclink)
xmlHTTP.Send()
Do While xmlHTTP.readyState<>4
	DOEVENTS
ENDDO

lcresp = xmlHTTP.responseText
lnServidor = xmlHTTP.Status
DO CASE
CASE !xmlHTTP.Status = 200
	*Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'NOMBRE DEL EJECUTABLE - Problemas con el Servidor')
	?? '  Tipo de Error: '+Alltrim(Str(xmlHTTP.Status))
CASE UPPER(SUBSTR(lcresp,AT('"estado":',lcresp)+11,2)) <> 'OK'
	*Messagebox('Respuesta de la API no estuvo OK')
	?? '  Respuesta de la API no estuvo OK'
CASE UPPER(SUBSTR(lcresp,AT('"imagen":',lcresp)+11,2)) <> 'SI'
	*Messagebox('No se entoncró imagen')	
	?? ' No se encontró imagen -->', UPPER(SUBSTR(lcresp,AT('"imagen":',lcresp)+11,2))	
OTHERWISE
    *SET STEP ON  && ********************
    ?? ' PACS PACIENTE++ '
	FlagConformable = .T.
	FechaHoraImagen = SUBSTR(lcresp,AT('"fecha":',lcresp)+10,10) + ' ' + SUBSTR(lcresp,AT('"hora":',lcresp)+9,8)
ENDCASE

Release xmlHTTP

RETURN



