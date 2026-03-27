*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mbuscar

mcFecDes = prg_dtoc(mFecDes )
mcFecHas = prg_dtoc(mFecHas + 1)
mfechanula = "1900-01-01 00:00:00"

mret = sqlexec(mcon1,"select reg_nrohclinica,  reg_nombrepac, "+;
	" TabHCIArchivo.*, TabHCIMovimientos.* " + ;
	",nombre as hci_descMed, hci_descEsp, tabsectores.descrip " +;
	" from tabsectores,TabHCIMovimientos " +;
	" left outer join TabHCIArchivo on TabHCIMovimientos.hci_nroAdm = TabHCIArchivo.hci_nroAdm "+;
	" left outer join registracio on hci_registrac = reg_nroregistrac "+;
	" left outer join prestadores on hci_codmed = prestadores.id "+;
	" where hci_codesp = tabsectores.id " + ;
	" and hci_fechaSal >= ?mcFecDes " +;
	" and hci_fechasal < ?mcFecHas " +;
	" and hci_fechaIngr = ?mfechanula " , "mwkmovhist11" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif

select *,space(50) as hci_retira;
	, iif(hci_origen=0,"ARCH","SECTOR") as desde ;
	from mwkmovhist11 where !isnull(hci_registrac) &mbuscar ;
	order by hci_nroadm into cursor mwkmovhist1

if used('mwkmovhist01')
	use in mwkmovhist01
endif
if used('mwkmovhist02')
	use in mwkmovhist02
endif
if used('mwkmovhist11')
	use in mwkmovhist11
endif
if used('mwkmovhist22')
	use in mwkmovhist22
endif
