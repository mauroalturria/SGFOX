If !Directory("c:\Windows\SigPlus")
	ofilsigplus   = Createobject ("Scripting.FileSystemObject")
	ofilsigplus.CopyFolder("X:\qepd1a1\SigPlus","c:\tempdoc\",.T.)
	Run /N  c:\tempdoc\SigPlus\lala.Exe
	Release ofilsigplus
Endif
