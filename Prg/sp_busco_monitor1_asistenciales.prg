parameters mfecdes,mchkvale,mtxtvale
do case
	case mchkvale = 1
		mmesag = 'EL VALE SOLICITADO,'
		migual = mtxtvale
		mwhere = " where VSEcodvale = ?migual "
	otherwise
		mwhere = " where VSEfechasolic >= ?mfecdes "
endcase
use in select("mwkvalfar")
use in select("mwkvales")
mwhere = " where VSEfechasolic >= ?mfecdes"
mret = sqlexec(mcon1, "select cast(0 as integer ) as esta,vsefechasolic,valesector, NPSDescripcion  as sec_descripsec,vsesecuencia,vseestado " + ;
	" from ValesSector "+;
	" left join npsec on ValesSector.VSEcodsector  = npsec.NPSSector "+mwhere+;
	" order by VSEfechasolic desc ,vsehorasolic desc  ", "mwkvalfar")
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS 111111", 16, "Validacion")
endif

mret = sqlexec(mcon1, "select ValesSector.*,"+;
	" IVScantidad,INS_codpuntero,INS_codinsumo,NPSDescripcion  as sec_descripsec,INS_descriinsumo " + ;
	" from ValesSector left join InsValeSec on InsValeSec.IVSCodVale = ValesSector.VSEcodvale "+;
	" left join insumos on InsValeSec.IVSinsumo = insumos.INS_codpuntero "+;
	" left join npsec on ValesSector.VSEcodsector  = npsec.NPSSector "+mwhere+;
	" order by VSEfechasolic,VSEcodvale ", "mwkvales")
