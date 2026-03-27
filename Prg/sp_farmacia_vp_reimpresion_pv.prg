* Marcelo Torres, 09/10/2025
* Armamos cursor para Reimprimir tickts.
* Observación: no tenemos la propiedad FRIO, ya que no se graba en TabFarmVpDetEnt.

Lparameters nIdPre, pChkVer, mTipo, mVale

*Set Step On
LOCAL cWhere

IF VARTYPE(mVale) <> "N"
   mVale = 0
ENDIF

cWhere = ""

IF mVale > 0
   cWhere = " and TVE_vale = " + TRANSFORM(mVale) + " "
ENDIF 

Do sp_farmacia_vp_tomados_pv With ,"I",nIdPre

Select TVE_vale As _vale, ;
	TVE_insumocodigo As _codins, ;
	ins_descriinsumo As _insumo, ;
	PAC_nombrepaciente As _paciente,  ;
	TVE_Soli As _cantidad, ;
	TVE_Entrega As _entregad, ;
	TVE_TipoEnt As _tipo , ;
	TVE_Frio As _frio, ;
	TVE_ObsItem As _observ, ;
	TVE_Sector As _sector, ;
	VAL_habitacion As _hab, ;
	VAL_cama As _cama, ;
	DTOC(VAL_fechasolicitud) As _fechaval, ;
	VAL_codadmision As _cta, ;
	VAL_horasolicitud As _horaVal, ;
	0 As _secu, ;
	'' As _verifica, ;
	0 As lpuntero, ;
	0 As mlcolor, ;
	transform(PAC_edad) As _PAC_edad, ;
	'' As _ENT_descrient, ;
	0 As enPyxis, ;
	'' As _gtin, ;
	'' As _serie, ;
	IIF(TVE_tipo = 'E',.T.,.F.) As esExterno, ;
	PAC_nombrepaciente, ;
	TVE_Entrega , ;
	TVE_ParaAlta As FPT_paraalta, ;
	TRANSFORM(REG_numdocumento) As PAC_ldocumento ;
	FROM mwkconpre1 ;
	WHERE TVE_tipo = mTipo &cWhere ;
	INTO Cursor mwkFarm49a



*!*	TEXT To cSql Textmerge Noshow Pretext 7
*!*	Select TVE_vale As _vale, 
*!*		TVE_insumocodigo As _codins, 
*!*		ins_descriinsumo As _insumo, 
*!*		PAC_nombrepaciente As _paciente,  
*!*		TVE_Soli As _cantidad, 
*!*		TVE_Entrega As _entregad, 
*!*		TVE_TipoEnt As _tipo , 
*!*		TVE_Frio As _frio, 
*!*		TVE_ObsItem As _observ, 
*!*		TVE_Sector As _sector, 
*!*		VAL_habitacion As _hab, 
*!*		VAL_cama As _cama, 
*!*		DTOC(VAL_fechasolicitud) As _fechaval, 
*!*		VAL_codadmision As _cta, 
*!*		VAL_horasolicitud As _horaVal, 
*!*		0 As _secu, 
*!*		'' As _verifica, 
*!*		0 As lpuntero, 
*!*		0 As mlcolor, 
*!*		transform(PAC_edad) As _PAC_edad, 
*!*		'' As _ENT_descrient, 
*!*		0 As enPyxis, 
*!*		'' As _gtin, 
*!*		'' As _serie, ;
*!*		IIF(TVE_tipo = 'E',.T.,.F.) As esExterno, 
*!*		PAC_nombrepaciente, 
*!*		TVE_Entrega , 
*!*		TVE_ParaAlta As FPT_paraalta, 
*!*		TRANSFORM(REG_numdocumento) As PAC_ldocumento 
*!*		FROM mwkconpre1 
*!*		WHERE TVE_tipo = '<<mTipo>>' <<cWhere>> 
*!*		INTO Cursor mwkFarm49a
*!*	ENDTEXT 

*!*	EVALUATE(cSql)

Select mwkFarm49a
Go Top

