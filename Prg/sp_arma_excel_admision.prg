Lparameters oleapp,mFecDesde, mFecHasta,mEntidades,mCursor, lNoShow

Local cDocExcel
Local lResult

lResult = .T.

Private oshell, loshell, nretorno,loBrowser
Declare Integer GetShortPathName In kernel32 ;
	string @lpszLongPath , String @lpszShortPath, Integer @cchBuffer
#include excel.h

If Used(mCursor)
	If !Eof(mCursor)
**Do sp_control_aplicacion With "Microsoft Excel"
**On Error .msofferror(Error( ))
**oleapp = Createobject("excel.application")
**On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()

*!*				If Vartype(oleapp)<>'O' And !.huboerror
*!*					Messagebox("No TIENE EXCEL INSTALADO - SE GENERA PLANILLA SIN FORMATO",64,"Aviso")
*!*					.huboerror = .T.
*!*				Endif

		cDocExcel = Iif(mEntidades = '876','ADMISION_PAMI.XLT','ADMISION.XLT')

**oleapp = Iif(Vartype(oleapp) != "C","",oleapp)

		i = 6

**	If !.huboerror

		oleapp.workbooks.Open(Alltrim(zzvolumen) + "\qepd1a1\xlt\"+cDocExcel)

		oleapp.cells(3,2).Value = "Periodo del " + Dtoc(mFecDesde) + ;
			" al " + Dtoc(mFecHasta)

		If mEntidades = '876'  &&PAMI

			Select &mCursor.
			Go Top

			Scan All

** -------------------- Buscamos documento y telefonos
				cDocumento = ""
				mTelefono = ""
				mCodHci = &mCursor..PAC_codhci

				mret = SQLExec(mcon1,"select a.REG_numdocumento, a.REG_telefonos,NVL(b.TRT_numero,'') as numeroTel " +;
					"from registracio as a " +;
					" left join TabRegTel as b on a.registracio = b.TRT_registracio " +;
					" where a.reg_nroregistrac = ?mCodhci","mwkDocumento")

				If mret < 0

				Else
					Select mwkDocumento
					Go Top

					cDocumento = mwkDocumento.Reg_numdocumento
					mTelefono = Iif(!Empty(Alltrim(mwkDocumento.REG_telefonos)), Alltrim(mwkDocumento.REG_telefonos)+"/ ","")

					Go Top
					Scan All
						If !Empty(Nvl(mwkDocumento.numeroTel,""))
							If At(Alltrim(mwkDocumento.numeroTel),mTelefono) = 0
								mTelefono = mTelefono + Alltrim(mwkDocumento.numeroTel) + "/ "
							Endif
						Endif
					Endscan
				Endif

				If !Empty(mTelefono)
					mTelefono = Left(mTelefono,Len(mTelefono)-2)
				Endif

				Use In Select("mwkDocumento")
** ---------------------------------------



				oleapp.cells(i,2).Value 	= &mCursor..pac_nombrepaciente
				oleapp.cells(i,3).Value 	= &mCursor..pac_fechaadmision
				oleapp.cells(i,4).Value 	= &mCursor..afi_nroafiliado
				oleapp.cells(i,5).Value 	= &mCursor..ORICodAutoriz
				oleapp.cells(i,6).Value 	= cDocumento      &&buscodocumento( (mCursor).PAC_codhci )
				oleapp.cells(i,7).Value 	= Nvl(&mCursor..pac_descripdiagn,'')
				oleapp.cells(i,8).Value 	= Nvl(&mCursor..PAC_nombrerespons,'')  && Responsable
				oleapp.cells(i,9).Value     = "'"+Alltrim(mTelefono)&& Telefono

				i = i + 1
				Select &mCursor.

			Endscan

		Else

			oleapp.cells(2,3).Value = "Admisiones de Pacientes"

			oleapp.cells(3,3).Value = "Periodo del " + Dtoc(mFecDesde) + ;
				" al " + Dtoc(mFecHasta)

			oleapp.cells(5,15).Value 	= "Orden de Internación"
			oleapp.cells(5,16).Value 	= "H.Clinica"
			oleapp.cells(5,17).Value 	= "Afiliado"
			oleapp.cells(5,18).Value 	= "Fecha Alta"
			oleapp.cells(5,19).Value 	= "Usuario Alta"
			oleapp.cells(5,20).Value 	= "Diagnóstico de Ingreso"

			Select &mCursor.
			Do While !Eof(mCursor)
				Wait "CARGANDO PLANILLA DE EXCEL"  + Str(Recno(), 5) Windows Nowait

				oleapp.cells(i,2).Value 	= &mCursor..sec_descripsec
				oleapp.cells(i,3).Value   	= &mCursor..pac_habitacion + "-" + &mCursor..pac_cama
				oleapp.cells(i,4).Value 	= &mCursor..pac_codadmision
				If !Isnull(&mCursor..pac_categoria)
					oleapp.cells(i,5).Value 	= &mCursor..pac_categoria
				Endif
				If !Isnull(&mCursor..ent_descrient)
					oleapp.cells(i,6).Value 	= &mCursor..ent_codent
					oleapp.cells(i,7).Value 	= Alltrim(&mCursor..ent_descrient)
				Endif
				oleapp.cells(i,8).Value 	= &mCursor..pac_nombrepaciente
				oleapp.cells(i,9).Value 	= &mCursor..pac_excl
				oleapp.cells(i,10).Value 	= &mCursor..pac_sexo
				oleapp.cells(i,11).Value 	= &mCursor..pac_edad
				oleapp.cells(i,12).Value 	= &mCursor..pac_fechaadmision
				oleapp.cells(i,13).Value 	= &mCursor..pac_horaadmision
				oleapp.cells(i,14).Value    = &mCursor..operadmi

				oleapp.cells(i,15).Value 	= &mCursor..ORICodAutoriz

				oleapp.cells(i,16).Value 	= &mCursor..pac_codhce
				oleapp.cells(i,17).Value 	= &mCursor..afi_nroafiliado

				If &mCursor..pac_fechaalta # Ctod("  /  /  ")
					oleapp.cells(i,18).Value 	= &mCursor..pac_fechaalta
					oleapp.cells(i,19).Value 	= &mCursor..operalta
				Endif

** ----------------------------- Marcelo Torres, 12/12/2016. Se cambia este registro por pedido de carmen gil.
** ----------------------------- carmen, 09/03/2020. lo vuelvo a poner porque se fue carmen gil.
				If !Isnull(mwkpacint.pac_descripdiagn)
					oleapp.cells(i,20).Value 	= &mCursor..pac_descripdiagn
				Endif
				oleapp.cells(i,21).Value 	= &mCursor..Reg_numdocumento
				i = i + 1
				Skip 1 In &mCursor.
			Enddo
		Endif

**oleapp.Visible = .T.

**		Else

*!*				mtit1 = "Admisiones de Pacientes"
*!*				mtit2 = "Periodo del " + Dtoc(mFecDesde) + ;
*!*					" al " + Dtoc(mFecHasta)

*!*				Select  sec_descripsec As Sector ,pac_habitacion + "-" + pac_cama As Habitac;
*!*					, pac_categoria As Cat, pac_codadmision As Admision,ent_codent As codEnt ;
*!*					,ent_descrient As entidad , pac_nombrepaciente As paciente, pac_excl As PE;
*!*					,pac_sexo As sexo, pac_edad As edad, Dtoc(pac_fechaadmision) As fecha ;
*!*					, pac_horaadmision As hora,pac_descripdiagn As Diagnos;
*!*					,Iif(pac_fechaalta = Ctod("  /  /  "),Space(10),Dtoc(pac_fechaalta)) As alta;
*!*					from &mCursor. Into Cursor mwkexcell1
*!*				Select * From mwkexcell1 Where 1=2 Into Cursor mwkexcell2
*!*				Use Dbf('mwkexcell2') In 0 Again Alias mwkexcell3
*!*				Insert Into mwkexcell3 (Sector) Values (mtit1)
*!*				Insert Into mwkexcell3 (Sector) Values (mtit2)
*!*				Select * From mwkexcell3 Union Select * From mwkexcell1 Into Cursor mwkexcell
*!*				Select mwkexcell
*!*				mdir= Getdir("C:\TEMPDOC","Donde guardara el archivo de ADMISIONES ")
*!*				marchi = Alltrim(mdir)+ "admisiones.XLS"
*!*				Copy To &marchi Type Xl5
*!*				Use In mwkexcell
*!*				Use In mwkexcell1
*!*				Use In mwkexcell2
*!*				Use In mwkexcell3
*!*				loBrowser= Createobject("InternetExplorer.Application")
*!*				loBrowser.Navigate(marchi)
*!*				loBrowser.Visible=.T.
*!*				Release loBrowser

**		Endif

	Else

		If !lNoShow
			Messagebox("NO HAY INFORMACION DISPONIBLE PARA LA ENTIDAD " + mEntidades , 48,"ADMISION")
		Endif
		lResult = .F.

	Endif

Else

	If !lNoShow
		Messagebox("NO HAY INFORMACION DISPONIBLE PARA LA ENTIDAD " + mEntidades , 48,"ADMISION")
	Endif

	lResult = .F.
Endif


Return lResult
