*!* ------------------------------------------------------------
*!* Control de actualización Ejecutables
*!* parametros mfecdes, mfechas
*!*	Resultado mwkListado 
*!* ------------------------------------------------------------
parameters mfecdes, mfechas

If mfecdes = mfechas
	mfechas = mfechas + 1
Endif 	

*!*	mfecdes = Ctod("08/12/2009")
*!*	mfedhas = mfecdes + 1

Do sp_busco_tabExe With '', '', '', 1, '', ''

Do sp_busco_ctrlserver With mfecdes, mfechas

Create Cursor mwkListado (Ip c(20), Maquina c(50), Prg c(30), VerMaq c(10), Verexe c(10), Fecha t)

Select Upper(Substr(Tcs_Device,1,At(" ", Tcs_Device,1))) as Prg, ;
	Substr(Tcs_Device,At(" ", Tcs_Device,1)) as VerNro, * ;
	From MwkTcs0 ;
	Where Tcs_Program = 'sp_conexion' And ;
	Not "|TCP|" $ Tcs_Device ;
	Into Cursor MwkTcs1

Use In MwkTcs0

Select Distinct Tcs_ClientName, Prg, Tcs_IpAddress  ;
	From MwkTcs1 ;
	Into Cursor MwkClientes	

Select NomExe, Nvl(MwkExe11.Version,'') as Version ;
	From MwkExe11 ;
	Where NomExe in (Select Prg From MwkClientes );
	Into Cursor mwkPrg

Use In MwkExe11

Select mwkPrg
Scan All
	
	Select MwkClientes
	Scan All For Prg = mwkPrg.NomExe
		
		Select Top 1 MwkTcs1.* ;
			From MwkTcs1 ;
			Where MwkTcs1.Tcs_ClientName = MwkClientes.Tcs_ClientName And ;
				MwkTcs1.Prg = MwkClientes.Prg And ;
				MwkTcs1.Tcs_IpAddress = MwkClientes.Tcs_IpAddress ;
			Order By Tcs_FechaH Descending ; 	
			Into Cursor mwk1Clie_0

		Select mwkPrg.Version as Version, mwk1Clie_0.* ;
			From mwk1Clie_0 ;
			Where Alltrim(VerNro) <> Alltrim(mwkPrg.Version) ;
			Into Cursor mwk1Clie
		
		Use In mwk1Clie_0		
			
		If Reccount("mwk1Clie")> 0			 
			Select mwk1Clie
			Scan All
				
				Insert into mwkListado (Ip, Maquina, Prg, VerMaq, Verexe, Fecha) ;
					Values (mwk1Clie.Tcs_IpAddress, ;
					mwk1Clie.Tcs_ClientName, ;
					mwk1Clie.Prg, ;
					mwk1Clie.VerNro, ;
					mwk1Clie.Version, ;
					mwk1Clie.Tcs_FechaH)
			
				Select mwk1Clie
			Endscan 
		Endif

		Use In mwk1Clie
			
		Select MwkClientes
	Endscan 

	Select mwkPrg	
Endscan

Use In mwkPrg
Use In MwkClientes
Use In MwkTcs1

Select mwkListado 
Index on Maquina Tag Maquina
Go top

