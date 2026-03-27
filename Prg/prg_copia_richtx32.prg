lcErrorAnt = ON("ERROR")

*ON ERROR * 
lcDestino = "c:\Qepd1a1\Exe\richtx32.ocx"

lcOrigen = "X:\qepd1a1\Exe\richtx32.ocx"
If !File(lcDestino)
	If File(lcOrigen)
		Copy File (lcOrigen) To (lcDestino)
	Else
		lcOrigen = "H:\qepd1a1\Exe\richtx32.ocx"
		If File(lcOrigen)
			Copy File (lcOrigen) To (lcDestino)
		Else
			&& NO SE PUDO COPIAR
		Endif 
	Endif 
Endif 

ON ERROR &lcErrorAnt