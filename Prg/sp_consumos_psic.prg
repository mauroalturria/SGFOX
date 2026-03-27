parameters mfecha1, mfecha2,mcode 
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where id<100000  order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_tomados1'
	cancel
endif
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient from entidades " + ;
	"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")
select * from mwkentidad where at("HOMINIS",ENT_descrient )>0 into cursor mwkent
mcadPS = ' (codent'
select mwkent
scan
	mcadPS = mcadPS + ","+ transf(ENT_codent,"9999")
endscan
mcadPS = mcadPS + ")"

go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

wait 'Procesando datos .................' windows timeout 5

if mfecha1 > mfechalimite
	mret=sqlexec(mcon1, " SELECT codprest,pre_descriprest as prest, "+;
		"codent,confirmado,Afiliado,turnos.codesp,codmed,nombre "+;
		" FROM turnos,prestacions,prestadores "+;
		" WHERE turnos.codprest = prestacions.pre_codprest and codmed = prestadores.id "+;
		" and fechatur between ?mfecha1 AND ?mfecha2 AND turnos.Codesp=?mcode ","mwkturnos")
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE CONSUMOS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif

	SELECT codprest,prest ;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO;
		FROM mwkturnos ;
		GROUP BY codprest ;
		ORDER BY codprest into cursor MWKConsumo

	SELECT codprest,prest,nombre ;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO,codmed;
		FROM mwkturnos ;
		GROUP BY codmed,codprest ;
		ORDER BY nombre,codprest into cursor MWKConsumomed0


	SELECT  'TOTAL' as codprest,codesp;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO;
		FROM mwkturnos into cursor MWKToTCons

	SELECT  'TOTAL' as codprest,nombre,codesp;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO;
		GROUP BY codmed ORDER BY nombre ;
		FROM mwkturnos into cursor MWKToTConsmed

	SELECT  count(afiliado) as TotalPLanS ;
		FROM mwkturnos ;
		where inlist &mcadPS ;
		into cursor MWKToTPS

	SELECT  distinct afiliado,codmed ;
		FROM mwkturnos ;
		into cursor MWKafi

	SELECT  count(afiliado) as seres ,codmed ;
		FROM MWKafi group by codmed ;
		into cursor MWKafitot

	select MWKConsumomed0.*,seres ;
		from MWKConsumomed0,MWKafitot where MWKConsumomed0.codmed = MWKafitot.codmed ;
		into cursor MWKConsumomed

	SELECT  COUNT(afiliado) as TotalPLanS ;
		FROM mwkturnos ;
		where !inlist &mcadPS ;
		into cursor MWKToTOS

	SELECT  COUNT(afiliado) as TotalPsic ;
		FROM mwkturnos ;
		into cursor MWKToTGral

	SELECT  COUNT(afiliado) as PacPLanS ;
		FROM mwkturnos ;
		where inlist &mcadPS;
		group by afiliado;
		into cursor MWKToPPS

	SELECT  COUNT(afiliado) as PacOS ;
		FROM mwkturnos ;
		where !inlist &mcadPS;
		group by afiliado;
		into cursor MWKToPOS

else
	mret=sqlexec(mcon1, " SELECT codprest,pre_descriprest as prest, "+;
		"codent,confirmado,Afiliado,turnos.codesp,codmed,nombre "+;
		" FROM turnoshis as turnos,prestacions,prestadores "+;
		" WHERE turnos.codprest = prestacions.pre_codprest and codmed = prestadores.id "+;
		" and fechatur between ?mfecha1 AND ?mfecha2 AND turnos.Codesp= ?mcode ","mwkturnos")

	SELECT codprest,prest ;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO;
		FROM mwkturnos ;
		GROUP BY codprest ;
		ORDER BY codprest into cursor MWKConsumo

	SELECT codprest,prest,nombre ;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO,codmed;
		FROM mwkturnos ;
		GROUP BY codmed,codprest ;
		ORDER BY nombre,codprest into cursor MWKConsumomed0


	SELECT  'TOTAL' as codprest,codesp;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO;
		FROM mwkturnos into cursor MWKToTCons

	SELECT  'TOTAL' as codprest,nombre,codesp;
		,sum(iif( inlist &mcadPS and confirmado=1, 1, 0)) as PresentesP;
		,sum(iif( inlist &mcadPS and confirmado=0, 1, 0)) as AusentesP;
		,sum(iif( !inlist &mcadPS and confirmado=1, 1, 0)) as PresentesO;
		,sum(iif( !inlist &mcadPS and confirmado=0, 1, 0)) as AusentesO;
		GROUP BY codmed ORDER BY nombre ;
		FROM mwkturnos into cursor MWKToTConsmed

	SELECT  count(afiliado) as TotalPLanS ;
		FROM mwkturnos ;
		where inlist &mcadPS ;
		into cursor MWKToTPS

	SELECT  distinct afiliado,codmed ;
		FROM mwkturnos ;
		into cursor MWKafi

	SELECT  count(afiliado) as seres ,codmed ;
		FROM MWKafi group by codmed ;
		into cursor MWKafitot

	select MWKConsumomed0.*,seres ;
		from MWKConsumomed0,MWKafitot where MWKConsumomed0.codmed = MWKafitot.codmed ;
		into cursor MWKConsumomed

	SELECT  COUNT(afiliado) as TotalPLanS ;
		FROM mwkturnos ;
		where !inlist &mcadPS ;
		into cursor MWKToTOS

	SELECT  COUNT(afiliado) as TotalPsic ;
		FROM mwkturnos ;
		into cursor MWKToTGral

	SELECT  COUNT(afiliado) as PacPLanS ;
		FROM mwkturnos ;
		where inlist &mcadPS;
		group by afiliado;
		into cursor MWKToPPS

	SELECT  COUNT(afiliado) as PacOS ;
		FROM mwkturnos ;
		where !inlist &mcadPS;
		group by afiliado;
		into cursor MWKToPOS
endif
a= 1
