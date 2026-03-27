Clear
*Public mcon1
mcon1 = SQLConnect("conec01")
lcDir = "c:\SAP\"
lcArc = "sap_medico2.txt"
lbProcesar = .T.
mnarch = Fcreate(lcArc)
*  SELECT * FROM prestadores WHERE  id = 1008  INTO CURSOR presta
*!*	Select * From prestadores Where Id>1 And Nvl(tpf_filtro,6)=6 And ;
*!*	(fecpasivap=Ctod("01/01/1900") Or fecpasivap>=Ctod("01/08/2019")) AND ;
*!*	VAL(cuil)>10 AND cuil#'27-32359666-8' AND  VAL(matriculas) NOT in (SELECT matri FROM medsap)  Into Cursor presta
Select * From prestadores Where Id>1 And Nvl(tpf_filtro,6)=6 And ;
(fecpasivap=Ctod("01/01/1900") Or fecpasivap>=Ctod("01/08/2019")) AND ;
val(cuil)>10 AND cuil#'27-32359666-8' AND cuil NOT in (SELECT cuit FROM cuitmed)  Into Cursor presta


*Select * From prestadores Where Id in (SELECT codmed FROM medsap) Into Cursor presta
USE DBF('PRESTA') IN 0 AGAIN ALIAS PRESTAA
Use c:\desaguemes\Provincia.Dbf In 0 Shared
*!*	WHERE {FN Year(REG_FECHAALTA)} = 2018 ORDER BY REG_NROREGISTRAC DESC

*!*	If !Used("MWKPRESTA") Or lbProcesar
*!*		mret = SQLExec(mcon1,"SELECT * FROM PRESTADORES "+;
*!*			" where fecpasivap = '1900-01-01' or fecpasivap > current_Date","MWKPRESTA")
*!*		If mret <=0
		Set Step On
*!*		Endif
*!*	ENDIF
Select * From prestaa Into Cursor MWKPRESTA
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
	If Val(Nvl(MWKPRESTA.cuil,''))>10

		m1 = Alltrim(MWKPRESTA.APE)
		m1 = Strtran(m1, ',', " ")
		m2 = Alltrim(MWKPRESTA.nom)
		m2 = Strtran(m2, ',', " ")
		m3 = MWKPRESTA.sexo
		MFECNA = Iif(MWKPRESTA.fecnac= Ctod("01/01/1900") Or MWKPRESTA.fecnac>Ctod("16/07/1998");
			,Ctod("16/07/1990"),MWKPRESTA.fecnac)
		m4 = Dtoc(MFECNA)

		Select mwkprofesion
		Locate For mwkprofesion.Id = MWKPRESTA.codprof
		m5 = TituloProf(mwkprofesion.Id)

		m6 = TipoDocumento(0)
		m7 = Alltrim(Nvl(MWKPRESTA.cuil,''))
		m7 = Strtran(m7, '-', "")

		m8 = 1
		m9 = Nacionalidad()
		mdomi = Iif(Empty(MWKPRESTA.domicilio),"ACUÑA DE FIGUEROA 1228",MWKPRESTA.domicilio)
		m10 = Alltrim(mdomi)
		m10 = Strtran(m10, ',', " ")
		m11 = "AR" && PAIS
		m12 = MWKPRESTA.codpostal
		m13 = Localidad(MWKPRESTA.codloca)
		m14 = Provincia(MWKPRESTA.codpcia)
		m15 = MWKPRESTA.telefono
		m16 = MWKPRESTA.telcelular
		m17 = "49598200"
		cmail = Nvl(MWKPRESTA.email,"")

*	if !prg_valido_mail(cmail)
		cmail =''
*	endif
		m18 = cmail
		m19 = "X"  && Personal Asistencial
		m20 = '' && Medico Externo
		m21 = "" && Empleado
		m22 = "" && Enfermero
		m23 = Jerarquia(MWKPRESTA.enreldep) && Jerarquia
		m24 = "01012018" && Validez

		m25 = Iif(Val(MWKPRESTA.matriculas)>0,Alltrim(MWKPRESTA.matriculas),"") && Registro Medico
		m26 = MWKPRESTA.codesp
		IF ALLTRIM(m26)="CGP"
			m26 = 'CGPE'
		endif
		m27 = "" && Especialidad 2
		m28 = "" && Especialidad 3
		m29 = Transform(MWKPRESTA.Id ) && Nro Interlocutor Externo
		mccad = ''
		For I = 1 To 29
			Mvar = "m" + Alltrim(Transform(I))
			mccad = mccad  + Transform(&Mvar)+ Iif(I<29,Chr(9),'')
		Next
		Fputs(mnarch, mccad)
		Wait Windows Transform(K)+MWKPRESTA.nombre Nowait
		K = K + 1
		Select MWKPRESTA
	Endif
Endscan
Fclose(mnarch)

*Sqldisconnect(mcon1)
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
Function Especialidad(lcCodEsp)


Return lcCodEsp

*--------------------------------------------------------------------------------------

Function Jerarquia(lnJe)

Do Case
Case lnJe = 1
	lnResu  = "REL"
Case lnJe = 2
	lnResu = "HON"
Case lnJe = 3
	lnResu = "RES" &&&"CUR"
Case lnJe = 4
	lnResu = "RES"

Otherwise
	mid = MWKPRESTA.Id
	mret = SQLExec(mcon1,"SELECT CodProf, nivel, CodCargo,descrip"+;
		" FROM Tabcargo,Tabprofesp "+;
		" WHERE  CodProf = ?mid and Tabprofesp.CodCargo = Tabcargo.ID  ORDER BY nivel ","mwkprof")
	If Reccount('mwkprof')=0
		lnResu  = "REL"
	Else
		Select mwkprof
		Go Bottom
		lnResu = Iif(Left(Descrip,5)="Cursi","RES",Iif(Left(Descrip,5)="Resid","RES","REL") )
	Endif
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
	lcResu = "CT"

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

