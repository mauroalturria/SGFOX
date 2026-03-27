SET STEP ON
 	loWMI = Getobject("winmgmts:\\.\root\cimv2")
	loOS = loWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")
 
		lcCaption = Upper(objOS.Caption)
		? "Sistema Operativo:", lcCaption
	 
 
