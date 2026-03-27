*
* Solicitud de HC
*
Lparameters mtipo, mestado

If vartype(mtipo) <> "C"
	mtipo = 'INT'
Endif

If vartype(mestado) <> "N"
	mestado = 1
Endif

Use in select("mwksolicint")

mret = sqlexec(mcon1,"select REG_nombrepac,REG_nrohclinica,TLH_fechasol,"+;
	" HCE_descrip,hca_estado,hci_nroadm,pac_motivoalta,hcmdestino,pac_fechaalta"+;
	" from TabLGHce" +;
	" left join TabHCIArchivo on hca_registrac = TLH_nroregis and TabHCIArchivo.hci_nroadm = TabLGHce.TLH_protocolo" +;
	" left join pacientes on PAC_codadmision = TabHCIArchivo.hci_nroadm "+;
	" left join tabhcimovst on hcmnroadm = TabHCIArchivo.hci_nroadm "+;
	" join registracio on REG_nroregistrac = TLH_nroregis" +;
	" left join TabHCEstado on TabHCEstado.hce_id = TabHCIArchivo.hca_estado" +;
	" where TLH_tipo = ?mtipo and TLH_estado = ?mestado"+;
	" group by REG_nrohclinica,hci_nroadm","mwksolicint")

If mret < 0
	Messagebox("CONSULTA REGISTRO HCE LEGALES SOLICITADAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

*!*	Select REG_nrohclinica as lhc,REG_nombrepac as lpac, ;
*!*		nvl(hci_nroadm,space(8)) as ladm,TLH_fechasol as lfsol, ;
*!*		iif(nvl(pac_motivoalta,0)=6,'OBITO ','ADMISION ')+;
*!*		iif(isnull(hca_estado),'NO INGRESADA',;
*!*		ALLTRIM(nvl(hce_descrip,'EN ARCHIVO')))+' '+;
*!*		Alltrim(nvl(hcmdestino,space(34))) as lesta,;
*!*		Alltrim(nvl(hcmdestino,space(34))) as lsect,hcmdestino;
*!*		from mwksolicint into cursor mwksolicint

Select REG_nrohclinica as lhc,;
	REG_nombrepac as lpac, ;
	nvl(hci_nroadm,space(8)) as ladm,;
	TLH_fechasol as lfsol, ;
	iif(nvl(pac_motivoalta,0)=6,'OBITO ','ADMISION ')+;
	iif(isnull(hca_estado),'NO INGRESADA',ALLTRIM(nvl(hce_descrip,'EN ARCHIVO'))) as lesta1,;
	Alltrim(nvl(hcmdestino,space(34))) as lesta,;
	Alltrim(nvl(hcmdestino,space(34))) as lsect,;
	nvl(pac_fechaalta,ctod('  /  /    ')) as lfalta;
	from mwksolicint into cursor mwksolicint

Return .T.
