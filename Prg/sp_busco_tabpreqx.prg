parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkPQX'
endif
mfechanul = ctod("01/01/1900")

if mxambito >1
	tcWhere = tcWhere+ iif(empty(tcWhere)," where "," and ")+" PQ_codambito = ?mxambito "
endif

tcWhere = tcWhere+ iif(empty(tcWhere)," where "," and ")+" PQ_fecPasiva = '1900-01-01' "
 

use in select(tcCursor)
do case
	case tnOpcion = 1
		lcSql = "select TabPQX.*,PQ_CodPrest->Pre_Descriprest,PQ_CodPrest->pre_codservicio,PQ_servicio->ser_descripserv "+;
			",PQ_coddiag->DescrAbrev "+;
			" from TabPQX " + ;
			tcWhere + " order by PQ_fechaProg,id "
	case tnOpcion = 2
		lcSql = "select TabPQX.*,PQ_CodPrest->Pre_Descriprest,PQ_CodPrest->pre_codservicio,PQ_servicio->ser_descripserv "+;
			",PQ_coddiag->DescrAbrev "+;
			" from TabPQX " + ;
			tcWhere + " order by PQ_fechaProg,id "
	case tnOpcion = 3
		lcSql = "select TabPQX.id,PQ_servicio,PQ_apto  "+;
			" from TabPQX " + ;
			tcWhere + " and PQ_fecPasiva =?mfechanul  order by PQ_fechaProg,id "


	otherwise
		lcSql =''
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
