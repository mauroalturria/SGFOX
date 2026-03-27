* Agregado 2017/04/18
* Fabián
* -------------------------
* Agregar a la unificación:
* TabHTGrupo
* TabHTAnticuerpos
* TabHTCoombsDirecta
* TabHTTransfusiones

Parameters mnroHCvieja,mnroHCnueva

* TabHTGrupo

lcSQL = "SELECT * FROM TabHTGrupo WHERE htg_hc = ?mnroHCvieja"
If !prg_ejecutosql(lcSQL,"mwkTabHTGrupo")
Endif
Select mwkTabHTGrupo
If Reccount("mwkTabHTGrupo")>0
	lcSQL = "UPDATE TabHTGrupo SET htg_hc = ?mnroHCnueva WHERE htg_hc = ?mnroHCvieja"
	If !prg_ejecutosql(lcSQL)
	Endif
Endif

* TabHTAnticuerpos

lcSQL = "SELECT * FROM TabHTAnticuerpos WHERE hta_hc = ?mnroHCvieja"
If !prg_ejecutosql(lcSQL,"mwkTabHTAnticuerpos")
Endif
Select mwkTabHTAnticuerpos
If Reccount("mwkTabHTAnticuerpos")>0
	lcSQL = "UPDATE TabHTAnticuerpos SET hta_hc = ?mnroHCnueva WHERE hta_hc = ?mnroHCvieja"
	If !prg_ejecutosql(lcSQL)
	Endif
Endif

* TabHTCoombsDirecta

lcSQL = "SELECT * FROM TabHTCoombsDirecta WHERE htc_hc = ?mnroHCVieja"
If !prg_ejecutosql(lcSQL,"mwkTabHTCoombsDirecta")
Endif
Select mwkTabHTCoombs
If Reccount("mwkTabHTCoombsDirecta")>0
	lcSQL = "UPDATE TabHTCoombsDirecta SET htc_hc = ?mnroHCNueva WHERE htc_hc = ?mnroHCVieja"
	If !prg_ejecutosql(lcSQL)
	Endif
Endif

* TabHTTransfusiones

lcSQL = "SELECT * FROM TabHTTransfusiones WHERE htt_hc = ?mnroHCVieja"
If !prg_ejecutosql(lcSQL,"mwkTabHTTransfusiones")
Endif
Select mwkTabHTTransfusiones
If Reccount("mwkTabHTTransfusiones")>0
	lcSQL = "UPDATE TabHTTransfusiones SET htt_hc = ?mnroHCNueva WHERE htt_hc = ?mnroHCVieja"
	If !prg_ejecutosql(lcSQL)
	Endif
Endif

Use In Select("mwkTabHTGrupo")
Use In Select("mwkTabHTAnticuerpos")
Use In Select("mwkTabHTCoombsDirecta")
Use In Select("mwkTabHTTransfusiones")

