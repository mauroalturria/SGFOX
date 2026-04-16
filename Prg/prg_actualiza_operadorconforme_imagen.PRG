Lparameters CantDiasAtras, OperadorConformeImagen
Clear 

*SET STEP ON

*Close Tables
*Set Resource off

** Parámetro CantDiasAtras: Cantidad de días que recorrer hacia atrás buscando vales.
IF EMPTY(CantDiasAtras)
	CantDiasAtras = '1' 
ENDIF

public mcon1, midusu, mpassw, msql_reg, mcon3,mconc,myip,miform,mxambito 
mxambito  = 1
*!*	set ansi on
*!*	set bell off
*!*	set cent on
*!*	set compatible off
*!*	set conf on
*!*	set date to french
*!*	set decimal to 2
*!*	set dele on
*!*	set exact on
*!*	set exclu off
*!*	set fdow to 1
*!*	set hours to 24
*!*	set near on
*!*	set notify off
*!*	set path to "Scx, Lib, Mnu, Prg, exe, Bmp, Rep" ADDITIVE
*!*	set optimize on
*!*	set point to ","
*!*	set safety off
*!*	set separator to "."
*!*	*set status off
*!*	*set status bar off
*!*	set talk off
*!*	set sysmenu off
*!*	SET ENGINEBEHAVIOR 70

*_screen.Icon = "awt.ico"
_screen.Caption = "Actualiza OperadorConforme de vales de imágenes con evidencia, conformados manualmente"


*******************
*SET STEP ON
******************

do seteos_ip
myip = IPAddress()

do sp_busco_server_namespaces

Do sp_conexion 

Public g_codvax

moperador = IIF(EMPTY(OperadorConformeImagen), 99999, OperadorConformeImagen)


****** Proceso Principal: Barrida de los vales conformados manualmente:

? 'Buscando vales de imágenes conformados manualmente desde ',CantDiasAtras,' días atrás a hoy...'

TEXT To lcsql Textmerge Noshow Pretext 7
	select VAL_fechasolicitud, val_codservvale, VAL_codmnemoserv,VAL_codvaleasist, val_tipopaciente, val_nroprotocolo,
	    val_operadorconforme, val_fechahoraimagen, PAC_codhce, SUM(PIA_cantsolicitada) as TotalSolicit
	from valesasist 
		inner join PresInsuVas on PIA_Valesasist = VAL_codpun
		inner join Pacientes on VAL_codadmision = PAC_codadmision
	where Val_fechasolicitud >= DATEADD('dd', -<<CantDiasAtras>>, current_date) AND 
		val_estado = 3 AND
		val_operadorconforme <> <<moperador>> and 
		VAL_codservvale 
		    in (SELECT SCV_codservicio
                    FROM ServCargVal
                    WHERE SCV_QuienConforma = 2)
    GROUP BY VAL_codvaleasist
	having SUM(PIA_cantsolicitada) > 0
ENDTEXT

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
	? mcantvales, mvale, mwkaux.VAL_fechasolicitud, mwkaux.VAL_codmnemoserv, mwkaux.PAC_codhce, mwkaux.val_nroprotocolo, mwkaux.val_tipopaciente, mwkaux.VAL_fechahoraimagen


	** Si ya tiene seteada en la tabla VAL_fechahoraimagen -> es evidencia suficiente:
	IF NOT ISNULL(mwkAux.VAL_fechahoraimagen) AND NOT EMPTY(mwkAux.VAL_fechahoraimagen)

		*SET STEP ON
		
		FlagRealizado = .T.
		FechaHoraImagen = CTOT('')
		lccriterio = 'FecHoraImagen'

	ELSE

		* -RLV 2025 Si hay vales relacionados, hay que analizar TODOS los vales, para imágenes, worklist e informes.
		DO ValesRelacionados IN 0seteos_confg WITH mvale, mwkaux.VAL_nroprotocolo && Genera cursor con todos los vales relacionados, además del actual de la recorrida:
		
		IF RECCOUNT('mwkValRel')> 1
		  ?? '  Hay relac:', RECCOUNT('mwkValRel')
		  *SET STEP ON 
		ENDIF
		
		** Recorre  los vales relacionados:
		FlagRealizado = .F.
		FechaHoraImagen = CTOT('')
		FechaHoraRealizado = CTOT('')

		** 1) Busca en PACS Viejo:
		SELECT mwkValRel
		SCAN FOR NOT FlagRealizado
		    lccriterio = 'PACS old'
			DO PACS IN 0seteos_confg WITH mwkValRel.NroProtocolo, mwkAux.PAC_codhce, FlagRealizado, FechaHoraImagen
			FechaHoraRealizado = FechaHoraImagen
			SELECT mwkValRel
		ENDSCAN

		** 2) Busca en PACS Paciente:
		SELECT mwkValRel
		SCAN FOR NOT FlagRealizado
		    lccriterio = 'PACS Paciente'
			DO PACSpaciente IN 0seteos_confg WITH mwkValRel.NroProtocolo, mwkAux.PAC_codhce, FlagRealizado, FechaHoraImagen
			FechaHoraRealizado = FechaHoraImagen
			SELECT mwkValRel
		ENDSCAN

		** 3) Busca en Lista de trabajo MPPS:
		SELECT mwkValRel
		SCAN FOR NOT FlagRealizado
		    lccriterio = 'MPPS'
			DO MPPS IN 0seteos_confg WITH mwkValRel.NroProtocolo, mwkAux.PAC_codhce, FlagRealizado, FechaHoraRealizado
			SELECT mwkValRel
		ENDSCAN

		** 4) Busca en Informes:
		SELECT mwkValRel
		SCAN FOR NOT FlagRealizado
		    lccriterio = 'Informe'
			DO Informe IN 0seteos_confg WITH mwkValRel.NroVale, FlagRealizado, FechaHoraRealizado
			SELECT mwkValRel
		ENDSCAN

	ENDIF

	IF FlagRealizado

	 	??   FechaHoraImagen, ' ** Evidenciable!  ',lccriterio

		*SET STEP ON
		
		IF NOT EMPTY(FechaHoraImagen) AND NOT ISNULL(FechaHoraImagen)
			TEXT To lcUpdate Textmerge Noshow Pretext 7
				UPDATE ValesAsist
					SET VAL_OperadorConforme = <<moperador>>,
						VAL_Observaciones = String(VAL_observaciones, '//EVID/'),
						VAL_FechaHoraImagen = '<<FechaHoraImagen>>'
					WHERE VAL_codvaleasist = <<mvale>>
			ENDTEXT
		ELSE
			TEXT To lcUpdate Textmerge Noshow Pretext 7
				UPDATE ValesAsist
					SET VAL_OperadorConforme = <<moperador>>,
						VAL_Observaciones = String(VAL_observaciones, '//EVID/')
					WHERE VAL_codvaleasist = <<mvale>>
			ENDTEXT
		ENDIF

		If SqlExec(mcon1,lcUpdate) <= 0
			Aerror(eros)
			?eros(3)
		Endif			
		
	ENDIF

	Select mwkAux
Endscan 


RETURN


