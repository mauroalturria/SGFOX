CREATE CURSOR coseguros (censan c(4),Univoc c(32),Fecha c(10),Tipo c(2),Paciente c(10) ;
	,Episodio c(10),Servicio c(10),Valor c(15),factura c(32),fechafac c(10),ncredito c(32),fechanc c(10))
DO sp
	mtFHoraD = dtot(.txtfecdes.value)
	mtFHoraH = dtot(.txtfechas.value+1)

*!*	    do sp_control_caja with mtFHoraD ,mtFHoraH , .txtpvta.value,.ChkTotal.value
*!*		if .ChkTotal.value = 1
*!*			update MWKFacturacion set fechacte = mtFHorah
*!*			update MWKFacturacion set fechacte = Ctod("")
*!*		endif
*!*		report form repcaja06 preview
*!*		use in MWKFacturacion

	if !used("MWKFacturacion0")
		do sp_control_caja with mtFHoraD ,mtFHoraH , .txtpvta.value ,.mpvtatodos
	endif

	select MWKFacturacion0.*,tipopuntoventa  ;
		from MWKFacturacion0 ;
		inner join mwkmispv on ptovta= PuntodeVenta into cursor MWKFacturacion0

	select MWKFacturacion0
	if reccount("MWKFacturacion0") = 0
		messagebox("No hay información para ese período",48,"Validacón")
		return
	endif

	do case
		case .optTipo.value = 1

			if .chkDetalle.value = 1

				select * ;
					from MWKFacturacion0 ;
					order by fechacte, usuario ;
					into cursor MWKFacturacion

				select MWKFacturacion
				report form repcaja00a preview

*!*	fechacte, ptovta, usuario, idusuario, nomape, .f. as fechacte2, ;
*!*						importe* iif(tpocte=5,-1,1) As saldocaja
			else
				select fechacte, ptovta, usuario, idusuario, nomape, .f. as fechacte2,  ;
					sum(iif(inlist(tpocte,5,7),importe,0)) as saldocajaNC,;
					sum(iif(!inlist(tpocte,5,7) and tipopuntoventa = 0,importe,0)) as saldocajafc, ;
					sum(iif(!inlist(tpocte,5,7) and tipopuntoventa = 1,importe,0)) as saldocajafcm ;
					from MWKFacturacion0 ;
				group by fechacte, usuario ;
					order by fechacte, usuario;
					into cursor MWKFacturacion

				select MWKFacturacion
				report form repcaja06t preview
			endif

		case .optTipo.value = 2
			select ctod("") as fechacte, ptovta, "" as usuario, "" as idusuario, "" as nomape, fechacte as fechacte2,;
				sum(iif(inlist(tpocte,5,7),importe,0)) as saldocajaNC,;
				sum(iif(!inlist(tpocte,5,7) and tipopuntoventa = 0,importe,0)) as saldocajafc, ;
				sum(iif(!inlist(tpocte,5,7) and tipopuntoventa = 1,importe,0)) as saldocajafcm ;
				from MWKFacturacion0 ;
				group by fechacte ;
				order by fechacte;
				into cursor MWKFacturacion

			select MWKFacturacion
			report form repcaja06t preview

		case .optTipo.value = 3
			select ctod("") as fechacte, ptovta, usuario, idusuario, nomape, .f. as fechacte2, ;
				sum(iif(inlist(tpocte,5,7),importe,0)) as saldocajaNC,;
				sum(iif(!inlist(tpocte,5,7) and tipopuntoventa = 0,importe,0)) as saldocajafc, ;
				sum(iif(!inlist(tpocte,5,7) and tipopuntoventa = 1,importe,0)) as saldocajafcm ;
				from MWKFacturacion0 ;
				group by usuario ;
				order by usuario ;
				into cursor MWKFacturacion

			select MWKFacturacion
			report form repcaja06t preview

	endcase


endwith


Select  admisiones
Scan
	mnroreg = admisiones.pac_codhci
	mnroadm = admisiones.pac_codadm
	mcodent  = 0
	MNUMDOC = 0
	minifec = Ctod("01/01/1900")
	mnroafi = ''
	Requery('vales_realprest')
	If Reccount( "vales_realprest")>0
		Select vales_realprest
		Go Top
		mivale = 0
		Do While !Eof()
