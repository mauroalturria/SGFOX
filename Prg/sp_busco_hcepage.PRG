Parameters tcCodEsp, tcCursor

*!*	tcCodEsp = 'OBST'
*!*	tcCursor = "mwkHCEPages"
*!*	Set Step On

	lcSql = "SELECT TabHCEPages.*, nvl(TabHCEPagxEsp.PEG_CodEsp,'')  as PEG_CodEsp, " + ;
		"Cast('' as char(80)) as contenedor  " + ;
		"FROM TabHCEPages " + ;
	"left join TabHCEPagxEsp on TabHCEPagxEsp.PEG_PageId = TabHCEPages.Id and PEG_FPasiva = '1900-01-01' " + ;
	"where PAG_FPasiva = '1900-01-01' and (PEG_CodEsp = ?tcCodEsp or PEG_CodEsp is null)"

If !prg_ejecutoSQL(lcSql,tcCursor,.t.)
	Return .f.
Endif 