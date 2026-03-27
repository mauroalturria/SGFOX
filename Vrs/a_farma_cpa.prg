do sp_conexion

mret = sqlexec(mcon1," select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
" nvl(STSALDO.SALDO,0) as saldo,INS_fechapasivo,INS_Stockcritico,INS_Stockreposicion,"+;
" stockmovim.fecha,stockmovim.nromov,cast(stockmovim.cantidad as integer) as canti,"+;
" nvl(STREPIT.entregado,0) as entregado"+;
" from INSUMOS"+;
" left JOIN STSALDO ON INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito=1"+;
" left join stockmovim on stockmovim.codigo = insumos.ins_codinsumo"+;
" left join STREPIT on STREPIT.codigo = insumos.ins_codpuntero and strepit.nromov = stockmovim.nromov"+;
" where (ins_grupo = 'A' or ins_grupo = 'D' or ins_grupo='M' or ins_grupo = 'U'"+;
" or ins_grupo='W')"+;
" and ins_fechapasivo is null"+;
" and stockmovim.codmov = 'RQ'"+;
" and stockmovim.fecha >= to_date('01/04/2007','dd/mm/yyyy')"+;
" and cast(stockmovim.cantidad as integer) <> nvl(STREPIT.entregado,0)"+;
" ORDER BY INS_GRUPO,INS_TIPO,INS_descriinsumo","mwkocpa")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
mret = sqlexec(mcon1," select  PEDCOTART.REQ_ID,ORDCOMPRADET.ORC_ID,ORDCOMPRADET.ART_ID,"+;
" ORDCOMPRADET.ORCD_CANTIDAD,ORDCOMPRADET.ORCD_CANTRECIB,"+;
" ORDCOMPRADET.ORCD_STOCK,ORC_FECHA,orc_estado "+;
" from SQLUser.ORDCOMPRADET,SQLUser.ORDCOMPRA,SQLUser.PEDCOTART"+;
" where SQLUser.ORDCOMPRA.PCT_ID = SQLUser.PEDCOTART.PCT_ID"+;
" and SQLUser.ORDCOMPRADET.ART_ID =SQLUser.PEDCOTART.ART_ID"+;
" and SQLUser.ORDCOMPRA.ORC_ID = SQLUser.ORDCOMPRADET.ORC_ID"+;
" and SQLUser.ORDCOMPRA.ORC_FECHA > '2007-04-01'","mwkpedido")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
select mwkpedido.*,nromov from mwkpedido left join mwkocpa on (nromov = req_id and art_id = ins_codinsumo) into cursor left_farma_cpa
select * from left_farma_cpa ;
	where isnull(nromov) and orc_estado # "CERRA" ;
	and ORCD_CANTIDAD  > ORCD_CANTRECIB;
	into cursor mwkfaltas
browse
copy to w:farma_faltas type fox2x
select * from mwkocpa left join mwkpedido on (nromov = req_id and art_id = ins_codinsumo) into cursor farma_cpa
*copy to w:farma_Cpa2 type fox2x
do sp_desconexion