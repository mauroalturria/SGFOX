Lparameters mRegistracio ,mtipo
If Vartype(mtipo)<>"N"
	mtipo =1
Endif
mret = SQLExec(mcon1,"select  a.Afi_nroafiliado,ent_descrient,ENT_nroprestadorexterno " +;
	"from afiliacion as a " +;
	"inner Join Entidades as d on d.ENT_codent = a.AFI_codentidad  " + ;
		"Where a.registracio = ?mRegistracio Order By a.AFI_fechabaja ","mwkafi")

If mret < 0
	Messagebox("ERROR AL BUSCAR ENTIDAD. AVISE A SISTEMAS", 48, "Validacion")
	Return (Space(40))

Endif

Select mwkafi
If mtipo = 1
	Return (ent_descrient )
Else
	Return (Afi_nroafiliado)
Endif
