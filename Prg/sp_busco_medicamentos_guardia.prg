****
**
****

mfecpas = ctod('01/01/1900')

mret = sqlexec(mcon1, "select INS_descriinsumo, INS_codinsumo, INS_grupo, insumos " + ;
	"from insumos where INS_fechapasivo is null and " + ;
	"INS_grupo in('D', 'M', 'U', 'W') and " + ;
	"insumos not in ( select codinsumo from guardiainsumos " + ;
	"where fechapasiva = ?mfecpas ) " + ;
	"order by INS_descriinsumo ", "mwkmedica")

mret = sqlexec(mcon1, "select INS_descriinsumo, INS_codinsumo, INS_grupo,"+;
	" insumos.insumos ,INS_fechapasivo " + ;
	"from insumos, guardiainsumos " + ;
	"where fechapasiva = ?mfecpas and " + ;
	"guardiainsumos.codinsumo = insumos.insumos " + ;
	"order by INS_descriinsumo ", "mwkmedica1")
