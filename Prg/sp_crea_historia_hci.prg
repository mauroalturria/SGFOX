*
* Busco Historia HCI Anteriores
*
Parameters mbuscoxNum

Do sp_busco_historia_hciadm with mbuscoxNum

mune1 = .f.
mune2 = .f.
If used('mwkhistoria')
	If reccount('mwkhistoria') > 0
		mune1 = .t.
	Endif
Endif
If used('mwkhistoria2')
	If reccount('mwkhistoria2') > 0
		mune2 = .t.
	Endif
Endif

If mune1 and mune2

*!*		Select * from mwkhistoria2 union select * from mwkhistoria into cursor mwkhistoria

	Select hci_nroAdm, hca_registrac, pac_codhci, pac_codadmision, pac_fechaalta,;
		pac_nombrepaciente, pac_fechaadmision, hca_estado2, reg_nrohclinica,;
		hca_codbarra, nvl(MTE_Descripcion,space(50)) as MTE_Descripcion,;
		pac_motivoalta, hcmfechaingr, reg_nroRegistrac, hcmdestino, hca_estado,;
		hca_orden, id, hca_motFalta, hca_reimprime, idtarch,HCE_descrip,ent_descrient,;
		hca_depurab,hca_fechaAlta;
		from mwkhistoria;
		union	;
		select hci_nroAdm, hca_registrac, pac_codhci, pac_codadmision, pac_fechaalta,;
		pac_nombrepaciente,	pac_fechaadmision, hca_estado2, reg_nrohclinica,;
		hca_codbarra, nvl(MTE_Descripcion,space(50)) as MTE_Descripcion,;
		pac_motivoalta, hcmfechaingr, reg_nroRegistrac, hcmdestino, hca_estado,;
		hca_orden, id, hca_motFalta, hca_reimprime, idtarch,HCE_descrip,ent_descrient,;
		hca_depurab,hca_fechaAlta;
		from mwkhistoria2;
		into cursor mwkhistoria

Else
	If mune2
		Select * from mwkhistoria2 into cursor mwkhistoria
	Endif
Endif

Return



























