Lparameters miparam, CantDiasAtras, CantDiasAnula
Clear 

*SET STEP ON


Close Tables
Set Resource off
If Empty(miparam)
   Messagebox("ACCESO NO AUTORIZADO",16,"Control de ingreso")
   Cancel
Endif


*!*	? 'Current resource file: ', SYS(2005)

** Parámetro CantDiasAtras: Cantidad de días que recorrer hacia atrás buscando vales sin conformar.
*  Útil si se quieren correr diferentes instancias del mismo proceso. 
*  Por ejemplo, una instancia que corra hora a hora buscando los pendientes de HOY (o ayer y hoy)
*     Otra instancia, a la madrugada, recorriendo N días hacia atrás buscando pendientes.
IF EMPTY(CantDiasAtras)
	CantDiasAtras = '0'  && Default: Vales de hoy
ENDIF

** Parámetro CantDiasAnula: (Solo si CantDiasAtras > 0 y TipoPaciente = INT)
*  Si el vale está sin conformar desde hace más de CantDiasAnula entonces se anula (conforma en CERO):
IF EMPTY(CantDiasAnula) OR VAL(ALLTRIM(CantDiasAnula)) < 3
	CantDiasAnula = '3'  && Default: Pendientes anteriores a 3 días atrás se anulan 
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
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
SET ENGINEBEHAVIOR 70

_screen.Icon = "awt.ico"
_screen.Caption = "Conforme Automático Vales Imágenes"


*******************
*SET STEP ON
******************

do seteos_ip
myip = IPAddress()

do sp_busco_server_namespaces

Do sp_conexion 

Public g_codvax

olevism = Newobject("Visual", "c:\desaguemes\lib\lib_cubito.vcx")
olevism = olevism.olevism

moperador = 99999
g_codvax = 55615
lcsvr = Alltrim(mwktabcfg.OLEServer)
lcnasp = Alltrim(mwktabcfg.olespaces)
lcruti = "RTN031"
lcparr = "CONFTOTAL"
lnexec = 1


****** Proceso Principal: Barrida de los vales pendientes ****************************


? 'Buscando vales de imágenes desde ',CantDiasAtras,' días atrás a hoy...'

