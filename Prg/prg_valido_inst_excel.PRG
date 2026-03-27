*!*	Private oleApp
*!*	oleApp = ""
*!*	If !prg_valido_inst_excel(@oleApp)
*!*		
*!*	Endif 
Lparameters tOleApp

lcErrorAnt = ON("ERROR")
On ERROR *
tOleApp = Createobject("excel.application")
On ERROR &lcErrorAnt

Return (Vartype(tOleApp) = "O")