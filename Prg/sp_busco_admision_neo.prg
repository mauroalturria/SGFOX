Parameters mnro_reg, mFecIng

* La consulta del prg es: select PAC_codadmision  from PACIENTES where PAC_codhci = 3792675 and PAC_fechaadmision = '2018-08-14'



*!*	lcSQL = "select Reg_nrohclinica from registracio where REG_nroregistrac = ?mnro_reg"
*!*	If !Prg_EjecutoSql(lcSQL,"mwkadm_temp")
*!*		Return .F.
*!*	Endif
*!*	If Used("mwkadm_temp")
*!*		mnrohce = Alltrim(mwkadm_temp.REG_nrohclinica)
*!*		lcSQL = "select Pac_codadmision from Pacientes_Internados where Pac_codhce = ?mnrohce"
*!*		If !Prg_EjecutoSql(lcSQL,"mwkadm")
*!*			Return .F.
*!*		Endif
*!*		If Used('mwkadm')
*!*			mnroadm = mwkadm.Pac_codadmision
*!*		Endif
*!*	Endif
*!*	If !Len(mnroadm)>0
*!*		Return .F.
*!*	Endif

*!*	Use In Select('mwkadm_temp')
*!*	Use In Select('mwkadm')

*!*	Return mnroadm

mnroadm = ''
lcSQL = "select PAC_codadmision  from PACIENTES where PAC_codhci = ?mnro_reg and PAC_fechaadmision = ?mFecIng"
If !Prg_EjecutoSql(lcSQL,"mwkadm")
	Return .F.
Endif
If Used('mwkadm')
	mnroadm = Alltrim(mwkadm.Pac_codadmision)
Endif
If !Len(mnroadm)>0
	Return .F.
Endif

Use In Select('mwkadm')

Return mnroadm