** -RLV 16/10/2025: En el SELECT de abajo, que recorre los vales pendientes, 
*    ahora está calculando los días mediante la variable parámetro CantDiasAtras 
*    para que no se escapen los pendientes realizados con demora.
*    La línea original era:
*	where Val_fechasolicitud >= DATEADD('dd',-12,current_date) AND 
*  -RLV 16/10/2025: Agrego también la suma de las Cantidades de los items, para ver si hay vales que ANULAR completos:
TEXT To lcsql Textmerge Noshow Pretext 7
	select VAL_fechasolicitud, ser_codserv, VAL_codmnemoserv,VAL_codvaleasist, val_tipopaciente, val_nroprotocolo ,ser_descripserv, pacientes.pac_codhce,
	    SUM(PIA_cantsolicitada) as TotalSolicit,
		Cast("" AS CHAR(20)) AS PACS, 
		Cast("" AS CHAR(20)) AS INF, 
		Cast("" AS CHAR(20)) AS MPPS,
		Cast("" AS CHAR(20)) AS CONFORMADO,
		Cast("" AS CHAR(20)) AS INFR,
		CAST("" AS DATE) AS FECHAIMAGEN 
	from servicios, valesasist 
		inner join pacientes on pac_codadmision = val_codadmision
		inner join PresInsuVas on PIA_Valesasist = VAL_codpun
	where Val_fechasolicitud >= DATEADD('dd', -?CantDiasAtras, current_date) AND 
		VAL_codservvale = ser_codserv and 
		val_estado <> 3 AND
		VAL_codservvale 
		    in (SELECT SCV_codservicio
                    FROM ServCargVal
                    WHERE SCV_QuienConforma = 2)
    GROUP BY VAL_codvaleasist
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
	? mcantvales, mvale, mwkaux.VAL_fechasolicitud, mwkaux.VAL_codmnemoserv, mwkaux.pac_codhce, mwkaux.val_nroprotocolo, mwkaux.val_tipopaciente

	* Reviso si todos los items están en CERO (para anular el conforme)
	IF mwkAux.TotalSolicit = 0

		**SET STEP ON
		
		DO AnularVale

	ELSE

		* -RLV 2025 Si hay vales relacionados, hay que analizar TODOS los vales, para imágenes, worklist e informes.
		ValesRelacionados(mvale, mwkaux.VAL_nroprotocolo) && Genera cursor con todos los vales relacionados, además del actual de la recorrida:
		
		IF RECCOUNT('mwkValRel')> 1
		  ?? '  Hay relac:', RECCOUNT('mwkValRel')
		  *SET STEP ON 
		ENDIF
		
		** Recorre  los vales relacionados:
		FlagConformable = .F.
		FechaHoraImagen = CTOT('')
		FechaHoraRealizado = CTOT('')

		** 1) Busca en PACS Viejo:
		SELECT mwkValRel
		SCAN FOR NOT FlagConformable
		    lccriterio = 'PACS old'
			PACS(mwkValRel.NroProtocolo, mwkAux.PAC_codhce, @FlagConformable, @FechaHoraImagen)
			FechaHoraRealizado = FechaHoraImagen
			SELECT mwkValRel
		ENDSCAN

		** 2) Busca en PACS Paciente:
		SELECT mwkValRel
		SCAN FOR NOT FlagConformable
		    lccriterio = 'PACS Paciente'
			PACSpaciente(mwkValRel.NroProtocolo, mwkAux.PAC_codhce, @FlagConformable, @FechaHoraImagen)
			FechaHoraRealizado = FechaHoraImagen
			SELECT mwkValRel
		ENDSCAN

		** 3) Busca en Lista de trabajo MPPS:
		SELECT mwkValRel
		SCAN FOR NOT FlagConformable
		    lccriterio = 'MPPS'
			MPPS(mwkValRel.NroProtocolo, mwkAux.PAC_codhce, @FlagConformable, @FechaHoraRealizado)
			SELECT mwkValRel
		ENDSCAN

		** 4) Busca en Informes:
		SELECT mwkValRel
		SCAN FOR NOT FlagConformable
		    lccriterio = 'Informe'
			Informe(mwkValRel.NroVale, @FlagConformable, @FechaHoraRealizado)
			SELECT mwkValRel
		ENDSCAN
	
		IF FlagConformable

		 	??  mwkValRel.NroProtocolo, FechaHoraRealizado, FechaHoraImagen, ' *** CONFORMABLE!  ',lccriterio
		 	****************
		 	*  Acá agregar el CONFORME **********
		 	*INKEY(1)
			*SET STEP ON

			lccode = "D CONFTOTAL^RTN031("+ Transform(lnexec) + ',' + Transform(mvale) + ',' + Transform(moperador) + ')'
			lccomenta = "CONFG" + '-' + Alltrim(str(mvale,16,0))

			ExecVism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
			
			** Grabo la Fecha/hora de la grabación de la imagen (PACS), si hubiera:
			IF NOT EMPTY(FechaHoraImagen) AND NOT ISNULL(FechaHoraImagen)
				TEXT To lcUpdate Textmerge Noshow Pretext 7
					UPDATE ValesAsist
						SET VAL_FechaHoraImagen = ?FechaHoraImagen
						WHERE VAL_codvaleasist = ?mvale
				ENDTEXT
				If SqlExec(mcon1,lcUpdate) <= 0
					Aerror(eros)
					?eros(3)
				Endif			
			ENDIF
		
		ELSE
			* Si el vale no se pudo conformar
			*  y es el proceso nocturno (que corre cada madrugada)
			*  y es de paciente Internado
			*  y ya pasaron más de CantDiasAnula
			* Entonces se ANULA el Vale  (Definición consensuada con Dirección Médica) -RLV 19/03/2026
			IF VAL(ALLTRIM(CantDiasAtras)) > 2 AND mwkaux.val_tipopaciente = 'INT' AND (DATE() - mwkaux.VAL_FechaSolicitud) > VAL(ALLTRIM(CantDiasAnula))

				**SET STEP ON
				DO AnularVale

			ENDIF

		ENDIF

	ENDIF

	If Vartype(olevism) = "O"
		olevism.mserver = ""
		olevism.namespace = ""
		prg_olevism_reset(olevism)
	Endif 

	Select mwkAux
Endscan 

olevism.parent.release
Release olevism

*** -RLV 02/12/2025: Si es la versión nocturna (que corre diariamente una vez) 
*   entonces dispara también este programa que busca Fecha/hora de imagen que hayan quedado sin grabar al momento del conforme,
*   por haberse cargado luego de que haya corrido este programa de conforme automático de imágenes:
**  -RLV 26/03/2026: Agrego el post-proceso que cambia el operadorconforme a los vales conformados manualmente
*    pero que se detecta evidencia de que el estudio fue realizado.
IF VAL(ALLTRIM(CantDiasAtras)) > 2
   do prg_actualiza_fechahoraimagen WITH DATE()-4, DATE()-1, .F., moperador   && Recorre últimos 4 días
   do prg_actualiza_operadorconforme_imagen WITH CantDiasAtras, moperador
ENDIF


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
Procedure Informe
*Parameters lcsqlinf
Parameters NumeroVale, FlagConformable, FechaHoraCompletado

*!*	------------------------------------------------------------------------

