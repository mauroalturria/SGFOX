Parameters tcCodEsp, tcCursor

*!*	tcCodEsp = 'OBST'
*!*	tcCursor = "mwkHCEPages"
*!*	Set Step On

	lcSql = "SELECT TabHCEPages.*, nvl(TabHCEPagxEsp.PEG_CodEsp,'')  as PEG_CodEsp, " + ;
		"Cast('' as char(80)) as contenedor  " + ;
		"FROM TabHCEPages " + ;
	"inner join TabHCEPagxEsp on TabHCEPagxEsp.PEG_PageId = TabHCEPages.Id and PEG_FPasiva = '1960-07-16' " + ;
	"where PAG_FPasiva = '1900-01-01' and (PEG_CodEsp = ?tcCodEsp)"

If !prg_ejecutoSQL(lcSql,tcCursor,.t.)
	Return .f.
Endif 