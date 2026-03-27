DO sp_conexion
Do sp_busco_puesto_st With 2
DO sp_desconexion
Select * From mwkPuesto Where At("+",maquina)>0 And At("Z",maquina)>0 Into Cursor mwkserv

If !Used("mwkServidores")
	Create Cursor mwkServidores (Id i Autoinc Nextvalue 1 Step 1,  Ip c(50), Descrip c(30), obs c(50), fh T, Disponibles i, Consumidas i, MaxConsumidas i, MinDisponibles i, MaxCon i, datacata c(50))
	Select mwkserv
	Scan
		mip= puesto
		midesc = nombre
		Insert Into mwkServidores (Ip, Descrip, datacata) Values (mip,midesc,'CATALOGO')
	Endscan

Endif


Select mwkServidores
Scan All

	Select mwkServidores
	Replace Disponibles With 0 , ;
		Consumidas With 0 , ;
		MaxConsumidas With 0, ;
		MinDisponibles With 0, ;
		MaxCon With 0, ;
		fh With Ctod("//"), ;
		obs With ""

	cpass = ";Uid=cacheapp;Pwd=KaxHe025"
	lcStringConn = "Driver={InterSystems ODBC};PORT=1972;SERVER=" + Alltrim(mwkServidores.Ip) +;
		";DATABASE=" + Alltrim(datacata) +cpass
	mcon1 = Sqlstringconnect(lcStringConn)

	If mcon1 > 0

		SQLTables(mcon1,"TABLE","ctables")

		Select ctables
		Locate For Upper(Alltrim(Table_Name)) = Upper("LicenciasCache")
		If Found()
			Use In Select("mwkLicSVR")
			If sp_busco_lic_svr() && mwkLicSVR
				Select mwkServidores
				Replace Disponibles With Val(mwkLicSVR.LUAvailable) , ;
					Consumidas With Val(mwkLicSVR.LUConsumed) , ;
					MaxConsumidas With Val(mwkLicSVR.LUMaxConsumed), ;
					MinDisponibles With Val(mwkLicSVR.LUMinAvailable), ;
					MaxCon With Val(mwkLicSVR.MaxConnections), ;
					fh With mwkLicSVR.fh

				Use In Select("mwkLicSVR")
			Else
				Select mwkServidores
				Replace obs	With "NO EXISTE LA TABLA"
			Endif
		Else
			Select mwkServidores
			Replace obs	With "NO EXISTE LA TABLA"
		Endif
		SQLDisconnect(mcon1)
	Else
		Select mwkServidores
		Replace obs	With "NO SE CONECTA"

	Endif
	Select mwkServidores
Endscan

Select mwkServidores
Go Top
*brow
