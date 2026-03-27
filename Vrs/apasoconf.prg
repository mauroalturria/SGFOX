public mcon2
xp_sqlconn 	= "DRIVER=InterSystems ODBC;DSN=Conec01;SERVER=172.16.1.4"+;
	";DATABASE=CATALOGO;UID=_system;PWD=sys"
mcon1= sqlconnect(xp_sqlconn,'_system','sys')

xp_sqlconn 	= "DRIVER=InterSystems ODBC;DSN=Conec02;SERVER=172.16.1.225"+;
	";DATABASE=CATALOGO;UID=_system;PWD=SYS"
mcon2= sqlconnect(xp_sqlconn,'_system','SYS')


set step on
for i= 8 to 93
	mret=sqlexec(mcon1," SELECT * FROM Tabconfigura where id = ?i ","mwkconf")
	if reccount("mwkconf")>0
		mTBC_centro = TBC_centro
		mTBC_concepto = TBC_concepto
		if !isnull(TBC_foto)
			mid = id
			miext= right(alltrim(tbc_valor),3)
			cfile = alltrim(tbc_valor)
			if used('__DATA')
				use in __DATA
			endif
			if used('informe')
				use in informe
			endif
			if used('datos')
				use in datos
			endif
			if used('informe01')
				use in informe01
			endif
			if used('misdocus')
				use in misdocus
			endif
			create cursor misdocus (info M)
			select tbc_foto as informe  from mwkconf into cursor datos
			if file("C:\temp\informes\informe01.dbf")
				erase ("C:\temp\informes\informe01.dbf")
			endif
			if file("C:\temp\informes\informe01.fpt")
				erase ("C:\temp\informes\informe01.fpt")
			endif
			select datos
			copy to "C:\temp\informes\informe01"
			use in datos
			LL = fopen("C:\temp\informes\informe01.dbf",12)
			fseek(LL,43)
			fwrite(LL,'M')
			fclose(LL)
			use in 0 "C:\temp\informes\informe01.dbf" alias datos
			miresp = ''
			do prg_saveBinnb with datos.informe,cfile,miresp,miext
			lcDoc = miresp

			if file("C:\temp\informes\informe01a.dbf")
				erase ("C:\temp\informes\informe01a.dbf")
			endif
			if file("C:\temp\informes\informe01a.fpt")
				erase ("C:\temp\informes\informe01a.fpt")
			endif
			select 0
			create table "C:\temp\informes\informe01a.dbf" free (informe M)
			select informe01a
			append blank

			miinforme = ''
			do prg_LoadBin with cfile,miinforme
			if !empty(miinforme )
				replace informe with miinforme
				use
				LL = fopen("C:\temp\informes\informe01a.dbf",12)
				fseek(LL,43)
				fwrite(LL,'G')
				fclose(LL)
				use in 0 C:\temp\informes\informe01a.dbf alias __DATA
			else
				create cursor __DATA (informe M)
			endif


			mret=sqlexec(mcon2," update Tabconfigura set tbc_foto = ?__DATA.informe "+;
				" where TBC_centro = ?mTBC_centro and TBC_concepto = ?mTBC_concepto ")
			if mret < 0
				messagebox('Error de Cursor. REINTENTE',16,'Validacion')
				set step on
			endif
			if used('__DATA')
				use in __DATA
			endif
			if used('datos')
				use in datos
			endif
			if used('informe')
				use in informe
			endif
			if used('informe01')
				use in informe01
			endif
			if used('informe01a')
				use in informe01a
			endif

		endif
	endif
*!*		endif
next i
=sqldisconn(mcon1)
=sqldisconn(mcon2)
