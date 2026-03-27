mfecnul = ctod("01/01/1900")
mfechah = date()
		mret = SQLExec(mcon1,"select TabGuaFich.tgf_fichaent, TabGuaFich.tgf_fichasal, TabGuaFich.TGF_codmed, " + ;
			"Prestadores.Nombre, Prestadores.CodEsp,diagnostico " + ;
			"from TabGuaFich, Prestadores,tabguardia " + ;
			"where Prestadores.id = TabGuaFich.TGF_codmed and " + ;
			" tgf_fichasal = ?mfecnul " + ;
			" and TGF_codmed = codmedcie9 and tabguardia.fechamod>= ?mfechah "+;
			" order by Nombre,tabguardia.fechamod" ,"mwkfichadmed")
if mret<0
	=aerr(eros)
	messagebox(eros(3))
endif
select iif(at('-',diagnostico )>0,left(diagnostico,at('-',diagnostico )-1),;
		alltrim(diagnostico)) as ip,* from mwkfichadmed group by nombre 

