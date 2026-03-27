*
* Actualizo Nro de registración por unificación
*

Parameters oldreg,newreg,idevol

mSigo = .T.

If Vartype(oldreg)='N'
	moldreg = Alltrim(Str(oldreg))
Else
	mSigo = .F.
Endif

If Vartype(newreg)='N'
	mnewreg = Alltrim(Str(newreg))
Else
	mSigo = .F.
Endif

If Vartype(idevol)='N'
	midevol = Alltrim(Str(idevol))
Endif

If !mSigo
	Messagebox('Problemas con los datos recibidos',0,'AVISO')
	Return .F.
Endif


Create Cursor mwkTablasNeo (tabla c(30), campo c(30), prefijo c(3))

Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoAntecApgar','NAA_registracioRN','NAA')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoAntecDatosParto','NDP_nroregistraRN','NDP')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoAntecMatCom','AMC_registracioRN','AMC')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoAntecMatMed','AMM_registracionRN','AMM')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoAntecMatPlus','AMP_registracionRN','AMP')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoAntecMaterno','NAM_registracioRN','NAM')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoAntecNacimiento','NAN_registracioRN','NAN')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEAbdomen','ABD_nroregistraRN','ABD')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEAntro','ANT_nroregistraRN','ANT')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEAspecto','ASP_nroregistraRN','ASP')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIECardio','CAR_nroregistraRN','CAR')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEHemato','HEM_nroregistraRN','HEM')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEInfecto','INF_nroregistraRN','INF')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEMalforma','MAL_nroregistraRN','MAL')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEMetabolico','MET_nroregistraRN','MET')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIENeuro','NEU_nroregistraRN','NEU')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIENutri','NUT_nroregistraRN','NUT')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEOftalmo','OFT_nroregistraRN','OFT')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEOseo','OSE_nroregistraRN','OSE')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEPiel','PIE_nroregistraRN','PIE')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIEQuiro','QUI_nroregistraRN','QUI')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoIERespira','RES_nroregistraRN','RES')
Insert Into mwkTablasNeo (tabla,campo,prefijo) Values ('ZabNeoVarios','VAR_nroregistraRN','VAR')

Select mwkTablasNeo

Scan All
	mTabla = Alltrim(mwkTablasNeo.tabla)
	mcampo = Alltrim(mwkTablasNeo.campo)
	mprefijo = Alltrim(mwkTablasNeo.prefijo)
	If Vartype(idevol)='N'
		lcWhere = ' Where ' + mprefijo + '_idevol = ' + midevol
	Else
		lcWhere = ' Where ' + mcampo + ' = ' + moldreg
	Endif
	lcSQL = 'Update ' + mTabla + ' Set ' + mcampo + ' = ' + mnewreg + lcWhere
	If !Prg_EjecutoSql(lcSQL)
		Messagebox('Error en la tabla ' + mTabla,0,'Error de Actualización de Registración')
	Endif
Endscan