*	1				2			3			4			5				6			7				;
8		9		10			11				12			13			14			15
*TIPOPAC_AMB	TIPOPAC_GUA	TIPOPAC_INT	CODADMISION	CODVALEASIST	FECHASOLICITUD	HORASOLICITUD	;
PISO	NUMERO	DESCRIP	URGENCIASERV	CODSERVVALE	PRESTADOR	OPERADORCARGA	OPERADORCONFORME
			mivale = vales_realprest.VAL_codvaleasist
			m1 = Iif( admisiones.pac_tipop2=2,"X","")
			m2 = Iif( admisiones.pac_tipop2=3,"X","")
			m3 = Iif( admisiones.pac_tipop2<2,"X","")
			m4 = Alltrim(mnroadm )
			m5 = Alltrim(Transform(vales_realprest.VAL_codvaleasist))
			m6 = Alltrim(Transform(vales_realprest.VAL_fechasolicitud))
			m7 = Right("0"+Alltrim(Ttoc(vales_realprest.VAL_FHSolicitud,2)),8)
			m8 = ''
			m9 = ''
			m10= ''
			m11= Iif(VAL(vales_realprest.VAL_urgenciaserv)=1,"U","")
			m12= Alltrim(Transform(vales_realprest.VAL_codservvale))
			m13=  Alltrim(Transform(Nvl(vales_realprest.VAL_prestador,306)))
			m14= Alltrim(Transform(vales_realprest.VAL_OperadorCarga))
			m15 =  Alltrim(Transform(vales_realprest.VAL_OperadorConforme))
			For I = 1 To 15
				oExcel.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
			Next
			K = K + 1
			Do While !Eof() And mivale = vales_realprest.VAL_codvaleasist
				mivale = vales_realprest.VAL_codvaleasist
*						CODVALEASIST	CODPREST	CANTSOLICITADA	ESPECIALIDAD

				m1 = Alltrim(Transform(vales_realprest.VAL_codvaleasist))
				m2 =  Alltrim(Transform(vales_realprest.PRE_codprest))
				m3 = Alltrim(Transform(vales_realprest.PIA_cantsolicitada))
				m4 = Alltrim(Transform(vales_realprest.PRE_especialidad))
				For I = 1 To 4
					oExceld.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
				Next
				L = L + 1
				Skip
			Enddo
			mivale = vales_realprest.VAL_codvaleasist
		Enddo
	Endif
Endscan


oExcel.ScreenUpdating = .T.
oExceld.ScreenUpdating = .T.

*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion
*!*	Select admisiones
*!*	Scan
*!*		mnrohclin = h_clinica
*!*		mtfhoy = ingreso - 24 * 3600 * 1 &&(2 dias antes)
*!*		mret = SQLExec(mcon1, "select REG_nroregistrac  "+;
*!*			" FROM Registracio "+ ;
*!*			" where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")

*!*		mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*		Do sp_busco_protocolo_paciente With mbusca,0,'','protocolo,codprest'
*!*		Select mwkguardia
*!*		Go Top
*!*		If Reccount( "mwkguardia")>0
*!*			cdiag = codcie9
*!*			Select admisiones
*!*			Replace codcie1 With cdiag
*!*		Else
*!*			mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*			Do sp_busco_protocolo_paciente With mbusca,0,1,'protocolo,codprest'
*!*			Select mwkguardia
*!*			Go Top
*!*			If Reccount( "mwkguardia")>0
*!*				cdiag = codcie9
*!*				Select admisiones
*!*				Replace codcie1 With cdiag
*!*			Endif

*!*		Endif
*!*	Endscan
*!*	Select  hclini
*!*	Scan
*!*		mnrohclin = hclini.hclinica
*!*		mret = SQLExec(mcon1, "select HIS_codentidad ,HIS_fechaadmision "+;
*!*			" FROM Registracio,histambgua "+ ;
*!*			" where  his_nroregistrac = REG_nroregistrac and "+;
*!*			" REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")
*!*		If Reccount( "mwkbuspacie")>0
*!*			Go Bott
*!*			mcodent  = HIS_codentidad
*!*			Select  hclini
*!*			Replace codent With mcodent
*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion

*!*	Do sp_conexion
*!*	Set Step On
*!*	Select  hclin
*!*	Scan
*!*		If hclin.entidad = 0

