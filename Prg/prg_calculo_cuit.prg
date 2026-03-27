Lparameters xsex,xdoc
mpri = 0
lok = .F.
mcuit = ''
If Val(Transform(xdoc))<99999999
	Do While mpri<=2
		If xsex="F"
			cpre = Iif(mpri=0,"27",Iif(mpri=1,"23","29"))
		ELSE
			cpre = Iif(mpri=0,"20","23")
		Endif
		For TY = 1 To 10
			mcuit = cpre+"-" +Transform(xdoc,"@L 99999999")+"-"+Transform((TY-1),"@L 9")

			num01 = Val(Substr(mcuit,1,1))
			num02 = Val(Substr(mcuit,2,1))
			num03 = Val(Substr(mcuit,4,1))
			num04 = Val(Substr(mcuit,5,1))
			num05 = Val(Substr(mcuit,6,1))
			num06 = Val(Substr(mcuit,7,1))
			num07 = Val(Substr(mcuit,8,1))
			num08 = Val(Substr(mcuit,9,1))
			num09 = Val(Substr(mcuit,10,1))
			num10 = Val(Substr(mcuit,11,1))
			num11 = Val(Substr(mcuit,13,1))

			msuma = 0

			msuma = msuma + (num10 * 9)
			msuma = msuma + (num09 * 8)
			msuma = msuma + (num08 * 7)
			msuma = msuma + (num07 * 6)
			msuma = msuma + (num06 * 5)
			msuma = msuma + (num05 * 4)
			msuma = msuma + (num04 * 9)
			msuma = msuma + (num03 * 8)
			msuma = msuma + (num02 * 7)
			msuma = msuma + (num01 * 6)

			mresto = Round(msuma % 11, 0)

			If mresto = num11
				lok = .T.
				Return (mcuit )
			Endif
		Next TY
		If !lok
			mpri = mpri+1
			mcuit = ''
		Endif
	Enddo
Endif
Return (mcuit )
