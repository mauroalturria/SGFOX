Parameters mhcmnroadm

mret =sqlexec(mcon1,"select hcmfechasal,hcmretira,hcmdestino,hcmdescmed,"+;
	"Cob_codentidad,ent_descrient,pac_fechaadmision,hcmnrohCli,"+;
	"hcmnroadm,hcmfechaIngr,pac_nombrepaciente"+;
	" from TabHCIMovst"+;
	" left join pacientes On (pacientes.pac_codadmision = TabHCIMovst.hcmnroadm)"+;
	" left join coberturas On (coberturas.cob_pacientes = pacientes.pac_codadmision)"+;
	" left join entidades On (coberturas.cob_codentidad = entidades .ent_codent)"+;
	" where hcmnroadm = ?mhcmnroadm " ,"MwkDetMovHist")

If mret < 0
	Messagebox('Error De Cursor <Sector>, avisar a sistemas',16,'Validación')
	Cancel
	mret=0
Endif

