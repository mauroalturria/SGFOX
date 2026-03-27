*!*	Private oleApp
*!*	oleApp = ""
*!*	If !prg_valido_inst_word(@oleApp)
*!*		
*!*	Endif 
Lparameters tOleApp

lcErrorAnt = ON("ERROR")
On ERROR *
tOleApp = Createobject("Word.Application")
On ERROR &lcErrorAnt

Return (Vartype(tOleApp) = "O")