****
** Separo los datos de busqueda
****

parameter mresp1, mnroitem  


*!*	 "HCIsp1CLASIFsp1HCEsp1NOMBREsp1DOMICsp1TIPODOCsp1NRODOCsp1FECNACsp2
*!*	     HCI    N(8)  := nro. registrac. Interno
*!*	    CLASIF N(2)  := clasif. de parecido. 1..N
*!*	  HCE,NOMBRE,DOMIC,TIPODOC,NRODOC,FECNAC := Datos adic. para browsing
mnroitem  = 0
store '' to dat_busca
do while len(mresp1) > 4
	mnroitem  = mnroitem + 1
	for i= 1 to 8
		mcontad  = atc(chr(9), mresp1)
		mcontrol  = atc(chr(1), mresp1)
		if mcontrol<mcontad 
			mcontd = mcontrol
		endif
		dat_busca( mnroitem, i )= left( mresp1, mcontad - 1  )
		mresp1 = substr( mresp1, mcontad + 1 )
	next i
	if mnroitem >=40
		dime dat_busca(mnroitem +1,8)
	endif

	mcontad 	= atc(chr(1), mresp1, 1)
	mresp1  	= subs(mresp1,  mcontad + 1 )
enddo
