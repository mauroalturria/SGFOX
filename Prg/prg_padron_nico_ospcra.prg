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

Sqlsetprop(0,"DispLogin",3)

Public G_Dir_Prin
G_Dir_Prin = ""

*Set Default To c:\padrones\
Set Procedure To c:\desaguemes\prg\appendxlsx.prg Additive 

*!*	?SQLSTRINGCONNECT([Provider=Microsoft.ACE.OLEDB.12.0;Data Source="] + "c:\padrones\982\pad.xls" + [";Extended Properties="Excel 12.0 Xml;HDR=] + "Yes" + [;";])

*!*	Return .f.
G_Dir_Run = Addbs(Sys(5) + Sys(2003))
?G_Dir_Run 

 
*lcExcel = "c:\padrones\982\pad.xls"
lcExcel = Getfile("Xls")
If Empty(lcExcel)
	Return .f.
Endif 




G_Dir_Prin = Addbs(JUSTPATH(lcExcel))

Do creo_estructura


If !File(G_Dir_Run + "hoja.txt")
	lcHoja = ""
Else
	?G_Dir_Run+ "hoja.txt"
	lcHoja = Filetostr(G_Dir_Run+ "hoja.txt")
Endif 	



Select OSPCRA 
AppendFromExcel(lcExcel, lcHoja, "OSPCRA")


Return .f.

*!*------------------------------------------------------------------------------------------------------------------------------
Procedure creo_estructura
*!*------------------------------------------------------------------------------------------------------------------------------

CREATE Table (G_Dir_Prin + "OSPCRA") ( ;
  Tdoc         C(19);
, Doc          N(15);
, Apellido     C(18);
, Nombre       C(23);
, Sexo         C(5);
, Fecnac       C(16);
, Nacionalid   C(12);
, Estado_civ   C(12);
, Domicilio    C(38);
, Localidad    C(28);
, Cp           C(11);
, Provincia    C(14);
, Telefono     C(50);
, Organizaci   C(12);
, Fecha_alta   C(10);
, Afil_numer   N(12);
, Afil_orden   C(10);
, Des_parent   C(29);
, Prestador_   C(27);
, N20          C(22);
, N21          C(19);
, N22          N(18);
, N23          C(18);
, N24          C(24);
, N25          C(19);
, N26          N(8);
, Cuota_mes    N(10);
, Importe      N(8);
, Saldo        N(6);
, Monot_peri   N(14);
, Monot_impo   N(14);
, Monot_fami   N(16);
, Monot_apor   N(18);
, Modo         C(13);
, Autorizado   C(11);
, Motivo       C(7);
, Pers_idreg   N(11);
, Tipo_afili   N(12);
, Parentesco   N(11);
, Empleador    N(10);
, Prestador    N(10);
)
