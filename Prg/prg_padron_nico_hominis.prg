Set Ansi On
Set Bell Off
Set Cent On
Set Compatible Off
Set Conf On
Set Date To French
Set Decimal To 2
Set Dele On
Set Exact On
Set Exclu Off
Set Fdow To 1
Set Hours To 24
Set Near On
Set Notify Off
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Message To 
Set Talk Off
Set Sysmenu Off

_screen.Caption = "Hominis"
_screen.Icon = "DEAD.ICO"

Sqlsetprop(0,"DispLogin",3)

Public G_Dir_Prin
G_Dir_Prin = ""

*Set Default To c:\padrones\
Set Procedure To c:\desaguemes\prg\appendxlsx.prg Additive 

*!*	?SQLSTRINGCONNECT([Provider=Microsoft.ACE.OLEDB.12.0;Data Source="] + "c:\padrones\982\pad.xls" + [";Extended Properties="Excel 12.0 Xml;HDR=] + "Yes" + [;";])

*!*	Return .f.

 
*lcExcel = "c:\padrones\982\pad.xls"
lcExcel = Getfile("Xls,xlsx")
*lcExcel = "c:\temp\hominis\Pdr_Hom al 05_03_20 (sin descarga ni UADAV ni PMXX) con IVA.xlsx" 
If Empty(lcExcel)
	Return .f.
Endif 

* SET STEP ON

G_Dir_Prin = Addbs(JUSTPATH(lcExcel))

Do creo_estructura

Select PAD

Public oExcel as Excel.application
oExcel = Createobject("Excel.application")
oExcel.Visible = .F.
oExcel.DisplayAlerts = .F.
oExcel.Workbooks.Open(lcExcel)
oExcel.Range("A1").Select
lcSalida = Addbs(Getenv("TEMP")) + "Salida"
oExcel.ActiveWorkbook.SaveAs(lcSalida, 6)
oExcel.ActiveWorkbook.Close(0)
oExcel.Quit()
oExcel = .f.
Release oExcel
?lcSalida 
Select PAD
Append From (lcSalida + ".csv") Type csv
Use In Select("PAD")


*!*	oExcel.Range("C1").Select
*!*	lnFilaCab = oExcel.Selection.Row + 1
*!*	oExcel.Selection.End(-4121).Select
*!*	oExcel.Selection.End(-4121).Select
*!*	oExcel.Selection.End(-4162).Select
*!*	lnFilaFin = oExcel.Selection.Row

*!*	For I = lnFilaCab To lnFilaFin 
*!*		lcInsert = "Insert Into Pad ;
*!*		(CUIT, ;
*!*		TIPO, ;
*!*		DOCUMENTO, ;
*!*		APELLIDOS, ;
*!*		NOMBRES, ;
*!*		EMERGENCIA, ;
*!*		AFILIADO, ;
*!*		PLAN, ;
*!*		FECHA_NACI, ;
*!*		FECHA_INGR, ;
*!*		SEXO, ;
*!*		DOMICILIO, ;
*!*		LOCALIDAD, ;
*!*		TELEFONO, ;
*!*		CODIGO_POS, ;
*!*		PARENTESCO, ;
*!*		GRUPO__COR, ;
*!*		CODIGO_ALT, ;
*!*		CONTRATO, ;
*!*		SOLO_CON_A) ;
*!*		values ("
*!*			For lnCol = 1 To 20
*!*				
*!*				If vartype(oExcel.Cells(I,lnCol).value) = "N"
*!*					lcInsert = lcInsert + Transform(oExcel.Cells(I,lnCol).value)
*!*				Else
*!*					lcInsert = lcInsert + "'" + Alltrim(Transform(oExcel.Cells(I,lnCol).value)) + "'"
*!*				Endif 		
*!*				If lnCol <> 20
*!*					lcInsert = lcInsert + " , "
*!*				Endif 
*!*			Next 
*!*		
*!*		lcInsert = lcInsert + ")"
*!*		&lcInsert 
*!*	Next 
*!*	AppendFromExcel(lcExcel, "New sheet", "PAD")


Return .f.

*!*------------------------------------------------------------------------------------------------------------------------------
Procedure creo_estructura
*!*------------------------------------------------------------------------------------------------------------------------------

CREATE Table (G_Dir_Prin + "PAD") ( ;
	CUIT C(15), ;
	TIPO C(5), ;
	DOCUMENTO N(13,0), ;
	APELLIDOS C(34), ;
	NOMBRES C(31), ;
	EMERGENCIA C(21), ;
	AFILIADO C(13), ;
	PLAN C(9), ;
	FECHA_NACI C(19), ;
	FECHA_INGR C(17), ;
	SEXO C(6), ;
	DOMICILIO C(52), ;
	LOCALIDAD C(27), ;
	TELEFONO C(36), ;
	CODIGO_POS N(16,0), ;
	PARENTESCO C(13), ;
	GRUPO__COR C(48), ;
	CODIGO_ALT C(22), ;
	CONTRATO C(28), ;
	SOLO_CON_A C(29), ;
	PMI C(50), ;
	ANTECEDENT C(50))