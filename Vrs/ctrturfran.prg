Select grupo
Go Top
mfec= fechatur
dia = diasem_b
mcm = codmed_b
Skip
Do While !Eof()
	Do While !Eof() And dia = diasem_b And mcm = codmed_b
		If Inlist(mfec+7,Ctod("23/11/2020"),Ctod("07/12/2020"),Ctod("08/12/2020"))
			mfec= mfec+7
		Endif
		If mfec+7 = fechatur Or fechatur = Ctod("24/12/2020") Or Between(mfec+7 ,bloquedesde,bloquehasta)
			mfec= fechatur
			Skip 1

			Loop
		Else
			Set Step On
			mfec= fechatur
			Skip 1
			Loop
		Endif
	Enddo
	mfec= fechatur
	dia = diasem_b
	mcm = codmed_b
	Skip
Enddo
