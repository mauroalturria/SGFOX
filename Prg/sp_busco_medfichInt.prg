*
* Fichadas de Medicos de Guardia
*

Lparameters mcodmed,msalida

If used('mwkbuscamed')
	Use in mwkbuscamed
Endif

if inlist(vartype(msalida),"D","T")
	mbusca = " and TII_fichasal=?msalida "
else
	mbusca = " "
endif
mret = sqlexec(mcon1,"select ID,TII_fichaEnt, TII_fichaSal, TII_sector, TII_supervisor, TII_tipo, TII_usuario FROM ZabIntIEMed  where TII_usuario =?mcodmed  "+;
	mbusca + " order by TII_fichasal ","mwkbuscamed")
**and TGF_estado=1
If mret < 0
	Messagebox("ERROR DE LECTURA DEL PROFESIONAL EN FICHADAS",16,"ERROR")
Endif
