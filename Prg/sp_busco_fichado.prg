*!*	 Fichadas en Guardia
*!*	-----------------------------------------------------
Lparameters mabm, mfechad, mfechah, mbusco, mMatricula

mfecnul = Ctot("01/01/1900")

If mfechad = mfechah
	mfechah = mfechah  + 1
Endif 	

If vartype(mbusco)#"C"
	mbusco = ''
Endif 

If vartype(mMatricula)#"N"
	mMatricula = 0
Endif 

if inlist(mabm,4,5,7 )  and mMatricula > 0

	do sp_busco_1medico With mMatricula
	
	if reccount("mwk1medico") > 0
		mbusco = " and tgf_codmed in ("
		select mwk1medico
		scan All
			
			if recno("mwk1medico") = 1
				mbusco  = mbusco  + " " + alltrim(str(codmedt))
			else
				mbusco  = mbusco  + ", " + alltrim(str(codmedt))
			Endif 	
			
			select mwk1medico
		endscan 	
		mbusco  = mbusco  + " )"
		use in mwk1medico
	endif 
Endif 

if used("mwkfichadmed")
	use in mwkfichadmed 
endif 	

Do Case
	Case mabm = 1
		mret = SQLExec(mcon1,"select Prestadores.id,Prestadores.Nombre, Prestadores.CodEsp; " + ;
			"Cast(matriculas as integer) as matricula, " + ;
			"from TabGuaFich, Prestadores " + ;
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent <= ?mfechah and tgf_fichasal = ?mfecnul " + ;
			"Order by Nombre" ,"mwkfichadmed")

	Case mabm = 2
		mret = SQLExec(mcon1,"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"Prestadores.Nombre, Prestadores.CodEsp " + ;
			"from TabGuaFich, Prestadores " + ;
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent >= ?mfechad  and tgf_fichasal = ?mfecnul " + ;
			"Order by tgf_fichaent, Nombre" ,"mwkfichadmed")


	Case mabm = 3 && MEDICOS Y MEDICOS REEMPLAZANTE
		mfechadpr = mfechad -1
		mret = SQLExec(mcon1,"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"Prestadores.Nombre, Prestadores.CodEsp " + ;
			"from TabGuaFich, Prestadores " + ;
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			"(( tgf_fichaent <= ?mfechah and tgf_fichaent >= ?mfechad ) Or tgf_fichasal = ?mfecnul )" + mBusco + ;
			"Union " + ;
			"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"TabMedExterno.Nombre, TabMedExterno.CodEsp " + ;
			"from TabGuaFich, TabMedExterno " + ;
			"where TabMedExterno.id = TabGuaFich.TGF_codmed and " + ;
			" tgf_fichaent <= ?mfechah and tgf_fichaent >= ?mfechadpr " + mBusco + ;
			"" ,"mwkfichadmed")


	Case mabm = 4
	
		mret = SQLExec(mcon1,"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"Prestadores.Nombre, Prestadores.CodEsp " + ;
			"from TabGuaFich, Prestadores " + ;
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent <= ?mfechah and tgf_fichasal = ?mfecnul " + ;
			mbusco + ;
			"Union " + ;
			"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"TabMedExterno.Nombre, TabMedExterno.CodEsp " + ;
			"from TabGuaFich, TabMedExterno " + ;
			"where TabMedExterno.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent <= ?mfechah and tgf_fichasal = ?mfecnul " + ;
			mbusco + ;
			"","mwkfichadmed")


	Case mabm = 5

		mret = SQLExec(mcon1,"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"Prestadores.Nombre, Prestadores.CodEsp " + ;
			"from TabGuaFich, Prestadores " + ;
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent <= ?mfechah and (tgf_fichasal >= ?mfechad Or tgf_fichasal = ?mfecnul )" + ;
			mbusco + ;
			"Union " + ;
			"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"TabMedExterno.Nombre, TabMedExterno.CodEsp " + ;
			"from TabGuaFich, TabMedExterno " + ;
			"where TabMedExterno.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent <= ?mfechah and (tgf_fichasal >= ?mfechad Or tgf_fichasal = ?mfecnul )" + ;
			mbusco + ;
			"","mwkfichadmed")

	Case mabm = 6 && PARA INFORMES,MEDICOS DE GUARDIA ACTIVOS

		mret = SQLExec(mcon1,"select  Prestadores.id,Prestadores.Nombre, Prestadores.CodEsp "+;
		    ",Prestadores.codespe,Cast(matriculas as integer) as matricula, TPF_filtro,dni  " + ;
			"from TabGuaFich, Prestadores " + ;
			" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ; 
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent >= ?mfechad  and tgf_fichasal = ?mfecnul " + ;
			"Order by  Nombre" ,"mwkfichadmed")

	Case mabm = 7
		mfechahora = sp_busco_fecha_serv("DT") - 3600*18
		mret = SQLExec(mcon1,"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"Prestadores.Nombre, Prestadores.CodEsp " + ;
			"from TabGuaFich, Prestadores " + ;
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent >= ?mfechahora and tgf_fichasal = ?mfecnul " + ;
			mbusco + ;
			"Union " + ;
			"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"TabMedExterno.Nombre, TabMedExterno.CodEsp " + ;
			"from TabGuaFich, TabMedExterno " + ;
			"where TabMedExterno.id = TabGuaFich.TGF_codmed and " + ;
			"tgf_fichaent >= ?mfechahora and tgf_fichasal = ?mfecnul " + ;
			mbusco + ;
			"","mwkfichadmed")


	otherwise

endcase

If mret < 1
	=aerror(eros)
	Messagebox("ERROR EN LA GENERACION DE LOS DATOS",16,"VALIDACION")
*!*		messagebox(eros(3))
Endif

*!*	Sele mwkfichadmed
*!*	Replace tgf_fichasal With ctod("//") For tgf_fichasal = mfecnul 	
*!*	Go Top
