****
**
****
lparameters mfechad,mfechah
*mfecha = date() + 2
mfecnul = CTOD("01/01/1900")
for mfecha= mfechad to mfechah
	mdia = dow(mfecha )

	mret = sqlexec(mcon1,"select nombre, diasem, sala, hdesde1, hhasta1, fecvigend, fecvigenh " + ;
		" ,hhmmdes,hhmmhas,medpresta.codesp,esp_descripcion " +;
		"from medpresta, prestadores,especialid " + ;
		"where fecpasivap = ?mfecnul and medpresta.codmed = prestadores.id and " + ;
		"medpresta.diasem = ?mdia and medpresta.codesp = esp_codesp and " + ;
		"medpresta.fecvigend <= ?mfecha  and medpresta.fecvigenh>?mfecha   " + ;
		" and medpresta.fecvigend <>medpresta.fecvigenh " + ;
		"group by codmed,codesp, diasem, sala, hhmmdes, hhmmhas " + ;
		"order by sala, codmed,codesp, hhmmdes, hhmmhas , fecvigend, fecvigenh", "mwkaaa")

	create cursor consul;
		(nombre c(50), espec c(50), consultorio c(20), dia n(1), h07 n(4,2),h08 n(4,2);
		,h09 n(4,2),h10 n(4,2),h11 n(4,2),h12 n(4,2),h13 n(4,2),h14 n(4,2);
		,h15 n(4,2),h16 n(4,2),h17 n(4,2),h18 n(4,2),h19 n(4,2),h20 n(4,2);
		,h21 n(4,2)	)
	select 	mwkaaa
	go top
	do while !eof()
		mnombre = nombre 
		msala = sala
		mdia = diasem
		mespec = esp_descripcion 
		for i =7 to 21
			mvar="mh"+transf(i,"@L 99")
			&mvar=0
		next
		
		do while !eof() and mnombre = nombre and msala = sala
			for i =floor(hhmmdes/100) to ceiling(hhmmhas/100)
				mvar="mh"+transf(i,"@L 99")
				&mvar=1
			next
			skip
		enddo
		insert into consul (nombre, espec ,consultorio, dia, h07, h08, h09, h10;
		, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21) values ;
		(mnombre, mespec ,msala, mdia, mh07, mh08, mh09, mh10;
		, mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20, mh21)					


	enddo
next	
