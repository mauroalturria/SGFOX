*******************
* control cajas
*******************
Parameters mfecdes, mfechas, vr_pvta,vr_pvtaall,ltodos,lvales
ltodos = Iif(Vartype(ltodos)<>"N",1,ltodos)
lvales = Iif(Vartype(lvales)<>"N",0,lvales)
mcptva= "("+Iif(ltodos=1,vr_pvtaall,Transform(vr_pvta))+")"
If lvales= 0
	mret=SQLExec(mcon1," SELECT a.*, idusuario, nomape, b.abrevio, REG_nombrepac,REG_nrohclinica,ent_descrient,CAST(0 as integer) as VAL_codservvale " +;
	" FROM tabformularios as b,tabfacturas as a " +;
	" left join registracio on a.nroregistracio = registracio.REG_nroregistrac " +;
	" Left join tabusuario on a.usuario = tabusuario.codigovax "+;
	" Left join entidades on a.codent = entidades.ent_codent "+;
	" WHERE a.tpocte = b.id " +;
	" AND a.ptovta in " +mcptva+;
	" AND a.fechacte BETWEEN ?mfecdes " +;
	" AND ?mfechas  " +;
	" ORDER BY a.ptovta,a.tpocte,a.aplinrocte ","MWKFacturacion0")
Else
	mret=SQLExec(mcon1," SELECT a.*, idusuario, nomape, b.abrevio, REG_nombrepac,REG_nrohclinica,ent_descrient,VAL_codservvale  " +;
	" FROM tabformularios as b,tabfacturas as a " +;
	" left join registracio on a.nroregistracio = registracio.REG_nroregistrac " +;
	" Left join tabusuario on a.usuario = tabusuario.codigovax "+;
	" Left join entidades on a.codent = entidades.ent_codent "+;
	" Left join valesasist on a.codpun = valesasist.VAL_codpun "+;
	" WHERE a.tpocte = b.id " +;
	" AND a.ptovta in " +mcptva+;
	" AND a.fechacte BETWEEN ?mfecdes " +;
	" AND ?mfechas  " +;
	" ORDER BY a.ptovta,a.tpocte,a.aplinrocte ","MWKFacturacion0")

Endif

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR de Facturacion, REINTENTE",16, "Validacion")
	mret=0
	Cancel
Endif

