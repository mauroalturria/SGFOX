Clear


oCryp = Newobject("Encryption")
?oCryp.safe_b64decode("Q29kQW1iOjEtVHVyOjEyNzc4NTY3")


Return .f.
*!*	Ejemplos
lcTexto = "H"
lcTexto = "Q29kQW1iOjEtVHVyOjEyNzc4NTY3"
?lcTexto

oCryp = Newobject("Encryption")
lcEncryp1 = oCryp.safe_b64encode(lcTexto)
?"-- Encriptado --"
?lcEncryp1
?"--Desencriptado---"
?oCryp.safe_b64decode(lcEncryp1)

Define Class Encryption As Session OlePublic

	Procedure Init

	Endproc

	Function safe_b64encode(lcString)
		lcdata = Strconv(lcString,13)
		lcdata = Strtran(lcdata, "+", "-")
		lcdata = Strtran(lcdata, "/", "_")
		lcdata = Strtran(lcdata, "=", "")
		Return lcdata
	Endfunc

	Function safe_b64decode(lcString)
		lcdata = Strtran(lcString, "-", "+")
		lcdata = Strtran(lcdata, "_", "/")
		mod4 = Len(lcdata) % 4
		If (mod4>0)
			lcdata = lcdata + Substr('====', mod4)
		Endif
		lcdata = Strconv(lcString,14)
		Return lcdata
	Endfunc

	Procedure Destroy

	Endproc

	Procedure Error(nError, cMethod, nLine)

	Endproc

Enddefine

