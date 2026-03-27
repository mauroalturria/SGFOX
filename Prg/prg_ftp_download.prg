*
* Download FTP Server a Local
*
* murl      : web desde donde descargo
* mlocaldir : directorio local a descargar
* marchiv   : archivo a descargar
*
Lparameters murl, mlocaldir, marchiv

Set LIBRARY TO (LOCFILE("vfpconnection.fll","FLL"))

mftp = murl + marchiv
mloc = mlocaldir + marchiv

mresulta = HTTPGet(mftp, mloc, "msgUpload('"+marchiv+"')")

Set LIBRARY TO

Function msgUpload(marchiv)
	Wait windows "Descargando Archivo [ "+ upper(marchiv) +" ], bytes totales "+alltrim(str(nConnectTotalBytes))+;
	", descargados "+alltrim(str(nConnectBytesSoFar)) nowait
Endfunc
