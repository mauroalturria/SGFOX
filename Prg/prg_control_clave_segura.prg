****
** clave segura
****
Lparameter tcclave
cingresa = Alltrim(tcclave)
npos = 1
nmay = 0
nmin = 0
nnum = 0
nsigno = 0
Do While .T.
	If !Empty(cingresa)
		ncarasc = Asc(Substr(cingresa,1))
		Do Case
		Case Between(ncarasc ,48,57)
			nnum  = nnum + 1
		Case Between(ncarasc ,65,90) Or ncarasc  = 165
			nmay = nmay + 1
		Case Between(ncarasc ,97,122) Or ncarasc  = 164
			nmin = nmin + 1
		Case Between(ncarasc ,33,47)  
			nsigno = nsigno + 1
		Case Between(ncarasc ,58,64)  
			nsigno = nsigno + 1
		Case Between(ncarasc ,91,95)  
			nsigno = nsigno + 1
		Case Between(ncarasc ,123,125)  
			nsigno = nsigno + 1
		ENDCASE
		cingresa = substr(cingresa,2)
	Else
		Exit
	Endif
ENDDO
RETURN  ((nnum >0 AND nmay>0 AND nmin>0 AND nsigno>0 AND LEN(Alltrim(tcclave))>=8) OR EMPTY(tcclave)) OR mxambito>1

