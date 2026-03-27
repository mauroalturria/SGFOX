*
* Fichadas de Medicos de Guardia
*

Lparameters mcodmed,msalida

If used('mwkbuscamed')
	Use in mwkbuscamed
Endif

if inlist(vartype(msalida),"D","T")
	mbusca = " and TGF_fichasal=?msalida "
else
	mbusca = " "
endif
mret = sqlexec(mcon1,"select * from TabGuaFich where TGF_codmed=?mcodmed  "+;
	mbusca + " order by TGF_fichasal ","mwkbuscamed")
**and TGF_estado=1
If mret < 0
	Messagebox("ERROR DE LECTURA DEL PROFESIONAL EN FICHADAS",16,"ERROR")
Endif
