parameters nroregistra, newregistra, mfhdes ,mfhhas ,newhclinica

mret = sqlexec(mcon1, " select pac_codadmision from pacientes,tabhciarchivo where hcmnroadm = pacientes " +;
	" and pac_fechaadmision >= ?mdesde " +;
	" and pac_fechaadmision <= ?mhasta and pac_codhci =?nroregistra","mwkArch")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

select mwkArch
scan
	mnroadm = pac_codadmision
	mret = sqlexec(mcon1," UPDATE tabhciarchivo SET hca_registrac = ?newregistra "+;
		"WHERE hca_registrac = ?nroregistra and hci_nroadm = ?mnroadm "
endscan
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

mret = sqlexec(mcon1, " select pac_codadmision from pacientes,tabhcimovst where hcmnroadm = pacientes " +;
	" and pac_fechaadmision > ?mdesde " +;
	" and pac_fechaadmision < ?mhasta and pac_codhci =?nroregistra ","mwkMov")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

select mwkMov
scan
	mnroadm = pac_codadmision
	mret = sqlexec(mcon1," UPDATE mwkMov SET hcmregistrac = ?newregistra,hcmnrohcli = ?newhclinica " +;
		" WHERE hcmregistrac = ?nroregistra and hcmnroadm = ?mnroadm ")
endscan

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
