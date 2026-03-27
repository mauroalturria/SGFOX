Clear
Public mcon1
*mcon1 = Sqlconnect("172.16.9.200")
lcDir = "c:\SAP\IS-H\"
lcArc = "02_FORMATO_MCARGUE_DICCIONARIO_Médicos.xlsx"
lbProcesar = .T.

Public oExcel As Excel.Application
oExcel = Createobject("Excel.application")
oExcel.ScreenUpdating = .F.
oExcel.Visible = .T.

oExcel.Workbooks.Open(lcDir + lcArc)
oExcel.Sheets("Matriz de Cargue").Select
lnRow = 18
*oExcel.Workbooks.Close(0)

*!*	WHERE {FN Year(REG_FECHAALTA)} = 2018 ORDER BY REG_NROREGISTRAC DESC

If !Used("MWKPRESTA") Or lbProcesar
	mret = SQLExec(mcon1,"SELECT * FROM PRESTADORES "+;
		" where fecpasivap = '1900-01-01' or fecpasivap > current_Date","MWKPRESTA")
	If mret <=0
		Set Step On
	Endif
Endif
mret = SQLExec(mcon1,"SELECT * FROM tabprofesion","mwkprofesion")
If mret <=0
	Set Step On
Endif
mret = SQLExec(mcon1,"SELECT * FROM tabloca","mwkloca")
If mret <=0
	Set Step On
Endif
mret = SQLExec(mcon1,"SELECT * FROM tabPCIA","mwkpcia")
If mret <=0
	Set Step On
Endif




K = 0
Select MWKPRESTA
Scan All


	m1 = Alltrim(MWKPRESTA.APE)
	m2 = Alltrim(MWKPRESTA.nom)
	m3 = MWKPRESTA.sexo
	m4 = Dtoc(MWKPRESTA.fecnac)

	Select mwkprofesion
	Locate For mwkprofesion.Id = MWKPRESTA.codprof
	m5 = TituloProf(mwkprofesion.Id)

	m6 = TipoDocumento(0)
	m7 = Alltrim(Nvl(MWKPRESTA.cuil,''))
	m8 = 1
	m9 = Nacionalidad()
	m10 = Alltrim(MWKPRESTA.domicilio)
	m11 = "AR" && PAIS
	m12 = MWKPRESTA.codpostal
	m13 = Localidad(MWKPRESTA.codloca)
	m14 = Provincia(MWKPRESTA.codpcia)
	m15 = MWKPRESTA.telefono
	m16 = MWKPRESTA.telcelular
	m17 = "49598200"
	m18 = MWKPRESTA.email
	m19 = "X"  && Personal Asistencial
	m20 = '' && Medico Externo
	m21 = "" && Empleado
	m22 = "" && Enfermero
	m23 = Jerarquia(MWKPRESTA.codprof) && Jerarquia
	m24 = "01012018" && Validez

	m25 = MWKPRESTA.matriculas && Registro Medico
	m26 = MWKPRESTA.codesp
	m27 = "" && Especialidad 2
	m28 = "" && Especialidad 3
	m29 = Transform(MWKPRESTA.Id) && Nro Interlocutor Externo

	For I = 1 To 29
		oExcel.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
	Next


	K = K + 1
	Select MWKPRESTA
Endscan

oExcel.ScreenUpdating = .T.


*Sqldisconnect(mcon1)
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
Function Especialidad(lcCodEsp)


Return lcCodEsp

*--------------------------------------------------------------------------------------

Function Jerarquia(lnJe)

Do Case
Case lnJe = 1
	lnResu  = 8
Case lnJe = 2
	lnResu = 2
Case lnJe = 3
	lnResu = 6
Case lnJe = 4
	lnResu = 4
Case lnJe = 5
	lnResu = 5
Case lnJe = 6
	lnResu = 1
Case lnJe = 7
	lnResu = 1

Otherwise
	lnResu  = 8

Endcase
*!*	codprof
*!*	1 Nada
*!*	2 medico
*!*	3 tecnico
*!*	4 licenc
*!*	5 enfer
*!*	6 bioqui
*!*	7 facrmac

*!*	1	Especialista
*!*	2	Médico General
*!*	3	Médico Res1
*!*	4	Licenciado
*!*	5	Enfermera
*!*	6	Técnico
*!*	7	Auxiliares
*!*	8	Otros

Return lnResu
*--------------------------------------------------------------------------------------
Function Nacionalidad()
*--------------------------------------------------------------------------------------

*!

Return "AR"
*--------------------------------------------------------------------------------------
Function Localidad(lnLoca)

Select mwkloca
Locate For Id = lnLoca

Return Nvl(mwkloca.Descrip,'')
*--------------------------------------------------------------------------------------
Function Provincia(lnProv)

Select Provincia
Locate For Id = lnProv
If Eof()
	Go Top
Endif
Return codsap
*--------------------------------------------------------------------------------------
Function TituloProf(lnProf)

lcResu = Transform(lnProf,"@L 9999")
Return lcResu


Function TipoDocumento(lnTipo)
Do Case
Case lnTipo = 1
	lcResu = 'LE' &&	Libreta de Enrolamiento
Case lnTipo = 2
	lcResu = 'LC' && 	Libreta cívica
Case lnTipo = 3
	lcResu = 'CI' &&	Cédula de identidad
Case lnTipo = 4
	lcResu = 'DI' && 	Documento Nacional de Identificación
Case lnTipo = 5
	lcResu = 'PA' &&	Pasaporte
Case lnTipo = 6
	lcResu = 'LM' &&	Libreta de Matrimonio
Case lnTipo = 7
	lcResu = 'LF' &&	Libreta Familiar
Case lnTipo = 9
	lcResu = 'OT' &&	Otros

Otherwise
	lcResu = "CUIT"

Endcase
Return lcResu
*!*	TD	Tipo Documento
*!*	DNI	Documento Nacional de Identificación
*!*	CI	Cédula de identidad
*!*	LE	Libreta de Enrolamiento
*!*	LC	Libreta cívica
*!*	LF	Libreta Familiar
*!*	OT	Otros
*!*	PA	Pasaporte
*!*	LM	Libreta de Matrimonio
*!*	CUIT	Clave Único de Ident. Tributaria
*!*	CUIL	Clave Única de Ident. Laboral


Return lcResu

