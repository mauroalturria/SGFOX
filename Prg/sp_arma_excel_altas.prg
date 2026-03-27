Lparameters oleapp,mFecDesde,mFecHasta,mEntidades

**Thisform.pentidades
Local mTelefono
Local mAfiliacion


If Alltrim(mEntidades) = "876"  && PAMI
	oleapp.workbooks.Open(Alltrim(zzvolumen) + "\qepd1a1\xlt\altas_pami.xlt")
	**oleapp.cells(5,11).value 	= "Telefonos"
Else
	oleapp.workbooks.Open(Alltrim(zzvolumen) + "\qepd1a1\xlt\altas.xlt")
	oleapp.cells(5,27).value 	= "Telefonos"
Endif

oleapp.cells(3,2).Value = "Periodo del " + Dtoc(mFecDesde) + ;
	" al " + Dtoc(mFecHasta)
**oleapp.cells(5,26).value 	= "Nro Afiliado"


i = 6

Select mwkpacalta
Go Top
Do While !Eof("mwkpacalta")

	Wait "CARGANDO PLANILLA DE EXCEL"  + Str(Recno(), 5) Windows Nowait

** --------------- Buscamos nro. de afiliado y los documentos
	mCodEntidad = mwkpacalta.cob_codentidad
	mRegistracio = mwkpacalta.reg_nroregistrac
	mAfiliacion = ""
	mTelefono = ""

**mret = SQLExec(mcon1,"select * from afiliacion where registracio = ?mRegistracio and afi_codentidad = ?mCodEntidad","mwkAfiliacio")
	mret = SQLExec(mcon1,"select a.Afi_nroafiliado,b.REG_telefonos,NVL(c.TRT_numero,'') as numero " +;
		"from afiliacion as a " +;
		"left join Registracio as b on a.registracio = b.registracio " +;
		"left join TabRegTel as c on a.registracio = c.TRT_registracio " +;
		"where a.registracio = ?mRegistracio and a.afi_codentidad = ?mCodEntidad","mwkAfiliacio")

	If mret < 0
		Messagebox("ERROR EN LA LECTURA DE AFILIADOS",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Else
		Select mwkAfiliacio
		Go Bottom

		mAfiliacion = mwkAfiliacio.Afi_nroafiliado
		mTelefono = IIF(!EMPTY(ALLTRIM(mwkAfiliacio.REG_telefonos)),ALLTRIM(mwkAfiliacio.REG_telefonos)+"/ ","")
		
		Go Top
		Scan All
			If !Empty(Nvl(mwkAfiliacio.numero,""))
				If At(Alltrim(mwkAfiliacio.numero),mTelefono) = 0
					mTelefono = mTelefono + Alltrim(mwkAfiliacio.numero) + "/ "
				Endif
			Endif
		Endscan
	Endif

	If !Empty(mTelefono)
		mTelefono = Left(mTelefono,Len(mTelefono)-2)
	Endif

	Use In Select("mwkAfiliacio")
** -----------------------------------------

	Select mwkpacalta

	If Alltrim(mEntidades) = "876"  && PAMI

		oleapp.cells(i,02).Value = mwkpacalta.PAC_nombrepaciente
		oleapp.cells(i,03).Value = mAfiliacion
		oleapp.cells(i,04).Value = mwkpacalta.pac_fechaadmision
		oleapp.cells(i,05).Value = mwkpacalta.pac_fechaalta
		oleapp.cells(i,06).Value = Nvl(mwkpacalta.REG_numdocumento,"")
		oleapp.cells(i,07).Value 	= Nvl(mwkpacalta.ORICodAutoriz,'')
		oleapp.cells(i,08).Value = mwkpacalta.pac_descripdiagn
		oleapp.cells(i,09).Value = Nvl(mwkpacalta.PAC_descripdiagegr,'')
**oleapp.cells(i,08).Value = Nvl(mwkpacalta.descripegralt,'')
**oleapp.cells(i,09).Value 	= Iif(mwkpacalta.denuncia>0 And mwkpacalta.denuncia<11,"Den.OBITO",Iif(mwkpacalta.denuncia>10 ,"Den.ALTA",''))
		oleapp.cells(i,10).Value = mwkpacalta.MTE_descripcion		
		oleapp.cells(i,11).Value = Alltrim(mwkpacalta.PAC_nombrerespons)
		oleapp.cells(i,12).Value = "'"+Alltrim(mTelefono)

	Else

		oleapp.cells(i,02).Value = mwkpacalta.pac_codadmision
		oleapp.cells(i,03).Value = PAC_nombrepaciente
		oleapp.cells(i,04).Value = mwkpacalta.pac_fechaadmision
		oleapp.cells(i,05).Value = mwkpacalta.pac_fechaalta
		oleapp.cells(i,06).Value = Hora
		oleapp.cells(i,07).Value = mwkpacalta.ENT_codent
*								oleapp.cells(i,09).Value = Alltrim(mwkpacalta.ent_descrient)
		oleapp.cells(i,8).Value    = mAfiliacion
		Select mwkpacalta

		oleapp.cells(i,9).Value = mwkpacalta.PAC_sectorinternac
		oleapp.cells(i,10).Value = Alltrim(mwkpacalta.MTE_descripcion)
		oleapp.cells(i,11).Value = Alltrim(mwkpacalta.ANIOS)
		oleapp.cells(i,12).Value = mwkpacalta.pac_descripdiagn
		oleapp.cells(i,13).Value = mwkpacalta.operalta
		oleapp.cells(i,14).Value = mwkpacalta.PAC_descripdiagegr
		oleapp.cells(i,15).Value = Nvl(mwkpacalta.descripegr,'')
**oleapp.cells(i,17).Value = Nvl(mwkpacalta.PAC_categoria,'')
		oleapp.cells(i,16).Value 	= mwkpacalta.PAC_codhce
		oleapp.cells(i,17).Value 	= mwkpacalta.PAC_fecnacimiento
		oleapp.cells(i,18).Value 	= mwkpacalta.pac_sexo
		oleapp.cells(i,19).Value 	= Nvl(mwkpacalta.DocInCompl,'')
		oleapp.cells(i,20).Value 	= Nvl(mwkpacalta.ORICodAutoriz,'')
		oleapp.cells(i,21).Value 	= Iif(mwkpacalta.denuncia>0 And mwkpacalta.denuncia<11,"Den.OBITO",Iif(mwkpacalta.denuncia>10 ,"Den.ALTA",''))
		oleapp.cells(i,22).Value 	= Iif(Isnull(mwkpacalta.PO_FechaIngreso ),"",PO_FechaIngreso )
        
		mfechaDen = Iif(Isnull(mwkpacalta.PO_FechaIngreso ),"",PO_FechaIngreso )
		If !Isnull(mwkpacalta.PO_FechaIngreso )

			oleapp.cells(i,23).Value = fechoraAlta

			If mfechaDen >= fechoraAlta
				oleapp.cells(i,24).Value = "Posterior"
			Else
				oleapp.cells(i,24).Value = sp_hrminseg(fechoraAlta - mfechaDen)
			Endif

		Endif

		oleapp.cells(i,25).Value = Iif(Nvl(PO_SolicAmbu,.F.),"SI","")
		oleapp.cells(i,26).Value = Nvl(mwkpacalta.REG_numdocumento,"")
**oleapp.cells(i,27).value = sp_busco_orden_practica(mwkpacalta.pac_codadmision)		
        oleapp.cells(i,27).Value = "'"+Alltrim(mTelefono)
        
	Endif
	i = i + 1
	Select mwkpacalta
	Skip 1 In mwkpacalta

Enddo
