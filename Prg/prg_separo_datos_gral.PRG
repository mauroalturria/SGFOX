****
** Separo los datos que vienen con chr(9) y finaliza con chr(1)
****

Parameter mresp1, nroitem

nroitem = 1
mlen = Len(mresp1)
Store '' To vec_vale
For i = 1 To 26
	Mvar = "mconta"+Transform(i)
	&Mvar  = Atc(Chr(9), mresp1, i)
	If &Mvar = 0
		&Mvar = mlen +1
		Exit
	Endif
Next i
nroitem = i
If mconta1  >0
	vec_vale(1)  = Subs(mresp1,  1, (mconta1 -1))							&&NEM
	For ty= 2 To 26
		Mvarant  = "mconta"+Transform(ty-1)
		Mvar = "mconta"+Transform(ty)
		If Vartype(&Mvar)#"N"
			Exit
		Endif
		vec_vale(ty)  = Subs(mresp1,  &Mvarant  + 1, (&Mvar  -1) - (&Mvarant))	&&DSERV
	Next ty
Else
	vec_vale(2) = mresp1
Endif
