
gnPos = Ascan(diamedioferiado,mdmasx )
If gnPos = 0
	If oapliini  = 0
		.chck_normal.Value =1
		.chckagenda_tope.Value=0
		.OptAplica.Value= 0
	Endif
Else
	.chck_normal.Value =0
	.chckagenda_tope.Value=1
	lok = .T.
	If oapliini  = 0
		.OptAplica.Value=lhasta

		If .OptAplica.Value=1
			If .txthora1.Value<ltopeh
				.Txttope.Value = Iif(ltoped=0,.txthora1.Value),ltoped)
				mtthrd= Transf(.Txttope.Value,"@L 99:99:00")
				mtthorad=Ctot(mtthrd)
				If .txthora2.Value>ltopeh
					mtthrh= Transf(ltopeh,"@L 99:99:00")
					mtthorah=Ctot(mtthrh)
				Else
					mtthrh= Transf(.txthora2.Value,"@L 99:99:00")
					mtthorah=Ctot(mtthrh)
				Endif
			Else
				Loop
			Endif
		Else
			If .txthora2.Value<=ltopeh
				.Txttope.Value = .txthora2.Value
				mtthrh= Transf(.Txttope.Value,"@L 99:99:00")
				mtthorah=Ctot(mtthrd)
			Else
				.Txttope.Value = ltopeh
				mtthrh= Transf(.Txttope.Value,"@L 99:99:00")
				mtthorah=Ctot(mtthrd)
			Endif
			mtthrd= Transf(.txthora1.Value,"@L 99:99:00")
			mtthorad=Ctot(mtthrd)

		Endif
	Else
		If .OptAplica.Value=1
			If .txthora1.Value>=ltopeh Or .Txttope.Value>=ltopeh
				Loop
			Else
				.Txttope.Value = htopeini 
				mtthrd= Transf(.Txttope.Value,"@L 99:99:00")
				mtthorad=Ctot(mtthrd)
				If .txthora2.Value>ltopeh
					mtthrh= Transf(ltopeh,"@L 99:99:00")
					mtthorah=Ctot(mtthrh)
				Else
					mtthrh= Transf(.txthora2.Value,"@L 99:99:00")
					mtthorah=Ctot(mtthrh)
				Endif
			Endif
		Else
			If .txthora2.Value<=ltopeh
				.Txttope.Value = .txthora2.Value
				mtthrh= Transf(.Txttope.Value,"@L 99:99:00")
				mtthorah=Ctot(mtthrd)
			Else
				.Txttope.Value = ltopeh
				mtthrh= Transf(.Txttope.Value,"@L 99:99:00")
				mtthorah=Ctot(mtthrd)
			Endif
			mtthrd= Transf(.txthora1.Value,"@L 99:99:00")
			mtthorad=Ctot(mtthrd)

		Endif


	Endif
Endif
vr_fechagen = 'Día: '+ Cdow(mdmasx) +' '+ Dtoc(mdmasx)
mntipotur = 0


