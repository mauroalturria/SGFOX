Parameters tnOpcion, xmidevol, xmmedico,xmtipo,xmcodcie,xmpat


mfecfin = CTOD("01/01/2100")
mfechahora = sp_busco_fecha_serv("DT")
xmcodcie = IIF(VARTYPE(xmcodcie)# "N",0,xmcodcie)
xmpat = IIF(VARTYPE(xmpat)# "C",'',xmpat)

Do Case
	Case tnOpcion = 1
		lcSql = "insert into TabIntEpi " + ;
				" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja,IE_patologia, IE_idevol ,IE_tipo)"+;
				" values "+;
				" (?xmcodcie  ,?xmmedico, ?mfechahora,?mfecfin ,?xmpat ,?xmidevol,?xmtipo )" 
	Otherwise

ENDCASE
tcCursor =''
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
