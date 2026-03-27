*!* Devolver tipoturno
Parameter ntt,ntipo

If Vartype(ntipo)#"N"
	ntipo=1
Endif

*!*	If Vartype(ntt)#"1"
*!*		ntt = 0
*!*	Endif

If Vartype(ntt)<> "N"
	ntt = 0
ENDIF

If !Used('mwkXTT')
	mret = SQLExec(mcon1, "select * from  TabTipoturno " , "mwkXTT")
Endif
Select mwkXTT
locate For tipoturno = ntt
Do Case
Case ntipo = 1
	Return mwkXTT.abreviatura

Case ntipo = 2
	Return mwkXTT.Descrip
Endcase