TEXT To lcsqlinf Textmerge Noshow Pretext 7
	Select ID, fechahoraestudio 
	   from Informes 
	   Where NroVAle = ?NumeroVale And estadoinforme = 3 And tipoarch = 'TXT'
ENDTEXT

If SqlExec(mcon1,lcsqlinf,"mwkAuxI") > 0 AND Reccount("mwkAuxI") > 0
	FlagConformable = .T.
	FechaHoraCompletado = mwkAuxI.fechahoraestudio 
Endif

RETURN


*!*	------------------------------------------------------------------------
Procedure MPPS
Parameters NroProtocolo, NroHistClin, FlagConformable, FechaHoraCompletado
*Parameters lcsqlMPPS
*!*	------------------------------------------------------------------------

TEXT To lcsqlmpps Textmerge Noshow Pretext 7
	SELECT PatientId, ExamCode, AccessionNumber, UniquePrimary, DBO.MWL_H.ID,
	     MODALITY, CACHEFECHA, CACHEERROR, COMMENTS, EXAMDESCRIPTION, dbo.mwl_h_status.*
       FROM dbo.MWL_H
  INNER JOIN dbo.mwl_h_status ON dbo.MWL_H.StudyUID=dbo.mwl_h_status.StudyUID
     WHERE dbo.mwl_h_status.StatusCode = 'COMPLETED' AND dbo.MWL_H.accessionnumber = ?NroProtocolo
	     AND Rtrim(dbo.MWL_H.patientid) = ?Alltrim(NroHistClin) 
ENDTEXT

If SqlExec(mcon1,lcsqlMPPS,"mwkAuxM") > 0 AND Reccount("mwkAuxM") > 0
	FlagConformable = .T.
	FechaHoraCompletado = mwkAuxM.statusdatetime
ELSE 
	?? '  No MPPS.'
Endif

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



*!*	------------------------------------------------------------------------
Procedure AnularVale
*!*	------------------------------------------------------------------------
PRIVATE lcparr

lcparr = "CONFANUL"

?? " ANULADO!!!"
lccode = "D CONFANUL^RTN031("+ Transform(lnexec) + ',' + Transform(mvale) + ',' + Transform(moperador) + ')'
lccomenta = "CONFGANUL" + '-' + Alltrim(str(mvale,16,0))

ExecVism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)

RETURN





*!*	-------------------------------------
Function execvism
Parameter tccomenta, tcsvr, tcnasp, tcruti, tcparr, tccode, tnexec
*!*	-------------------------------------

Local lbresu
lbresu = .F.
Do While .T.
	olevism.mserver = tcsvr
	olevism.namespace = tcnasp
	olevism.Code = tccode
	olevism.execflag = tnexec
	mmsgerr = olevism.errorname
	If  .Not. Empty(mmsgerr)
	Endif
	mok = olevism.p0
	mresp1 = olevism.p1
	mresp2 = olevism.p2
	lnerror = olevism.Object.Error
	lcerrorname = olevism.errorname
	lcp0 = olevism.Object.p0
	lcp1 = olevism.Object.p1
	lcp2 = olevism.Object.p2
	lcp3 = olevism.Object.p3
	lcp4 = olevism.Object.p4
	lcp5 = olevism.Object.p5
	lcp6 = olevism.Object.p6
	lcp7 = olevism.Object.p7
	lcp8 = olevism.Object.p8
	lcp9 = olevism.Object.p9
	lncodvaxadd = g_codvax
	TEXT TO lcsql TEXTMERGE NOSHOW PRETEXT 7
			INSERT INTO ZabVisM
				(ZVM_Comenta, ZVM_Server, ZVM_NameSpace, ZVM_Rutina, ZVM_Parrafo, ZVM_Code,
				ZVM_Error, ZVM_ErrorName, ZVM_P0, ZVM_P1, ZVM_P2,
				ZVM_P3, ZVM_P4, ZVM_P5, ZVM_P6, ZVM_P7,
				ZVM_P8, ZVM_P9, ZVM_CodVaxAdd) VALUES
				(?tcComenta, ?tcSvr, ?tcNaSp, ?tcRuti, ?tcParr, ?tcCode,
				?lnError, ?lcErrorName, ?lcP0, ?lcP1, ?lcP2,
				?lcP3, ?lcP4, ?lcP5, ?lcP6, ?lcP7,
				?lcP8, ?lcP9, ?lnCodVaxAdd)

	ENDTEXT
	If SQLExec(mcon1, lcsql, "") <= 0
		Messagebox("ERROR AL GUARDAR EL LOG", 16, "ERROR")
		Exit
	Endif
	If  .Not. Empty(mok)
		Exit
	Endif
*!*		If  .Not. Empty(mresp1)
*!*			Exit
*!*		Endif
	lbresu = .T.
	Exit
