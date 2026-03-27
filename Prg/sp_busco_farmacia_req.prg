*
* Requisiciones de Farmacia
*

if used('mkwinforme')
	use in mwkinforme
endif

mret = sqlexec(mcon1,"select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
	"nvl(STSALDO.SALDO,0) as saldo,INS_Stockcritico,INS_Stockreposicion,"+;
	"stockmovim.fecha as fecha1,stockmovim.nromov as numero,nvl(stockmovim.cantidad,0) as cantidad,"+;
	"nvl(STREPIT.entregado,0) as entregado"+;
	" from INSUMOS"+;
	" left JOIN STSALDO ON INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito=1"+;
	" left join stockmovim on stockmovim.codigo = insumos.ins_codinsumo"+;
	" left join STREPIT on STREPIT.codigo = insumos.ins_codpuntero and"+;
	" strepit.nromov = stockmovim.nromov"+;
	" where (ins_grupo = 'A' or ins_grupo = 'D' or ins_grupo = 'M' or ins_grupo = 'U'"+;
	" or ins_grupo = 'W')"+;
	" and ins_fechapasivo is null"+;
	" and stockmovim.codmov = 'RQ'"+;
	" and stockmovim.fecha >= to_date('01/11/2009','dd/mm/yyyy')"+;
	" and cast(nvl(stockmovim.cantidad,0) as integer)<>nvl(STREPIT.entregado,0) "+;
	" ORDER BY INS_GRUPO,INS_TIPO,INS_descriinsumo","mwkinforme")

if mret < 0
	messagebox("EN CONSULTA DE REQUISICIONES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
endif
