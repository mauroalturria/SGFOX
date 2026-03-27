Lparameters lcGrilla As Grid,lcNroColumna

* PRG GRILLA CABECERA V2
* para Ordenar Cabeceras de Columnas de Grillas
* Armado para frmPisos14
* Julio 2016 - Fabián
* Modificado Agosto 2016

Local lcNomCursor, lcNomCampo, lnNroCampo, lcNombreGrilla, lnNumCol

lcGrilla.HeaderHeight = 22

lcNombreGrilla = lcGrilla.Name

lcNomCursor = lcGrilla.RecordSource
lnNumCol = lcGrilla.ColumnCount

For nVar = 1 To lnNumCol
	lcGrilla.Columns(nVar).header1.Picture = ''
Endfor

Select &lcNomCursor

eltag = lcGrilla.Tag

lcNomCampo0 = "lcGrilla." + lcNroColumna + ".ControlSource"

lcNomCampo = &lcNomCampo0

lnNomCampo_1 = At(".",lcNomCampo,1)+1
lnNomCampo_2 = At(")",lcNomCampo,1)
lnNomCampo_3 = lnNomCampo_2 - lnNomCampo_1

lcNomCampoFinal = Substr(lcNomCampo,lnNomCampo_1,lnNomCampo_3)

lcGrilla.RecordSource = ""

If lcGrilla.Tag = "A"
	lcConsulta = "Select * From " + lcNomCursor + " Order By " + lcNomCampoFinal + " Desc into cursor " + lcNomCursor + "_order readwrite"
	&lcConsulta
	Use In &lcNomCursor
	lcGrilla.Tag = "D"
	Base = "lcGrilla." + lcNroColumna + ".header1.picture = 'BMP\0abajo.BMP'" && 'C:\DESAGUEMES\BMP\0abajo.BMP'
	&Base
Else
	lcConsulta = "Select * From " + lcNomCursor + " Order By " + lcNomCampoFinal + " Asc into cursor " + lcNomCursor + "_order readwrite"
	&lcConsulta
	Use In &lcNomCursor
	lcGrilla.Tag = "A"
	Base = "lcGrilla." + lcNroColumna + ".header1.picture = 'BMP\0arriba.BMP'" && 'C:\DESAGUEMES\BMP\0arriba.BMP'
	&Base
Endif

lcGrilla.Refresh
lcConsulta = "Select * From " + lcNomCursor + "_order into cursor " + lcNomCursor + " readwrite"
&lcConsulta
lcCierroCursor = lcNomCursor + "_order"
Use In Select(lcCierroCursor)

Return .F.
