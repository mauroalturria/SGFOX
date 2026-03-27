*
* Busqueda de insumos para auditar
*

Parameters mfecdes

If used('mwkfaraudit0')
	Use in mwkfaraudit0
Endif

mret = sqlexec(mcon1, "select TFE_auditado,TFE_codinsumo,TFE_desmaestr," + ;
    "TFE_desenetiq,ID "+;
	"from TabFarmEtiq " + ;
	"where TFE_fechaemite >= ?mfecdes and TFE_auditado=0 and TFE_estadocambio='1'","mwkfaraudit0")

If mret < 0
	=aerr(eros)
	Messagebox("ERROR "+eros(3)+"GENERACION - AUXILIAR DE INSUMOS -, AVISAR A SISTEMAS", 16, "Validacion")
	Return
Endif

Select mwkfaraudit
Zap

Select mwkfaraudit0
Go top

Scan

	Insert into mwkfaraudit ;
		(TFE_auditado, TFE_codinsumo, TFE_desmaestr, TFE_desenetiq,TFE_ID) values ;
		(0, mwkfaraudit0.TFE_codinsumo, mwkfaraudit0.TFE_desmaestr, mwkfaraudit0.TFE_desenetiq, mwkfaraudit0.ID)

Endscan

Select mwkfaraudit
Go top