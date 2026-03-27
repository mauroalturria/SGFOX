*****
** Busco Vales - Farmacia
****

lparameter mfdesde,mfhasta


mret = sqlexec(mcon1, "select VSEfechasolic, VSEhorasolic ,VSEcodvale,  VSEobservac, "+;
	" IVScantidad,INS_codpuntero,INS_codinsumo,INS_descriinsumo " + ;
	" from ValesSector left join InsValeSec on InsValeSec.IVSCodVale = ValesSector.VSEcodvale "+;
	" left join insumos on InsValeSec.IVSinsumo = insumos.INS_codpuntero "+;
	"where VSEcodsector='GUA' and VSEfechasolic>= ?mfdesde " + ;
	"and VSEfechasolic <= ?mfhasta " + ;
	"order by VSEfechasolic,VSEcodvale ", "mwkvalfar")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
endif
