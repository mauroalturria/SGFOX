
lparameters midGrup,mtipo

if vartype(MTIPO)="N"
	mbustipo = " tipo = ?mtipo and fecactiva <> ?mfechaact "
else
	mbustipo = " tipo <3 and fecactiva <> ?mfechaact "

endif
*********************************************************************************
* BUSCA Datos de grupos autoriazados a ver ciertos codumentos
*********************************************************************************
mfechaact  = ctod("01/01/1900")
midGrup =iif(empty(midGrup)," 1= 2",midGrup )
mret = sqlexec(mcon1,"select codigoproc,denominacion,TabGcvincproc.revision,idGrupo,"+;
	"ubicacion ,TabGcproc.id,fecha,idRelac->codigoproc as codigobase "+;
	",cast(CASE  WHEN idRelac = TabGcproc.id THEN 0  ELSE 1 END as Integer) as base "+;
	"from TabGcproc "+;
	"left join TabGcgrupodoc  on  TabGcgrupodoc.iddocumento = TabGcproc.id "+;
	"left join TabGcvincproc on TabGcvincproc.idDoc = TabGcproc.id "+;
	"where ( " + midGrup + " )  and  " +mbustipo,"mwkGrupoAutprev" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
mret = sqlexec(mcon1,"select codigoproc,denominacion,TabGcvincproc.revision,idGrupo,"+;
	"ubicacion ,TabGcproc.id,fecha,idRelac->codigoproc as codigobase "+;
	",cast(CASE  WHEN idRelac = TabGcproc.id THEN 0  ELSE 1 END as Integer) as base "+;
	"from TabGcproc "+;
	"left join TabGcgrupodoc  on  TabGcgrupodoc.iddocumento = TabGcproc.id "+;
	"left join TabGcvincproc on TabGcvincproc.idDoc = TabGcproc.id "+;
	"where  " +mbustipo+ " group by codigoproc ","mwkGrupotot" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
select *,1 as propios from mwkGrupoAutprev;
	union all select *,0 as propios from mwkGrupotot where codigoproc not in (select codigoproc from mwkGrupoAutprev );
	into cursor mwkGrupoAut
