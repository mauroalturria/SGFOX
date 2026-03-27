Lparameters oForm As Form, opcion

*** Configuración de ventanas para las aplicaciones (Se pueden agregar otras propiedades)
*** 2016-08-05 Fabián

lcFile = "c:\Qepd1a1\Exe\sysg2.cfg"


If File(lcFile)
	If !Used("mwkCfgSys")
		CreoCursor()
	Endif
	Select mwkCfgSys
Else
* Crea archivo
	lnArch = Fcreate("c:\Qepd1a1\Exe\sysg2.cfg")
	Fputs(lnArch,"[" + Upper(oForm.Name) + "]")
	Fputs(lnArch,".WINDOWSTATE=" + Alltrim(Str(oForm.WindowState)))
	Fclose(lnArch)
	CreoCursor()
Endif


Do Case

Case opcion = 1 && Graba
	If !Used("mwkCfgSys")
		CreoCursor()
	Endif
	Select mwkCfgSys
	Go Top
	lcNomForm = Alltrim(Upper(oForm.Name))
	Update mwkCfgSys Set cfgval = oForm.WindowState Where cfgForm = lcNomForm And cfgProp = ".WINDOWSTATE="

* Grabo al archivo de texto

	Go Top
	lnArch = Fcreate("c:\Qepd1a1\Exe\sysg2.cfg")
	Scan All
		Fputs(lnArch,"[" + Alltrim(Upper(mwkCfgSys.cfgForm)) + "]")
		Fputs(lnArch,Alltrim(cfgProp) + Alltrim(Str(mwkCfgSys.cfgval)))
	Endscan
	Fclose(lnArch)

Case opcion = 2 && Recupera
	If !Used("mwkCfgSys")
		CreoCursor()
	Endif
	Select mwkCfgSys
	Go Top
	lcNomForm = Alltrim(Upper(oForm.Name))
	Select * From mwkCfgSys Where Alltrim(cfgForm) = lcNomForm Into Cursor mwkCfgSys_temp Readwrite
	If Reccount("mwkCfgSys_temp")>0
		lcEjecutar = Proper("Thisform" + Alltrim(mwkCfgSys_temp.cfgProp) + Alltrim(Str(mwkCfgSys_temp.cfgval)))
		Return lcEjecutar
		Use In mwkCfgSys_temp
	Else
* Si no lo encuentra creo una entrada
		Insert Into mwkCfgSys (cfgForm,cfgProp) Values (Upper(oForm.Name),".WINDOWSTATE=")
		Return 0
	Endif
Endcase

Return 0

*** Función para crear el cursor:

Function CreoCursor
nroID = 0
Create Cursor mwkCfgSys (cfgID N(6),cfgForm c(30), cfgProp c(25), cfgval N(3))
lnFile = Fopen("c:\Qepd1a1\Exe\sysg2.cfg",2)
If lnFile < 0
	Messagebox("Contacte a Sistemas.",16,"Error en SYSG2")
Else
	Do While Not Feof(lnFile)
		lcLinea = Fgets(lnFile)
		Do Case
		Case Left(lcLinea,1) = "["
			nroID = nroID + 1
			lcForm = Substr(lcLinea,2,Len(lcLinea)-2)
			Insert Into mwkCfgSys (cfgID,cfgForm) Values (nroID,lcForm)
		Case Left(lcLinea,13) = ".WINDOWSTATE="
			lcPropiedad = ".WINDOWSTATE="
			lcValor = Substr(lcLinea,14,1)
			Update mwkCfgSys Set cfgProp=lcPropiedad,cfgval=Val(lcValor) Where cfgID = nroID
		Endcase
	Enddo
Endif
Fclose(lnFile)
Endfunc
