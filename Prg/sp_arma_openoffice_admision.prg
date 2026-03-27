Lparameters oOficce,mFecDesde, mFecHasta,mEntidades,mCursor

If Used(mCursor)
	If !Eof(mCursor)

		cDocExcel = Iif(mEntidades = '876','ADMISION_PAMI.XLT','ADMISION.XLT')


		Copy File (Alltrim(zzvolumen) + "\qepd1a1\xlt\"+cDocExcel)To ("c:\tempdoc\" + cDocExcel)
		oOficce.OOoOpenFile("c:\tempdoc\" + cDocExcel,.T.)

		oOficce.activosheet()
		oOficce.Setvalue(3,2, "Periodo del " + Dtoc(mFecDesde) + ;
			" al " + Dtoc(mFecHasta))

		i = 6

**	oleapp.workbooks.Open(Alltrim(zzvolumen) + "\qepd1a1\xlt\"+cDocExcel)

**	oleapp.cells(3,2).Value = "Periodo del " + Dtoc(mFecDesde) + ;
" al " + Dtoc(mFecHasta)

		If mEntidades = '876'  &&PAMI

			Select &mCursor.
			Go Top

			Scan All

** -------------------- Buscamos documento
				cDocumento = ""
				mCodHci = &mCursor..PAC_codhci

				mret = SQLExec(mcon1,"select REG_numdocumento from registracio where registracio.reg_nroregistrac = ?mCodhci","mwkDocumento")

				If mret < 0

				Else
					cDocumento = mwkDocumento.Reg_numdocumento
				Endif

				Use In Select("mwkDocumento")
** ---------------------------------------

				oOficce.Setvalue(i,2,&mCursor..pac_nombrepaciente)
				oOficce.Setvalue(i,3,&mCursor..pac_fechaadmision)
				oOficce.Setvalue(i,4,&mCursor..afi_nroafiliado)
				oOficce.Setvalue(i,5,&mCursor..ORICodAutoriz)
				oOficce.Setvalue(i,6,cDocumento)      &&buscodocumento( (mCursor).PAC_codhci )
				oOficce.Setvalue(i,7,Nvl(&mCursor..pac_descripdiagn,''))

				i = i + 1
				Select &mCursor.

			Endscan

		Else

			oOficce.Setvalue(2,3,"Admisiones de Pacientes")

			oOficce.Setvalue(3,3,"Periodo del " + Dtoc(mFecDesde) + ;
				" al " + Dtoc(mFecHasta))

			oOficce.Setvalue(5,15,"Orden de Internación" )
			oOficce.Setvalue(5,16,"H.Clinica" )
			oOficce.Setvalue(5,17,"Afiliado" )
			oOficce.Setvalue(5,18,"Fecha Alta" )
			oOficce.Setvalue(5,19,"Usuario Alta" )
			oOficce.Setvalue(5,20,"Diagnóstico de Ingreso" )

			Select &mCursor.
			Do While !Eof(mCursor)
				Wait "CARGANDO PLANILLA DE EXCEL"  + Str(Recno(), 5) Windows Nowait

				oOficce.Setvalue(i,2,&mCursor..sec_descripsec )
				oOficce.Setvalue(i,3,&mCursor..pac_habitacion + "-" + &mCursor..pac_cama )
				oOficce.Setvalue(i,4,&mCursor..pac_codadmision )
				If !Isnull(&mCursor..pac_categoria)
					oOficce.Setvalue(i,5,&mCursor..pac_categoria )
				Endif
				If !Isnull(&mCursor..ent_descrient)
					oOficce.Setvalue(i,6,&mCursor..ent_codent )
					oOficce.Setvalue(i,7,Alltrim(&mCursor..ent_descrient) )
				Endif
				oOficce.Setvalue(i,8,&mCursor..pac_nombrepaciente )
				oOficce.Setvalue(i,9,&mCursor..pac_excl)
				oOficce.Setvalue(i,10,&mCursor..pac_sexo)
				oOficce.Setvalue(i,11,&mCursor..pac_edad)
				oOficce.Setvalue(i,12,&mCursor..pac_fechaadmision)
				oOficce.Setvalue(i,13,&mCursor..pac_horaadmision)
				oOficce.Setvalue(i,14,&mCursor..operadmi)

				oOficce.Setvalue(i,15,&mCursor..ORICodAutoriz)

				oOficce.Setvalue(i,16,&mCursor..pac_codhce)
				oOficce.Setvalue(i,17,&mCursor..afi_nroafiliado)

				If &mCursor..pac_fechaalta # Ctod("  /  /  ")
					oOficce.Setvalue(i,18,&mCursor..pac_fechaalta)
					oOficce.Setvalue(i,19,&mCursor..operalta)
				Endif
** ----------------------------- Marcelo Torres, 12/12/2016. Se cambia este registro por pedido de carmen gil.
** ----------------------------- carmen, 09/03/2020. lo vuelvo a poner porque se fue carmen gil.
				If !Isnull(mwkpacint.pac_descripdiagn)
					oOficce.Setvalue(i,20,&mCursor..pac_descripdiagn)
				Endif
				oOficce.Setvalue(i,21,&mCursor..Reg_numdocumento )

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

		Messagebox("NO HAY INFORMACION DISPONIBLE", 48,"ADMISION")

	Endif

Else

	Messagebox("NO HAY INFORMACION DISPONIBLE", 48,"ADMISION")

Endif
