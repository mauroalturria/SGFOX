****
** busco sectores
****
lparameters mbuscoTM,mbuscoG, mfecdes, mfechas,mbuscodep,nopclista

mret = sqlexec(mcon1, "SELECT descripcion, grupo"+;
	 " from STGRUATC ", "mwkgrupoatc")
mret = sqlexec(mcon1, "SELECT StockMovim.cantidad,StockMovim.codigo,"+;
	"StockMovim.codmov,StockMovim.fecha,StockMovim.nromov"+;
	" ,INS_descriinsumo,INS_CriterioAC , INS_Stockcritico "+;
	",cast({fn LEFT(INS_CodATC,3)} as char(3)) as codigoatc "+;
	" ,INS_Stockreposicion , INS_Vademecum,ins_criterioac -> descripcion as desc_aut " +;
	" FROM StockMovim, insumos "+;
	" where INS_codinsumo = codigo  "+;
	" and fecha >=?mfecdes and  fecha <=?mfechas "+;
	" &mbuscoTM &mbuscoG ", "mwkconsumos")

**SET STEP ON

*!*	mret = sqlexec(mcon1, "SELECT StockMovim.cantidad,StockMovim.codigo,"+;
*!*		"StockMovim.codmov,StockMovim.fecha,StockMovim.nromov"+;
*!*		" ,INS_descriinsumo,INS_CriterioAC , INS_Stockcritico "+;
*!*		",cast({fn LEFT(INS_CodATC,3)} as char(3)) as codigoatc "+;
*!*		" ,INS_Stockreposicion , INS_Vademecum,ins_criterioac -> descripcion as desc_aut " +;
*!*		" FROM StockMovim " +;
*!*		" inner join insumos on insumos.INS_codinsumo = StockMovim.codigo  "+;
*!*		" where fecha >=?mfecdes and  fecha <=?mfechas "+;
*!*		" &mbuscoTM &mbuscoG ", "mwkconsumos")

*!*	mret = sqlexec(mcon1, "SELECT StockMovim.cantidad,StockMovim.codigo,"+;
*!*		"StockMovim.codmov,StockMovim.fecha,StockMovim.nromov "+;
*!*		" FROM StockMovim " +;	
*!*		" where fecha >=?mfecdes and  fecha <=?mfechas "+;
*!*		" &mbuscoTM &mbuscoG ", "mwkconsumos")

if mret < 0
	=aerr(eros)
	messagebox(eros(3),16,"Validacion")
endif
mret = sqlexec(mcon1, "SELECT DepDestino,DepOrigen,FecCarga,codmov,fecha,"+;
	"nromov,Signo "+;
	" FROM StockMovimCabe " +;
	" left join DEPOSITOCOMPRO on (DEPOSITOCOMPRO.TipoComp = StockMovimCabe.codmov and DEPOSITOCOMPRO.codigo = 1 ) " +;
	" where fecha >=?mfecdes and  fecha <=?mfechas and (DepDestino= 1 or DepOrigen = 1) "+;
	" &mbuscodep  &mbuscoTM ", "mwkcabmov")
*DepDestino = ?mdep or
&& and DepOrigen = 1

if mret < 0
	=aerr(eros)
	messagebox(eros(3),16,"Validacion")
endif
corden = iif( nopclista = 1,'INS_descriinsumo','DepDestino')
corderby = iif( nopclista = 1,'codigo','DepDestino')

select distinct * from mwkcabmov into cursor mwkcabmovdep

select mwkconsumos.*,signo,nvl(depori.descripcion,space(50)) as depdescO,;
	depdes.descripcion as depdescD ,DepDestino,DepOrigen ;
	,mwkgrupoatc.descripcion as descripcion, depori.descripcion as depdesOri;
	from mwkconsumos ;
	left join mwkgrupoatc on mwkgrupoatc.grupo = mwkconsumos.codigoatc ;
	left join mwkcabmovdep on (mwkcabmovdep .codmov = mwkconsumos.codmov;
	and mwkcabmovdep .nromov = mwkconsumos.nromov;
	and mwkcabmovdep .fecha = mwkconsumos.fecha );
	left join mwksectores as depdes on DepDestino= depdes.codigo;
	left join mwksectores as depori on DepOrigen = depori.codigo;
	order by &corden ,mwkconsumos.fecha ;
	into cursor mwkmovim


** codmov = tipo de comprobante. (tipo de vale)
** nromov = nro. de comprobante. (nro de vale)
** depdestino = sector
select * from mwkmovim;
	group by codmov, nromov,DepDestino, fecha, codigo,signo where signo in('+','-')  ;
	into cursor mwkmovimt

** Marcelo Torres, 07/03/2017
** Mostramos Tipo de Comprobante (codmov)
*!*	select * from mwkmovim;
*!*		group by nromov,DepDestino, fecha, codigo,signo where signo in('+','-')  ;
*!*		into cursor mwkmovimt2
	
select *,sum(iif(signo="+",cantidad,0)) as totent,sum(iif(signo="-",cantidad,0)) as totsal ;
	from mwkmovimt;
	group by codigo ;
	order by totsal desc,totent desc , codigo  ;
	into cursor mwkmovinP

** Agrupado por sector
select *,sum(iif(signo="+",cantidad,0)) as totent,sum(iif(signo="-",cantidad,0)) as totsal ;
	from mwkmovimt;
	group by DepDestino order by DepDestino ;
	into cursor mwkmovinD

select *,sum(iif(signo="+",cantidad,0)) as totent,sum(iif(signo="-",cantidad,0)) as totsal ;
	from mwkmovimt;
	group by codigo,DepDestino ;
	order by &corderby, totsal desc,totent desc ;
	into cursor mwkmovinPD

** Marcelo Torres, 07/03/2017
** Filtramos para mostrar agrupado por nro. de comprobante.
select *,sum(iif(signo="+",cantidad,0)) as totent,sum(iif(signo="-",cantidad,0)) as totsal ;
	from mwkmovimt;
	group by codmov,codigo,DepDestino ;
	order by &corderby, totsal desc,totent desc ;
	into cursor mwkmovinPD2


