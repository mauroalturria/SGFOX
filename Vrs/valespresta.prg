*!*	Create Cursor Docu (Docu c(9))
*!*	Append From c:\desaguemes\hcli.txt Delimited With Tab
Set Step On
Select vales
Scan
	mivale = vales.vale
	Wait Windows Transform(Recno()) Nowait
	Requery('vales_prestac')
	If Reccount('vales_prestac')>0
		SELECT vales
		replace prestac WITH vales_prestac.pre_descriprest, observacio with vales_prestac.VAL_observaciones
	Endif
Endscan
