Lparameters lnCtrlDias

ldFecha = sp_busco_fecha_serv('DD')

If Vartype(lnCtrlDias) = "N"

	Do sp_busco_stprogram With 4, ldFecha-lnCtrlDias
 
	If Reccount("MwkStProg") > 0
		Use In MwkStProg
		Return .F.
	Endif
	
	Use In MwkStProg
Endif

Private ldFecAlta, lnId, lcIp, lnTipo, lcWindows 

lnId = 0
lcOS = sp_os()
wait windows "Verificación de Software Instalado... Un momento por favor..." nowait

If Not "WIN9" $ lcOS Or Directory("c:\Documents and Settings") && tendria que ser superior y fincionar wmi

	lnTipo = 1
*!*		Do sp_busco_stprogram With 2, lnId, MyIp, ldFecha, lnTipo
*!*		If Reccount("MwkStProg") = 0
		Do Prog_OS
*!*		Endif 
	lnTipo = 2
*!*		Do sp_busco_stprogram With 2, lnId, MyIp, ldFecha, lnTipo
*!*		If Reccount("MwkStProg") = 0
		Do Prog_WMI
*!*		Endif 
	lnTipo = 4
*!*		Do sp_busco_stprogram With 2, lnId, MyIp, ldFecha, lnTipo
*!*		If Reccount("MwkStProg") = 0
		Do NetAdapter
*!*		Endif 

	lnTipo = 5
*!*		Do sp_busco_stprogram With 2, lnId, MyIp, ldFecha, lnTipo
*!*		If Reccount("MwkStProg") = 0
		Do Memoria
		do prg_leoprgregistry

else
	Do sp_update_stprogram With lnId, MyIp, "Windows no XP "+alltrim(lcOS), 1, ldFecha
Endif 

lnTipo = 3
*!*	Do sp_busco_stprogram With 2, lnId, MyIp, ldFecha, lnTipo
*!*	If Reccount("MwkStProg") = 0
	Do Prog_DIR
*!*	Endif 



*----------------------------------------------------------
Procedure Memoria
*----------------------------------------------------------
lcError = On("ERROR")

On Error Do Cargo_Error_WMI
oWMILocator = createobject("WbemScripting.SWbemLocator")
On Error &lcError
if Not vartype(oWMILocator) = "O"
	Return .f.
Endif 

objWMI = oWMILocator.ConnectServer(".", "root\cimv2")
colSoftware = objWMI.ExecQuery("SELECT * FROM Win32_PhysicalMemory")

For Each objSoftware In colSoftware 
	
	lcCapacity = Alltrim(Str(Val(objSoftware.Capacity)/1024/1024) + " MB ")
	lcDeviceLocator = " Banco " + Alltrim(objSoftware.DeviceLocator)
	lcFormFactor = " Factor " + prg_stMemFormFactor(objSoftware.FormFactor)
	lcMemoryType = " Type " + prg_StMemoryType(objSoftware.MemoryType)
	
	lcDescrip = lcCapacity + " | " + lcDeviceLocator
	lcDescrip = lcDescrip + " | " + lcFormFactor + " | " + lcMemoryType 
	
	Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldFecha
Next 

Release oWMILocator 
Release colSoftware


*----------------------------------------------------------
Procedure NetAdapter
*----------------------------------------------------------
lcError = On("ERROR")

On Error Do Cargo_Error_WMI
oWMILocator = createobject("WbemScripting.SWbemLocator")
On Error &lcError
if Not vartype(oWMILocator) = "O"
	Return .f.
Endif 

objWMI = oWMILocator.ConnectServer(".", "root\cimv2")
colSoftware = objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled = True")

For Each objSoftware In colSoftware 
	lcDescri1 = Alltrim( objSoftware.Caption )
	lcDescrip = lcDescri1 + " | " + transform(Alltrim( objSoftware.MACAddress))
	
	Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldFecha
Next 

Release oWMILocator 
Release colSoftware

*----------------------------------------------------------
Procedure Prog_OS
*----------------------------------------------------------

lcError = On("ERROR")
On Error Do Cargo_Error_WMI
oWMILocator = createobject("WbemScripting.SWbemLocator")
On Error &lcError
if Not vartype(oWMILocator) = "O"
	Return .f.
Endif 
objWMI = oWMILocator.ConnectServer(".", "root\cimv2")

colSoftware = objWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")

For Each objSoftware In colSoftware 
	lcDescri1 = Alltrim( objSoftware.Name )
	lcDescrip = substr(lcDescri1,1,-1+at("|",lcDescri1, 1 ))
	Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldFecha
Next 

Release oWMILocator 
Release colSoftware
	
*----------------------------------------------------------
Procedure Prog_DIR
*----------------------------------------------------------
lcDir = "c:\Archivos de programa\"
lnCant = Adir(laDirs,lcDir + "*.*","D")	

For I = 3 to lnCant
	lcDescrip = Alltrim(laDirs(I,1))
	Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldFecha
Next

lcDir = "c:\Program Files\"
lnCant = Adir(laDirs,lcDir + "*.*","D")	

For I = 3 to lnCant
	lcDescrip = Alltrim(laDirs(I,1))
	Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldFecha
Next


*----------------------------------------------------------
Procedure Prog_WMI
*----------------------------------------------------------
lcError = On("ERROR")
On Error Do Cargo_Error_WMI
oWMILocator = createobject("WbemScripting.SWbemLocator")
On Error &lcError
if Not vartype(oWMILocator) = "O"
	Return .f.
Endif 

objWMI = oWMILocator.ConnectServer(".", "root\cimv2")

colSoftware = objWMI.ExecQuery("SELECT * FROM Win32_Product")


For Each objSoftware In colSoftware 
	
	lcDescrip = Alltrim( objSoftware.Name )
	Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldFecha
	
Next 

Release oWMILocator 
Release colSoftware

*----------------------------------------------------------
Procedure Cargo_Error_WMI
*----------------------------------------------------------
lcDescrip = 'ERROR WMI'

Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldFecha

Return .f.	
