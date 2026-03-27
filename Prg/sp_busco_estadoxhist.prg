*
* Busqueda de H.C., movimientos x Estado
*

Parameters mhcmnrohCli, mwhere

If vartype(mwhere) <> "C"
	mwhere = ""
Endif

mret = sqlexec(mcon1,"select hcmnrohCli,pac_nombrepaciente,hcmnroadm,pac_fechaadmision,"+;
	" hcmretira,hcmdestino,hcmdescmed,Cob_codentidad,ent_descrient,hcmfechaIngr,"+;
	" ent_descrient,hcmfechasal,hca_fechaAlta "+;
	" from (TabHCIMovst join TabHCIArchivo On hcmnrohCli = ?mhcmnrohCli"+mwhere+")"+;
	" left outer join pacientes On (pac_codadmision = hcmnroadm)"+;
	" left outer join coberturas On (cob_pacientes = pac_codadmision)"+;
	" left outer join entidades On (cob_codentidad = ent_codent)","MwkExisEnTab")

If mret < 0
	Messagebox("EN CONSULTA DE H.C. MOVIMIENTOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