If Reccount() > 0
* Arma e imprime los tickets
	armoticket(nIdPre,pChkVer)
Else
	Messagebox("No se encontraron registros para esta selección: " +CHR(10)+ CHR(10) + IIF(mTipo= "K", "KARDEX", "EXTERNOS"),16,"Re Impresión")
	Use In Select("mwkFarm49a")
Endif



*** ---------------------------------
Function armoticket(midpreparacion,pChkVer)

Local oError As Exception
Local pChkEpson
* Local pChkVer
Local lImpreso
Local mImpre
Local uuu
Local nImpre

lImpreso = .F.

mImpre = ""
mopta = 2

*!* --------------------------------------------
nImpre = Aprinters(aimpresor)
For uuu = 1 To nImpre
	If "MP-4200" $ Upper(aimpresor[uuu,1])
		mImpre = aimpresor[uuu,1]
		Exit
	Endif
Next


*!* -------------------------------------------------------------------------------------------------------

Use In Select("mwkinforme")
Select * From mwkFarm49a Order By mwkFarm49a._sector, mwkFarm49a._paciente, mwkFarm49a._vale, mwkFarm49a._insumo Into Cursor mwkinforme

Use In Select("mwkValesInf2")
Select * From mwkFarm49a Where _frio = 1 And _entregad > 0 Order By mwkFarm49a._paciente, mwkFarm49a._vale, mwkFarm49a.lpuntero Into Cursor mwkValesInf2


If mopta = 1 && Control ante modificaciones

	Use In Select("mwkValesInf2Ctrl")
	Select * From mwkValesInf2 Into Cursor mwkValesInf2Ctrl

	Use In Select("mwkinformeCtrl")
	Select * From mwkinforme Into Cursor mwkinformeCtrl

Else

** ------------------------------------
	Use In Select("mwkValesInf2Ctrl")
	Select * From mwkValesInf2 Into Cursor mwkValesInf2Ctrl

	Use In Select("mwkinformeCtrl")
	Select * From mwkinforme Into Cursor mwkinformeCtrl
** ------------------------------------

	Use In Select("mwkValesInf2A")
	Use In Select("mwkinformeA")

	Select Sum(_entregad) As lcanctrl, _vale From mwkValesInf2Ctrl Group By _vale Into Cursor mwkValesInf2A
	Select Sum(_entregad) As lcanctrl, _vale From mwkinformeCtrl Group By _vale Into Cursor mwkinformeA

	Use In Select("mwkValesInf2B")
	Use In Select("mwkinformeB")

	Select Sum(_entregad) As lcanctrl, _vale From mwkValesInf2 Group By _vale Into Cursor mwkValesInf2B
	Select Sum(_entregad) As lcanctrl, _vale From mwkinforme Group By _vale Into Cursor mwkinformeB


	Use In Select("mwkValesInf2C")
	Use In Select("mwkinformeC")

*Select mwkinformeA.*;
*     FROM mwkinformeA Where mwkinformeA._vale In (Select _vale From mwkinformeB Where mwkinformeB.lcanctrl <> mwkinformeA.lcanctrl) Into Cursor mwkinformeC

	Select mwkinformeA.*;
		FROM mwkinformeA Into Cursor mwkinformeC

	Select mwkinforme.* From mwkinforme Where mwkinforme._vale In (Select _vale From mwkinformeC) Into Cursor mwkinforme


*Select mwkValesInf2A.*;
*	FROM mwkValesInf2A Where mwkValesInf2A._vale In (Select _vale From mwkValesInf2B Where mwkValesInf2B.lcanctrl <> mwkValesInf2A.lcanctrl) Into Cursor mwkValesInf2C

	Select mwkValesInf2A.*;
		FROM mwkValesInf2A Into Cursor mwkValesInf2C

	Select mwkValesInf2.* From mwkValesInf2 Where mwkValesInf2._vale In (Select _vale From mwkValesInf2C) Into Cursor mwkValesInf2

Endif

*!* 2016-06-29

Use In Select("mwkinformeGral")
Select * From mwkinforme Into Cursor mwkinformeGral

