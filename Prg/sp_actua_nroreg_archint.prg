****
** Actualiza datos de archivo de internados para pasaje de consumos
****
parameters nroregistra, newregistra, mfhdes ,mfhhas ,newhclinica

mret = prg_ejecutosql1(" select pac_codadmision from pacientes,tabhciarchivo where hci_nroAdm = PAC_codadmision  " +;
	" and pac_fechaadmision >= ?mfhdes " +;
	" and pac_fechaadmision <= ?mfhhas and pac_codhci =?nroregistra","mwkArch")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

select mwkArch
scan
	mnroadm = pac_codadmision
	mret = prg_ejecutosql1(" UPDATE tabhciarchivo SET hca_registrac = ?newregistra "+;
		"WHERE hca_registrac = ?nroregistra and hci_nroadm = ?mnroadm ")
endscan
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

mret = prg_ejecutosql1(" select pac_codadmision from pacientes,tabhcimovst where hcmnroadm = PAC_codadmision " +;
	" and pac_fechaadmision > ?mfhdes " +;
	" and pac_fechaadmision < ?mfhhas and pac_codhci =?nroregistra ","mwkMov")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

select mwkMov
scan
	mnroadm = pac_codadmision
	mret = prg_ejecutosql1(" UPDATE tabhcimovst SET hcmregistrac = ?newregistra,hcmnrohcli = ?newhclinica " +;
		" WHERE hcmregistrac = ?nroregistra and hcmnroadm = ?mnroadm ")
endscan

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
