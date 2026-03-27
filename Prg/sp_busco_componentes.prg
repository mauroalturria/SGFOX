****
** Busco componentes
****
lparameters mid
						
mret = sqlexec(mcon1, "SELECT tabprmod.*,descripcion,detalle from tabprmod "+;
		"left join tabpmodulos on tabprmod .codmodulo = tabpmodulos.id "+ ;
		"where mtipo=1 and mcodigo= ?mid ", "mwkprmod")
mret = sqlexec(mcon1, "SELECT tabprprest.* from tabprprest "+;
		"where ptipo=1 and pcodigo= ?mid ", "mwkprpre")
mret = sqlexec(mcon1, "SELECT tabprconce.* from tabprconce "+;
		"left join tabpconce on codmodulo = tabpconce.id "+ ; 	
		"where ctipo=1 and ccodigo= ?mid ", "mwkprcon")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif

select * from mwkprpre left join mwkprestpres on codprest =  pre_codprest into cursor mwkprprepres

if used('componentes')
	use in componentes
endif

create cursor componentes ;
	(md n(1), pr n(1), inc n(1), exc n(1), valor n(15,2),descrip c(100), detalle M , codigo n(15),orden n (4))

select mwkprmod
scan
	mmd = 1
	mpr = 0
	minc = 0
	mexc = 0
	mvalor = mwkprmod.mvalor
	mdesc = mwkprmod.descripcion
	mdeta = mwkprmod.detalle
	morden = mwkprmod.orden
	mcod = mwkprmod.codmodulo
	insert into componentes (md, pr, inc, exc, valor, descrip, detalle;
		, codigo, orden);
		values (mmd, mpr, minc, mexc, mvalor, mdesc, mdeta;
		, mcod, morden)
endscan

select mwkprpre
scan
	mmd = 0
	mpr = 1
	minc = 0
	mexc = 0
	mvalor = mwkprpre.pvalor
	mdesc = mwkprpre.pre_descriprest
	mdeta = mwkprpre.pdetalle
	morden = mwkprpre.orden
	mcod = mwkprpre.codprest
	insert into componentes (md, pr, inc, exc, valor, descrip, detalle;
		, codigo, orden);
		values (mmd, mpr, minc, mexc, mvalor, mdesc, mdeta;
		, mcod, morden)
endscan

select mwkprcon
scan
	mmd = 0
	mpr = 0
	minc = iif( mwkprcon.incexcl= 0,1,0) 
	mexc = iif( mwkprcon.incexcl= 1,1,0) 
	mvalor = 0
	mdesc = left(mwkprcon.concepto,100)
	mdeta = mwkprcon.concepto
	morden = mwkprcon.orden
	mcod = mwkprcon.codconce
	insert into componentes (md, pr, inc, exc, valor, descrip, detalle;
		, codigo, orden);
		values (mmd, mpr, minc, mexc, mvalor, mdesc, mdeta;
		, mcod, morden)
endscan