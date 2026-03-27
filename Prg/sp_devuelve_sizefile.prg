** Marcelo Torres, 28/06/2019
* cNombreArchivo: incluye Path + Extensión.
**-----------------------------------------

Lparameters cNombreArchivo

Local nTamanio
Local oFSO
Local oFile

If !File(cNombreArchivo)
	nTamanio = 0
Else
	oFSO = Createobject("Scripting.FileSystemObject")
	oFile = oFSO.Getfile(cNombreArchivo)
	nTamanio = oFile.Size

	Release oFSO
Endif

Return nTamanio