*!*			Wait Windows Transform(Recno()) Nowait
*!*			mctexto = Alltrim(hclin)
*!*			mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac" + ;
*!*				" FROM afiliacion, registracio " + ;
*!*				" where REG_nrohclinica = ?mctexto and AFI_fechabaja is null  "+;
*!*				" and registracio.REG_nroregistrac = afiliacion.registracio and  afiliacion.AFI_codentidad = 948 " , "mwkbuspacie")
*!*			If Reccount( "mwkbuspacie")>0
*!*				Select  hclin
*!*				Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 948
*!*			Else
*!*				mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac" + ;
*!*					" FROM afiliacion, registracio " + ;
*!*					" where REG_nrohclinica = ?mctexto and AFI_fechabaja is null  "+;
*!*					" and registracio.REG_nroregistrac = afiliacion.registracio and afiliacion.AFI_codentidad = 945 " , "mwkbuspacie")
*!*				If Reccount( "mwkbuspacie")>0
*!*					Select  hclin
*!*					Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 945
*!*				Endif

*!*			Endif
*!*			mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac,AFI_fechabaja " + ;
*!*				" FROM afiliacion, registracio " + ;
*!*				" where REG_nrohclinica = ?mctexto "+;
*!*				" and registracio.REG_nroregistrac = afiliacion.registracio and  afiliacion.AFI_codentidad = 948 " , "mwkbuspacie")
*!*			If Reccount( "mwkbuspacie")>0
*!*				Select  hclin
*!*				Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 948,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  "))
*!*			Else
*!*				mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac,AFI_fechabaja " + ;
*!*					" FROM afiliacion, registracio " + ;
*!*					" where REG_nrohclinica = ?mctexto  "+;
*!*					" and registracio.REG_nroregistrac = afiliacion.registracio and afiliacion.AFI_codentidad = 945 " , "mwkbuspacie")
*!*				If Reccount( "mwkbuspacie")>0
*!*					Select  hclin
*!*					Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 945,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  "))
*!*				Endif

*!*			Endif

*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion
*!*	Select admisiones
*!*	Scan
*!*		mnrohclin = h_clinica
*!*		mtfhoy = ingreso - 24 * 3600 * 1 &&(2 dias antes)
*!*		mret = SQLExec(mcon1, "select REG_nroregistrac  "+;
*!*			" FROM Registracio "+ ;
*!*			" where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")

*!*		mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*		Do sp_busco_protocolo_paciente With mbusca,0,'','protocolo,codprest'
*!*		Select mwkguardia
*!*		Go Top
*!*		If Reccount( "mwkguardia")>0
*!*			cdiag = codcie9
*!*			Select admisiones
*!*			Replace codcie1 With cdiag
*!*		Else
*!*			mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*			Do sp_busco_protocolo_paciente With mbusca,0,1,'protocolo,codprest'
*!*			Select mwkguardia
*!*			Go Top
*!*			If Reccount( "mwkguardia")>0
*!*				cdiag = codcie9
*!*				Select admisiones
*!*				Replace codcie1 With cdiag
*!*			Endif

*!*		Endif
*!*	Endscan
*!*	Select valestc
*!*	Scan
*!*		mvale = valestc.vale
*!*		mret = SQLExec(mcon1, " select PRE_codprest, PRE_descriprest  FROM Valesasist,"+;
*!*			" Presinsuvas, Prestacions WHERE PIA_VALESASIST = VALESASIST " +;
*!*			"  AND PRE_codprest = PIA_codprest "+ ;
*!*			" and val_codvaleasist = ?mvale " +;
*!*			" " , "mwkdatos")
*!*		If mret<0
*!*			=Aerr(eros)
*!*			Messagebox(eros(3))
*!*		Endif
*!*		Select valestc
*!*		If Reccount("mwkdatos")>0
*!*			Replace codprest With mwkdatos->PRE_codprest,Descrip With mwkdatos->PRE_descriprest
*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion
*!*	Select diasmarzo
*!*	Scan
*!*		admi = NRO_ADMISI
*!*		Requery('lugarinterna')
*!*		Select * From lugarinterna ;
*!*			where LUG_fechaingreso <Ctod("01/04/2017") And Nvl(LUG_fechaegreso,Ctod("01/01/2100"))>=Ctod("01/03/2017") ;
*!*			into Cursor ucis



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
	lcResu = ""

Endcase
