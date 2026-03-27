Lparameters tcpath,tcfolder
*!*	tcpath   = 'C:\temp\'
*!*	tcfolder = 'quejas'
If Vartype(tcfolder) # 'C' &&tcfolder es opcional
	tcfolder = ''
ENDIF

lcfolder = tcfolder 
lcpath   = tcpath

LBRETURN = .T.
tcpath   = lcpath + lcfolder
objFSO	 = Createobject ("Scripting.FileSystemObject")
lbexist	 = objFSO.FolderExists(tcpath)
If lbexist
	If objFSO.DeleteFolder(tcpath)
	Messagebox("CARPETA BORRADA CORRECTAMENTE",64,"VALIDACIÓN")
*		objFSO.CreateFolder(tcpath)
	Endif
Else
	Messagebox("NO EXISTE CARPETA ESPECIFICADA",64,"VALIDACIÓN")
	LBRETURN = .F.
Endif

RETURN LBRETURN 