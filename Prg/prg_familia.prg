Lparameters xnreg 
nreg=  xnreg 
lcSql = "select TRF_NroRegFliar from Zabregflia where TRF_Nroregistrac = ?nreg and TRF_FPasiva='1900-01-01' "
tcCursor = 'mwkxflia'
If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
xnregflia = IIF(NVL(mwkxflia.TRF_NroRegFliar,0)=0,xnreg,mwkxflia.TRF_NroRegFliar )
Return xnregflia 
