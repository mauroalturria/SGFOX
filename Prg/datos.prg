*-----------------------------------------
* Retorna el nombre de la PC y recurso compartido
* de una coneccion de red
* PARAMETROS: lcDrive
* USO: _GetConnec("K:")
*-----------------------------------------

unidad = _GetConnec("X:")

? unidad

Function _GetConnec(lcDrive)
	Declare INTEGER WNetGetConnection IN WIN32API ;
		STRING lpLocalName, ;
		STRING @lpRemoteName, ;
		INTEGER @lpnLength
	Local cRemoteName, nLength, lcRet, llRet
	cRemoteName=SPACE(100)
	nLength=100
	llRet = WNetGetConnection(lcDrive,@cRemoteName,@nLength)
	lcRet = LEFT(cRemoteName,AT(CHR(0),cRemoteName)-1)
	Return lcRet
Endfunc
