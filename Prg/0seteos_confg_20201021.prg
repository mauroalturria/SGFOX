Clear 

*!*	? 'Current resource file: ', SYS(2005)

Close Tables
Set Resource off

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
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep
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
_screen.Caption = "Conforme Automatico"


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



TEXT To lcsql Textmerge Noshow Pretext 7
	select VAL_fechasolicitud, ser_codserv,VAL_codvaleasist, val_nroprotocolo ,ser_descripserv, 
	Cast("" AS CHAR(20)) AS PACS, 
	Cast("" AS CHAR(20)) AS INF, 
	Cast("" AS CHAR(20)) AS MPPS,
	Cast("" AS CHAR(20)) AS CONFORMADO,
	pacientes.pac_codhce 
	from servicios, valesasist 
	inner join pacientes on pac_codadmision = val_codadmision
	where Val_fechasolicitud >= DATEADD('dd',-6,current_date) AND 
	VAL_codservvale = ser_codserv and 
	VAL_codservvale not in (1200,130,9400) and val_estado <> 3 AND
	VAL_codservvale in (7900, 6300, 7700, 7100, 7400, 5163, 7200, 4403, 9100)
ENDTEXT



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

?"A PROCESAR " + Transform(laCount[1,2])

TEXT To lcsqlpacs Textmerge Noshow Pretext 7
	Select * from dbo.v_PatientsOnline Where dbo.v_PatientsOnline.accession_number = ?mwkaux.val_nroprotocolo
	and rTrim(dbo.v_PatientsOnline.Real_patient_id) = ?Alltrim(mwkaux.pac_codhce) 
ENDTEXT

TEXT To lcsqlinf Textmerge Noshow Pretext 7
	Select ID from Informes Where NroVAle = ?mwkaux.VAL_codvaleasist And estadoinforme = 3 And tipoarch = 'TXT'
ENDTEXT

TEXT To lcsqlmpps Textmerge Noshow Pretext 7
	SELECT PatientId, ExamCode, AccessionNumber, UniquePrimary, DBO.MWL_H.ID, MODALITY, CACHEFECHA, CACHEERROR, COMMENTS, EXAMDESCRIPTION, *
       FROM dbo.MWL_H
  INNER JOIN dbo.mwl_h_status ON dbo.MWL_H.StudyUID=dbo.mwl_h_status.StudyUID
     WHERE dbo.mwl_h_status.StatusCode = 'COMPLETED' AND dbo.MWL_H.accessionnumber = ?mwkaux.val_nroprotocolo 
     AND Rtrim(dbo.MWL_H.patientid) = ?Alltrim(mwkaux.pac_codhce) 
ENDTEXT

Set Step On

Select mwkAux
Scan All 
	mvale = mwkaux.VAL_codvaleasist
	
	If mvale = 45613389
		Set Step On
	Endif 	
	lccode = "D CONFTOTAL^RTN031("+ Transform(lnexec) + ',' + Transform(mvale) + ',' + Transform(moperador) + ')'
	lccomenta = "CONFG" + '-' + Alltrim(str(mvale,16,0))

	If !Inlist(mwkAux.ser_codserv,7900, 7400, 5163, 4403, 9100)
		If Val(mwkAux.CONFORMADO)=0
			Do MPPS With lcsqlmpps 
		Endif 	
		If Val(mwkAux.CONFORMADO)=0
			Do Pacs With lcsqlpacs
		Endif 
	Endif 
	If Val(mwkAux.CONFORMADO)=0
		Do Informe With lcsqlinf
	Endif 
	
	If Val(mwkAux.CONFORMADO)=0
		Do ValeRela
	Endif
		
	If Vartype(olevism) = "O"
		olevism.mserver = ""
		olevism.namespace = ""
		prg_olevism_reset(olevism)
	Endif 

	Select mwkAux
Endscan 

olevism.parent.release
Release olevism

*!*	If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
*!*		Return .f.
*!*	Endif 


*!*	------------------------------------------------------------------------
Procedure ValeRela
*!*	------------------------------------------------------------------------


TEXT To lcsqlrela1 Textmerge Noshow Pretext 7
	select b.ID, b.estadoinforme 
		  	from TabValeRelacion a
		  	inner join informes b on a.NroValeRelacionado = b.nrovale
		  	where a.NroValeOriginal = ?mwkaux.VAL_codvaleasist and 
		  	estadoinforme < 5 and FecPasiva = '1900-01-01'
Endtext


If SqlExec(mcon1,lcsqlrela1,"mwkAuxI")<=0
	Aerror(eros)
	?eros(3)
	Return .F.
Endif


If Reccount("mwkAuxI") > 0

	If Reccount("mwkAuxI")>1
		replace inf With "-1" In mwkAux
	Else
		If Reccount("mwkAuxI")=1
			If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
				Return .f.
			Endif 
			replace inf With "1" In mwkAux
			replace CONFORMADO With "1" In mwkAux
		Else
			replace inf With "0" In mwkAux
		endif
	endif


