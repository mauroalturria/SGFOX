*******************
* Claudia Antoniow
*******************
* Fecha:05/11/2002
*******************
* Actualizado:
*******************
parameters vr_usuvax, vr_FHoraD, vr_FHoraH, vr_condic,vr_pvta,vr_pvtatodos

pvta=vr_pvta
if vartype(vr_pvtatodos)#"C"
	mret=sqlexec(mcon1," SELECT a.*, b.abrevio, REG_nombrepac " + ;
		" FROM  tabformularios as b,tabfacturas as a " + ;
		" left join   registracio  on a.nroregistracio = registracio.REG_nroregistrac  "+ ;
		" WHERE a.tpocte = b.id " + ;
		" AND a.ptovta = ?vr_pvta " + ;
		" AND a.usuario = ?vr_usuvax " + ;
		" AND a.fechahora BETWEEN ?vr_FHoraD "+ ;
		" AND ?vr_FHoraH " + vr_condic +;
		" ORDER BY a.ptovta, a.fechahora ","MWKFacturacion1")

	vr_pvta = pvta +1000
	mret=sqlexec(mcon1," SELECT a.*, b.abrevio, REG_nombrepac " + ;
		" FROM  tabformularios as b,tabfacturas as a " + ;
		" left join   registracio  on a.nroregistracio = registracio.REG_nroregistrac  "+ ;
		" WHERE a.tpocte = b.id " + ;
		" AND a.ptovta = ?vr_pvta " + ;
		" AND a.usuario = ?vr_usuvax " + ;
		" AND a.fechahora BETWEEN ?vr_FHoraD "+ ;
		" AND ?vr_FHoraH " + vr_condic +;
		" ORDER BY a.ptovta, a.fechahora ","MWKFacturacion2")

	vr_pvta = pvta +15
	mret=sqlexec(mcon1," SELECT a.*, b.abrevio, REG_nombrepac " + ;
		" FROM  tabformularios as b,tabfacturas as a " + ;
		" left join   registracio  on a.nroregistracio = registracio.REG_nroregistrac  "+ ;
		" WHERE a.tpocte = b.id " + ;
		" AND a.ptovta = ?vr_pvta " + ;
		" AND a.usuario = ?vr_usuvax " + ;
		" AND a.fechahora BETWEEN ?vr_FHoraD "+ ;
		" AND ?vr_FHoraH " + vr_condic +;
		" ORDER BY a.ptovta, a.fechahora ","MWKFacturacion3")

	select * from MWKFacturacion1 union all select * from MWKFacturacion2;
		union all select * from MWKFacturacion3;
		into cursor MWKFacturacion
else
	mret=sqlexec(mcon1," SELECT a.*, b.abrevio, REG_nombrepac " + ;
		" FROM  tabformularios as b,tabfacturas as a " + ;
		" left join   registracio  on a.nroregistracio = registracio.REG_nroregistrac  "+ ;
		" WHERE a.tpocte = b.id " + ;
		" AND a.ptovta in (" +vr_pvtatodos+")" +;
		" AND a.usuario = ?vr_usuvax " + ;
		" AND a.fechahora BETWEEN ?vr_FHoraD "+ ;
		" AND ?vr_FHoraH " + vr_condic +;
		" ORDER BY a.ptovta, a.fechahora ","MWKFacturacion")
endif
