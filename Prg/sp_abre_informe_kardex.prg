
Local lcUrl
Local obj
LOCAL cProgram

cProgram = ""
cUrl = ""

DO sp_conexion

* Obtenemos la url desde TabEstados
Do sp_busco_estados With 57, " and tipo = 82 and estado = 1 ", "mwkurl"

Select mwkurl
Go Top

lcUrl = Alltrim(mwkurl.Descrip)

If !Empty(lcUrl)

	Do Case
	Case File("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
		cProgram = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
	Case File("C:\Program Files\Google\Chrome\Application\chrome.exe")
		cProgram = "C:\Program Files\Google\Chrome\Application\chrome.exe"
	Endcase

	If !Empty(cProgram)
		o = Createobject("Shell.Application")
		o.ShellExecute(cProgram, lcUrl, "", "open", 1)
	Else
		Messagebox("No se ha obtenido resultados para la consulta.",16,"URL Kardex")
	Endif

Else
	Messagebox("No se ha obtenido resultados para la consulta.",16,"URL Plexus")
Endif

DO sp_desconexion

