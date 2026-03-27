Lparameters tcpath , tcfolder

*!*	tcpath   = 'C:\temp\'
*!*	tcfolder = 'quejas'

If Vartype(tcfolder) # 'C' && tcfolder es opcional
   tcfolder = ''
Endif

lcpath   = tcpath
lcfolder = tcfolder
lbreturn = .T.
tcpath   = lcpath + lcfolder

objFSO	 = Createobject ("Scripting.FileSystemObject")
If Vartype( objFSO ) = 'O'							&& Verifico si se pudo crear el objeto
   If !objFSO.FolderExists( tcpath )
      objFSO.CreateFolder( tcpath )
   Endif
Else
   Messagebox('ERROR AL GENERAR CARPETA EN ' + lcpath + ' - REINTENTE',48,"VALIDACION ")
   lbreturn = .F.
Endif

Return lbreturn
