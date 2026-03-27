*
* Control de versión ejecutable
*
Lparameters mtcVer1, mtcVer2
Local lbResu

If _Vfp.StartMode = 0
	lbResu = .T.
Else
	If vartype(mtcVer1)="N"
		tcVer1 = str(mtcVer1)
	Else
		tcVer1 = mtcVer1
	Endif
	If vartype(mtcVer2)="N"
		tcVer2 = str(mtcVer2)
	Else
		tcVer2 = mtcVer2
	Endif
	lbResu  = .f. 
*	messagebox(transf(tcVer1)+" " +transf(tcVer2))
	
	lcValR1 = Convert_Ver(tcVer1)
	lcValR2 = Convert_Ver(tcVer2)
	lbResu  = (lcValR1 >= lcValR2)
Endif

Return lbResu

*!*	----------------------------------------------------
Function Convert_Ver
Lparameters tcVer

Local lcResu
Local lnPos1, lnPos2, lnPosX
Local lnLen

lnLen  = 4
lnPos1 = At(".",tcVer,1)
lnPos2 = At(".",tcVer,2)
lnPosX = lnPos2 - lnPos1

If lnPos1 = 0
	lcResu = alltrim(tcVer)
Else
	lcResu = ""
	lcResu = lcResu + Padl(Substr(tcVer, 1, lnPos1 - 1),lnLen,"0")
	lcResu = lcResu + Padl(Substr(tcVer, lnPos1 + 1, lnPosX - 1),lnLen,"0")
	lcResu = lcResu + Padl(Substr(tcVer, lnPos2 + 1),lnLen,"0")
Endif
Return lcResu
