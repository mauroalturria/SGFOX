*
* Farmacia busqueda de partidas medicamentos citostáticos x Nro.Registracio , Nombre Paciente
*
Lparameters mbusreg, mbuspac

If used('mwkcitosp')
	Use in mwkcitosp
Endif

If vartype(mbusreg)<>'N'
	mbusreg = 0
Endif

If vartype(mbuspac)<>'C'
	mbuspac = ''
Endif

If mbusreg > 0 or len(alltrim(mbuspac)) > 0

	mbusca = iif(mbusreg>0,'TCP_registracio=?mbusreg','TCP_nombrepac=?mbuspac')

	mret = sqlexec(mcon1,"select *,TabFarmPActivo.TFP_pactivo from TabFarmCitosI "+;
	"join TabFarmCitosP on  TCI_partida=TCP_partida and TCP_fechapasiva is null and "+;
	"TCI_resto>0 and " + mbusca +;
	" join TabFarmPActivo on TFP_inscod = TabFarmCitosI.TCI_insumocodigo"+;
	" order by TabFarmCitosI.TCI_partida", "mwkcitosp")

	If mret < 0
		Messagebox("EN BUSQUEDA DE PARTIDAS DE MEDICAMENTOS"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else
		mpaso = .t.
	Endif
	
Endif
