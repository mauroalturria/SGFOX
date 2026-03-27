Parameters tcpath,tdfecha
ldfechac    = tdfecha
lnfolder    = Adir(aArchivos,tcpath + '*','D')
lofilesys   = Createobject("scripting.filesystemobject")
For LNITERA = 1 To lnfolder
	If Isdigit(aArchivos[LNITERA,1]) And Abs(ldfechac-aArchivos[LNITERA,3]) >= 20
		lofilesys.DeleteFolder(tcpath+aArchivos[LNITERA,1],.T.)
	Endif
Next
Release aArchivos
Release lofilesys
Endproc