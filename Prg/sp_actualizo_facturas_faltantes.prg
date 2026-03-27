****
** grabo los movimientos por facturas y n. credito
****
lparameters mcodpun,mformapg 
if type('mcodpun')#"N"
	mcodpun= 0
endif

if type('mformapg')#"N"
	mformapg = 0
endif
mnroval	= round(val(dat_fac(1)), 0)
mtpocte = iif(dat_fac(2) = 'FC', 1, iif(dat_fac(2) = 'ND', 2, iif(dat_fac(2) = 'CC', 4,iif(dat_fac(2) = 'DC', 7, 5))))
mletra	= dat_fac(3)
mptovta = round(val(dat_fac(4)), 0)
mnrocte = round(val(dat_fac(5)), 0)
mfecha  = dat_fac(6)
mimpor	= val(dat_fac(9))
mfechor = dat_fac(17)
mcodent	= round(val(dat_fac(16)), 0)
mnroreg = round(val(dat_fac(15)), 0)
 
if !used('mwkptosorigen')
	mret = sqlexec(mcon1,"select Descripcion, FechaAlta, PuntodeVenta " + ;
		" from Puntosdeventa ", "mwkptos")
	select *,iif(at('Ambulatorio',Descripcion)>0,"AMB",iif(at('Guardia',Descripcion)>0,"GUA","INT")) as origen ;
		from mwkptos into cursor mwkptosorigen
endif

select mwkptosorigen
locate for PuntodeVenta = val(dat_fac(4))
if found()
	mtpopac = mwkptosorigen.origen
else
	mtpopac = iif(inlist(dat_fac(4), '0001','0016','1001','0020'), 'AMB', iif(inlist(dat_fac(4), '0002','0017','1002','0020','0021','0022'), 'GUA', 'INT'))
endif
mcodvaxt = round(val(dat_fac(12)), 0)
mnroadm = dat_fac(13)
 
if mtpocte < 5
	maplipvta 	= mptovta
	mapliletra 	= mletra
	maplinrof	= mnrocte
	maplitcte	= mtpocte
else
	maplipvta 	= mptovta
	mapliletra 	= mletra
	maplinrof	= round(val(dat_fac(11)), 0)
	maplitcte	= 1
endif
If mformapg = 0
	mcfp = ''
	mvfp = ''
Else
	mcfp = ",formapago"
	mvfp =",?mformapg"
Endif
mret = sqlexec(mcon1, "insert into tabfacturas(ptovta, tpocte, letracte, nrocte, fechacte, " + ;
	"importe, codent, nroregistracio, nrovale, tpopac, apliptovta, " + ;
	"aplitpocte, apliletracte, aplinrocte, cuenta, usuario, fechahora,codpun  &mcfp) " + ;
	"values(?mptovta, ?mtpocte, ?mletra, ?mnrocte, ?mfecha, ?mimpor, " + ;
	"?mcodent, ?mnroreg, ?mnroval, ?mtpopac, ?maplipvta, ?maplitcte, " + ;
	"?mapliletra, ?maplinrof, ?mnroadm, ?mcodvaxt, ?mfechor, ?mcodpun  &mvfp)")

if mret < 0
	messagebox('NO SE ACTUALIZO TABFACTURAS, AVISAR A SISTEMAS', 16, 'Validacion')
	do prg_cancelo
endif
