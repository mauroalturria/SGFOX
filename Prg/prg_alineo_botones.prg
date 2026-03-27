Lparameters loForm, lbFijoD

If Parameters() < 2
	lbFijoD = .t.
Endif 

Local loRef, lnRefAnt As CommandButton
Local lnCnt As Container

*!*	loForm = frmprueba_botonera  && PARAMETRO

lnTopFinal = 10  && LINEA DEL CONTENEDOR
lnAnchoSepIni = 1 && SEPARADOR PRIMER BOTON IZQ
lnAnchoSep = 0.5 && SEPARADOR ENTRE BOTONES
lnMargSepSup = 3 && SEPARADOR TOP

If lbFijoD
	lnMargCntDer = 10 && 160
Else
	lnMargCntDer = loForm.Width - (loForm.Container1.left + loForm.Container1.Width)
Endif 	

If Vartype(loForm.Container1)#"O"
	Return .F.
Endif

lnCnt = loForm.Container1
lnIniTop = lnCnt.Top
lnFinTop = lnCnt.Top + lnCnt.Height

Create Cursor cBotones (Name c(20), Left N(4), Top N(4), Width N(3))

For I = 1 To loForm.ControlCount
	If Upper(loForm.Objects(I).Class) = "COMMANDBUTTON" And ;
			Upper(loForm.Objects(I).Name) <> "CMDDOCUMENTACION"

		If loForm.Objects(I).Top >= lnIniTop And loForm.Objects(I).Top <= lnFinTop
			Insert Into cBotones (Name, Left, Top, Width) Values ;
				(loForm.Objects(I).Name, loForm.Objects(I).Left, ;
				loForm.Objects(I).Top, loForm.Objects(I).Width)
		Endif
	Endif
Next 

*!*	For I = 1 To loForm.Objects.Count
*!*		If Upper(loForm.Objects(I).Class) = "COMMANDBUTTON" And ;
*!*				Upper(loForm.Objects(I).Name) <> "CMDDOCUMENTACION"

*!*			If loForm.Objects(I).Top >= lnIniTop And loForm.Objects(I).Top <= lnFinTop
*!*				Insert Into cBotones (Name, Left, Top, Width) Values ;
*!*					(loForm.Objects(I).Name, loForm.Objects(I).Left, ;
*!*					loForm.Objects(I).Top, loForm.Objects(I).Width)
*!*			Endif
*!*		Endif
*!*	Next

Select cBotones
Count To lnCantBotones
Sum(Width) To lnWidth
lnCnt.Width = lnWidth + (lnCantBotones * lnAnchoSep) + (lnAnchoSep * 2)

lnCnt.Left = (loForm.Width - lnCnt.Width - lnMargCntDer)
lnCnt.Top  = lnTopFinal
Index On Left Tag tLeft
Go Top
I = 1
Select cBotones
Scan All
	loRef = Evaluate("loForm." + Alltrim(cBotones.Name))
	loRef.Top = lnCnt.Top + lnMargSepSup
	Select cBotones
	If I = 1
		loRef.Left = lnCnt.Left + lnAnchoSepIni
	Else
		loRef.Left = loRefAnt.Left + loRefAnt.Width + lnAnchoSep
	Endif

	loRefAnt = loRef
	I = I + 1
	Select cBotones
Endscan

Use In cBotones