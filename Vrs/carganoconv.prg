Cd "C:\desaguemes"
mnarch = Adir(midir,"noconv*.dbf")
Set Step On
For i= 1 To mnarch
	miarch = midir(i,1)
	micodent= Val(Substr(miarch,7,3))
	If  Messagebox(miarch+"-"+Transform(micodent),4+32,"sigo?")<>6
		Set Step On
	Else
		Use &miarch  In 0 Shared
		Requery('prestac_noconv')
		If Reccount('prestac_noconv')>0
			Select prestac_noconv.* ,pre_descriprest From prestac_noconv,prestacion ;
				 Where PC_codprest =pre_codprest AND PC_codprest Not In (Select pre_codpre From &miarch  ) Into Cursor bajar
			Update prestac_noconv Set PC_FechaVigHasta = Date()-1 Where PC_codprest In (Select PC_codprest From  bajar  )
		ENDIF
		Requery('prestac_noconv')
		Select Date() As PC_FechaVigDesde,Ctod("01/01/2100") As PC_FechaVigHasta,;
			2 As PC_incluidaAMB, 2 As PC_incluidaGUA,2 As  PC_incluidaINT,;
			micodent As PC_codent, pre_codpre As PC_codprest From &miarch ;
			WHERE pre_codpre Not In (Select PC_codprest From  prestac_noconv)  Into Cursor nuevo
		Select prestac_noconv
		Append From Dbf('nuevo')

	Endif
Next i