Else
	Use In Select("mwkAuxI")
	TEXT To lcsqlrela2 Textmerge Noshow Pretext 7

	select b.ID, b.estadoinforme 
		  	from TabValeRelacion a
		  	inner join informes b on a.NroValeOriginal = b.nrovale
		  	where NroValeRelacionado = ?mwkaux.VAL_codvaleasist and 
		  	estadoinforme < 5 and FecPasiva = '1900-01-01'

	Endtext


	If SqlExec(mcon1,lcsqlrela2,"mwkAuxI")<=0
		Aerror(eros)
		?eros(3)
		Return .F.
	Endif		
	
	***--------
	If Reccount("mwkAuxI")>1
		replace inf With "-1" In mwkAux
	Else
		If Reccount("mwkAuxI")=1
			If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
				Return .f.
			Endif 
			replace inf With "1" In mwkAux
			replace CONFORMADO With "1" In mwkAux
		Else
			replace inf With "0" In mwkAux
		endif
	endif		  	

Endif 

*!*	------------------------------------------------------------------------
Procedure Informe
Parameters lcsqlinf
*!*	------------------------------------------------------------------------
If SqlExec(mcon1,lcsqlinf,"mwkAuxI")<=0
	Aerror(eros)
	?eros(3)
	Return .F.
Endif

If Reccount("mwkAuxI")>1
	replace inf With "-1" In mwkAux
Else
	If Reccount("mwkAuxI")=1
		If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
			Return .f.
		Endif 
		replace inf With "1" In mwkAux
		replace CONFORMADO With "1" In mwkAux
	Else
		replace inf With "0" In mwkAux
	endif
endif	
*!*	------------------------------------------------------------------------
Procedure MPPS
Parameters lcsqlMPPS
*!*	------------------------------------------------------------------------

If SqlExec(mcon1,lcsqlMPPS,"mwkAuxM")<=0
	Aerror(eros)
	?eros(3)
	Return .F.
Endif

If Reccount("mwkAuxM")>1
	replace mpps With "-1" In mwkAux
Else
	If Reccount("mwkAuxM")=1
		If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
			Return .f.
		Endif 
		
		replace mpps With "1" In mwkAux
		replace CONFORMADO With "1" In mwkAux
	Else
		replace mpps With "0" In mwkAux
	endif
endif

*!*	------------------------------------------------------------------------
Procedure Pacs
Parameters lcsqlpacs
*!*	------------------------------------------------------------------------

If SqlExec(mcon1,lcsqlpacs,"mwkAuxP")<=0
	Aerror(eros)
	?eros(3)
	Return .F.
Endif
	
If Reccount("mwkAuxP")>1
	replace pacs With "-1" In mwkAux
Else
	If Reccount("mwkAuxP")=1
		If !execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
			Return .f.
		Endif 
		replace pacs With "1" In mwkAux
		replace CONFORMADO With "1" In mwkAux
	Else
		replace pacs With "0" In mwkAux
	endif
endif	

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



*!*	-------------------------------------
Function conforme
*!*	-------------------------------------



	mgraba = '1'
	
	mvale  = alltrim(str(mwkValeAsist.val_codvaleasist))
	moperador	= iif(mwkusuarios.codigovax = 0, '99999', str(mwkusuarios.codigovax, 5))

	.olevism.mserver	= alltrim(mwktabcfg.oleserver)
	.olevism.namespace	= alltrim(mwktabcfg.olespaces)
	
	=prg_olevism_reset(.olevism)

	.olevism.code = "D CONFTOTAL^RTN031("+ mgraba + ','+ mvale + ','+ moperador + ')'
	.olevism.execflag = 1

	mmsgerr = .olevism.errorname
	
	if !empty(mmsgerr)
		do sp_insert_tabctrlerr with .olevism.code, mmsgerr , moperador, .name
		messagebox ("ERROR EN CONFORME DEL VALE...", 48, 'VALIDACION')
		.OleVismOff()
		Return .f.
	Endif 
	
	mok		= .olevism.p0					&& Codigo de error
	
	if .olevism.p0 <> ''
		mcoderr = val(thisform.olevism.p0)
		do sp_busco_texto_error with mcoderr && mwktaberror
		
		MESSAGEBOX(ALLTRIM(MWKTABERROR.TEXTOERROR), 48, 'VALIDACION')
		mmsgerr = "V:" +  alltrim(thisform.olevism.p1) + "-" + alltrim(mwktaberror.textoerror)
		
		do sp_insert_tabctrlerr with thisform.olevism.code, mmsgerr , moperador, .name
		messagebox ("ERROR EN CONFORME DEL VALE...", 48, 'VALIDACION')
		.OleVismOff()
		Return .f.
	Endif
	
	.OleVismOff()
