*!*	Create Cursor Docu (Docu c(9))
*!*	Append From c:\desaguemes\hcli.txt Delimited With Tab
Set Step On
Select corregir
Use ctrlunif Again In 0
Use tabregvacuxr Again In 0
Select corregir
Scan
	mireg = corregir.VAR_NROREG
	Wait Windows Transform(Recno()) Nowait
	Requery('ctrlunif')
	If Reccount('ctrlunif')>0
		minreg = ctrlunif.REG_nroregistracO
		Requery('tabregvacuxr')
		If Reccount('tabregvacuxr')>0
			Select tabregvacuxr
			Update tabregvacuxr Set VAR_NROREG = minreg
		Endif
		Do While mireg = corregir.VAR_NROREG
			Select corregir
			Skip 1
		Enddo
	Endif
Endscan
