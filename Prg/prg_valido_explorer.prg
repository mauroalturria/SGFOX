*!*	Private oleApp
*!*	oleApp = ""
*!*	If !prg_valido_explorer(@oleApp)
*!*		
*!*	Endif 
Lparameters tOleApp

lcErrorAnt = ON("ERROR")
On ERROR *
tOleApp = Createobject("InternetExplorer.Application")
*tOleApp = Createobject("chrome.Application")
On ERROR &lcErrorAnt

Return (Vartype(tOleApp) = "O")