Use In Select("mwkValesInf")
Select Distinct(_vale) As lvale From mwkinforme Order By _hab, _cama Into Cursor mwkValesInf && ,_paciente


mfechaprepara = Ttoc(sp_busco_fecha_serv("DT"))
**mnroprepara   = Transform(Thisform.Lidpre) && "000001" && Ejemplo
mnroprepara   = Transform(midpreparacion)
**mobserva      = Alltrim(Thisform.Edit1.Value)
mreimprime    = ""
idusuario = Alltrim(mwkusuario.idusuario)



**** TICKET ***************************************************************************************************************

Declare Integer GetDefaultPrinter In winspool.drv;
	STRING  @ pszBuffer,;
	INTEGER @ pcchBuffer

nBufsize = 250
cPrinter = Replicate(Chr(0), nBufsize)
= GetDefaultPrinter(@cPrinter, @nBufsize)

cPrinter = Substr(cPrinter, 1, At(Chr(0),cPrinter)-1)

*MESSAGEBOX(cPrinter,48,"PRINTER DEFAULT")


*Set Printer To Name "TKFARMA"

Set Printer To

cimpre = mImpre
If !Empty(cimpre )
	Set Printer To Name (cimpre)
Else
	Set Printer To Name "MP-4200 TH"
Endif

* Set Printer To Name (cPrinter)

* Set Printer On

*
* IMPRIMO TICKET
*

***************************************************************************************************************************

If Used("mwkValesInf")
	If Reccount("mwkValesInf")>0
		Do While .T.
			Select mwkValesInf
			Go Top
			Scan All
				Select * From mwkinformeGral Where _vale = mwkValesInf.lvale Order By lpuntero Into Cursor mwkinforme
				Select mwkinforme
				Go Top

** ------------- Marcelo Torres. Solo para prueba
**Report Form repfarmacia21 Preview

				If pChkVer
*!*						If pChkEpson = 1
*!*							Report Form repfarmacia21PV-e Preview
*!*						Else
					Report Form repfarmacia21PV Preview
*!*						Endif
				Else
*!*						If pChkEpson = 1
*!*							Report Form repfarmacia21PV-e To Printer Noconsole
*!*						Else
					Report Form repfarmacia21PV To Printer Noconsole
*!*						Endif
				Endif

				Select mwkValesInf
			Endscan
			lImpreso = .T.
*If Messagebox("REIMPRIME VALES ?",4+32+256,"ATENCION") = 7
			Exit
*Endif
		Enddo
	Endif
Endif

Use In Select("mwkinformeGral")
Use In Select("mwkValesInf")
Use In Select("mwkinforme")

*
* Vales Cadena de Frio igual imprime
*

If Used("mwkValesInf2")
	If Reccount("mwkValesInf2")>0
		Select * From mwkValesInf2 Into Cursor mwkinformeGral
		Do While .T.
			Select mwkValesInf2
			Go Top
			Scan All
				Select * From mwkinformeGral ;
					Where _vale = mwkValesInf2._vale;
					ORDER By lpuntero;
					Into Cursor mwkinforme

				Select mwkinforme
				Go Top

				If pChkVer
*!*						If pChkEpson = 1
*!*							Report Form repfarmacia22PV-e Preview
*!*						Else
					Report Form repfarmacia22PV Preview
*!*						Endif
				Else
*!*						If pChkEpson = 1
*!*							Report Form repfarmacia22PV-e To Printer Noconsole
*!*						Else
					Report Form repfarmacia22PV To Printer Noconsole
*!*						Endif
				Endif

				Select mwkValesInf2

			Endscan
			lImpreso = .T.
*If Messagebox("REIMPRIME VALES CADENA DE FRIO ?",4+32+256,"ATENCION") = 7
			Exit
*Endif
		Enddo
	Endif
Endif

*** SETEO IMPRESORA POR DEFECTO *******************************************************************************************

Set Printer Off
Set Printer To
Set Printer To Name (cPrinter)


Return

