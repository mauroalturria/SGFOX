Parameters mnroadmision

* Busco si tiene FEI pedido
* 2018/9
* Devuelve: 0 = No se pidió FEI / 1 = Tiene pedido el FEI / 2 = Externo al SG (no se pide FEI)

Local mPrestaFei,mBuscaFei

mPrestaFei = 0
mBuscaFei = 0

If Vartype(mnroadmision)#"C"
	Return .F.
Endif

* Verifico si el nacimiento se hizo en el SG
lcSQL = "select * from tabrelreg where trr_admdest = ?mnroadmision"
If !Prg_EjecutoSql(lcSQL,"mwkBuscoNac")
	Return .F.
Endif
If Used("mwkBuscoNac")
	If Reccount("mwkBuscoNac")>0

* Busco el nro de prestación del FEI en tabestados (por si cambia en un futuro el valor)
		lcSQL = "select * from tabestados where propietario = 25 and tipo = 47"
		If !Prg_EjecutoSql(lcSQL,"mwkBuscoEstado")
			Return .F.
		Endif
		If Used('mwkBuscoEstado')
			If Reccount('mwkBuscoEstado')>0
*		mPrestaFei = Int(Val(mwkBuscoEstado.Descrip))
				mPrestaFei = Alltrim(mwkBuscoEstado.Descrip)
			Endif
		Endif

* Busco los vales para esta admisión:
		lcSQL = "select * from valesasist where VAL_codadmision = ?mnroadmision and PRESINSUVAS->PIA_codprest = " + mPrestaFei
		If !Prg_EjecutoSql(lcSQL,"mwkBuscoFei")
			Return .F.
		Endif
		If Used('mwkBuscoFei')
			If Reccount('mwkBuscoFei')>0
				mBuscaFei = 1
			Endif
		Endif
	Else
		mBuscaFei = 2
	Endif
Endif

Use In Select('mwkBuscoEstado')
Use In Select('mwkBuscoFei')
Use In Select('mwkBuscoNac')

Return mBuscaFei
