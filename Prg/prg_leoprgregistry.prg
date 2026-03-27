
#Define HKEY_CURRENT_USER   -2147483647
#Define HKEY_LOCAL_MACHINE  -2147483646

Private regfile,nErrNum,lDrivers
Private oReg && as Registry Of "C:\ARCHIVOS DE PROGRAMA\MICROSOFT VISUAL FOXPRO 9\SAMPLES\classes\registry.prg"

Set Procedure To registry.prg Additive
oReg = Createobject("registry")

Private mFechaHoy
mFechaHoy = sp_busco_fecha_serv("DT")

Do Obt_Keys With HKEY_LOCAL_MACHINE, "SOFTWARE\", 6, ''
Do Obt_Keys With HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\", 7, ''

Do Obt_Keys With HKEY_CURRENT_USER, "SOFTWARE\", 8, ''
Do Obt_Keys With HKEY_CURRENT_USER, "SOFTWARE\Microsoft\", 9, ''

Do Obt_Keys With HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\", 10, "DisplayName"

Release oReg 
oReg = .f.


*-------------------------------------------------------------------
Procedure Obt_Keys()
	Lparameters lcKeyPrinc, lcKey, lnParentId, lcValor
	*-------------------------------------------------------------------
	Local arrData, I, lcData, lnCant, lnId
	Dimension arrData[1000]

	oReg.openkey(lcKey,lcKeyPrinc,.F.)
	oReg.enumkeys(@arrData)
	lnCant = Alen(arrData)

	For I = 1 To lnCant

		If Type("arrData(I)") = "C"
			lcData = Alltrim( arrData(I) )
		Else
			lcData = ''
		Endif
		
		If !Empty(lcData)

			lcDisplayName = ''
			If !Empty(lcValor)
				lcDisplayName = ObtValor(lcValor, Alltrim(lcKey) + lcData, lcKeyPrinc)
			Endif 
			
			If !Empty(lcDisplayName)
				lcResu = lcDisplayName
			Else
				lcResu = Alltrim(lcData) 
			Endif 	
			
			Do sp_update_stprogram With 0, MyIp, lcResu , lnParentId, mFechaHoy
		Endif
	Next


*-------------------------------------------------------------------
Function ObtValor
Lparameters lcProp, lcKey, lcKeyPrinc
*-------------------------------------------------------------------

Local arrData, I, lcData, lnCant, lnId 
Dimension arrData[1000]

lcResu = ''
If oReg.GetRegKey(lcProp,@arrData,lcKey, lcKeyPrinc) = 0
	If Type("arrData(1)") = "C"
		lcResu = arrData(1)
	Endif 
Endif 

Return  lcResu
