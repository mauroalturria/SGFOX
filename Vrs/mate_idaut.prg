	Select Control
 Scan
	Requery('tabautprevia')
	If Reccount('tabautprevia')>0
		Select tabautprevia_qas
		Append From Dbf('tabautprevia')
	Endif
	Select Control
Endscan


Select tabquiromateqas
Go Top
Do While !Eof('tabquiromateqas')
	Requery('tabautprevia_qasusufehca')
	If Reccount('tabautprevia_qasusufehca')=1
		Select tabquiromateqas
		Replace qm_idtabautprevias With tabautprevia_qasusufehca.Id
		Skip 1
	Else
		If Reccount('tabautprevia_qasusufehca')>1
			Select tabautprevia_qasusufehca
			Scan
				Select tabquiromateqas
				Replace qm_idtabautprevias With tabautprevia_qasusufehca.Id
				Skip 1
				If tabquiromateqas.qm_nroregistrac <> tabautprevia_qasusufehca.APV_Registracio
					Select tabquiromateqas
					loop
				ENDIF
				SELECT tabautprevia_qasusufehca
			Endscan
		ELSE
			Select tabquiromateqas
			Skip 1
		Endif
	Endif
Enddo