Enddo

Return lbresu
Endfunc



*!*	*!*	-------------------------------------
*!*	Function conforme
*!*	*!*	-------------------------------------



*!*		mgraba = '1'
*!*		
*!*		mvale  = alltrim(str(mwkValeAsist.val_codvaleasist))
*!*		moperador	= iif(mwkusuarios.codigovax = 0, '99999', str(mwkusuarios.codigovax, 5))

*!*		.olevism.mserver	= alltrim(mwktabcfg.oleserver)
*!*		.olevism.namespace	= alltrim(mwktabcfg.olespaces)
*!*		
*!*		=prg_olevism_reset(.olevism)

*!*		.olevism.code = "D CONFTOTAL^RTN031("+ mgraba + ','+ mvale + ','+ moperador + ')'
*!*		.olevism.execflag = 1

*!*		mmsgerr = .olevism.errorname
*!*		
*!*		if !empty(mmsgerr)
*!*			do sp_insert_tabctrlerr with .olevism.code, mmsgerr , moperador, .name
*!*			messagebox ("ERROR EN CONFORME DEL VALE...", 48, 'VALIDACION')
*!*			.OleVismOff()
*!*			Return .f.
*!*		Endif 
*!*		
*!*		mok		= .olevism.p0					&& Codigo de error
*!*		
*!*		if .olevism.p0 <> ''
*!*			mcoderr = val(thisform.olevism.p0)
*!*			do sp_busco_texto_error with mcoderr && mwktaberror
*!*			
*!*			MESSAGEBOX(ALLTRIM(MWKTABERROR.TEXTOERROR), 48, 'VALIDACION')
*!*			mmsgerr = "V:" +  alltrim(thisform.olevism.p1) + "-" + alltrim(mwktaberror.textoerror)
*!*			
*!*			do sp_insert_tabctrlerr with thisform.olevism.code, mmsgerr , moperador, .name
*!*			messagebox ("ERROR EN CONFORME DEL VALE...", 48, 'VALIDACION')
*!*			.OleVismOff()
*!*			Return .f.
*!*		Endif
*!*		
*!*		.OleVismOff()

*!*	RETURN





*****************************************************




*!*	*!*	------------------------------------------------------------------------
*!*	Procedure ValeRela
*!*	*!*	------------------------------------------------------------------------


*!*	TEXT To lcsqlrela1 Textmerge Noshow Pretext 7
*!*		select b.ID, b.estadoinforme 
*!*			  	from TabValeRelacion a
*!*			  	inner join informes b on a.NroValeRelacionado = b.nrovale
*!*			  	where a.NroValeOriginal = ?mwkaux.VAL_codvaleasist and 
*!*			  	estadoinforme < 5 and FecPasiva = '1900-01-01'
*!*	Endtext


*!*	If SqlExec(mcon1,lcsqlrela1,"mwkAuxI")<=0
*!*		Aerror(eros)
*!*		?eros(3)
*!*		Return .F.
*!*	Endif


*!*	If Reccount("mwkAuxI") > 0

*!*		If Reccount("mwkAuxI")>1
*!*			replace INFR With "-1" In mwkAux
*!*		Else
*!*			If Reccount("mwkAuxI")=1
*!*				If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
*!*					Return .f.
*!*				Endif 
*!*				replace INFR With "1" In mwkAux
*!*				replace CONFORMADO With "1" In mwkAux
*!*			Else
*!*				replace INFR With "0" In mwkAux
*!*			endif
*!*		endif


*!*	Else
*!*		Use In Select("mwkAuxI")
*!*		TEXT To lcsqlrela2 Textmerge Noshow Pretext 7

*!*		select b.ID, b.estadoinforme 
*!*			  	from TabValeRelacion a
*!*			  	inner join informes b on a.NroValeOriginal = b.nrovale
*!*			  	where NroValeRelacionado = ?mwkaux.VAL_codvaleasist and 
*!*			  	estadoinforme < 5 and FecPasiva = '1900-01-01'

*!*		Endtext


*!*		If SqlExec(mcon1,lcsqlrela2,"mwkAuxI")<=0
*!*			Aerror(eros)
*!*			?eros(3)
*!*			Return .F.
*!*		Endif		
*!*		
*!*		***--------
*!*		If Reccount("mwkAuxI")>1
*!*			replace INFR With "-1" In mwkAux
*!*		Else
*!*			If Reccount("mwkAuxI")=1
*!*				If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
*!*					Return .f.
*!*				Endif 
*!*				replace INFR With "1" In mwkAux
*!*				replace CONFORMADO With "1" In mwkAux
*!*			Else
*!*				replace INFR With "0" In mwkAux
*!*			endif
*!*		endif		  	

*!*	Endif 
