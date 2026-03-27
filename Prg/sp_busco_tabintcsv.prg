parameters tnOpcion, tcWhere, tcCursor,tccurres,tcjoin

if vartype(tcWhere) # "C"
	tcWhere = ''
endif
if vartype(tcjoin) # "C"
	tcjoin = ''
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntCSV'
endif

if vartype(tccurres) # "C"
	tccurres= 'mwkIntCSVres'
endif

do case
	case tnOpcion = 1
		lcSql = "SELECT TabIntcsv.*,idusuario FROM TabIntcsv "+tcjoin+;
			" inner join tabusuario on TabIntcsv.ESV_usuario = tabusuario.id "+ tcWhere

	case tnOpcion = 2
		lcSql = "SELECT top 10 TabIntcsv.*,idusuario FROM TabIntcsv "+tcjoin+;
			" inner join tabusuario on TabIntcsv.ESV_usuario = tabusuario.id "+ tcWhere+"  order by TabIntcsv.id desc "
	otherwise

endcase
if !Prg_EjecutoSql(lcSql,"mwkIntCSVaux",.f.)
	return .f.
endif
lpeso = .t.
laltura = .t.
use in select(tcCursor)
create cursor &tcCursor (hora n(4),determinacion c(50),valor n(10,1),usuario c(20),fechora t,linea n(2))
use in select(tccurres)
create cursor &tccurres(determinacion c(50),h08 n (4,1),h09 n (4,1),h10 n (4,1),h11 n (4,1),h12 n (4,1);
	,h13 n (4,1),h14 n (4,1),h15 n (4,1),h16 n (4,1),h17 n (4,1),h18 n (4,1),h19 n (4,1),h20 n (4,1),h21 n (4,1);
	,h22 n (4,1),h23  n (4,1),h00 n (4,1),h01 n (4,1),h02 n (4,1),h03 n (4,1);
	,h04 n (4,1),h05 n (4,1),h06 n (4,1),h07 n (4,1))

select mwkIntCSVaux
scan
	miusu = idusuario
	mfhreg = ESV_fechaH
	if ESV_parFreCard #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"FRECUENCIA CARDIACA",mwkIntCSVaux.ESV_parFreCard ,miusu,mfhreg,1)
	endif
	if ESV_parFreResp #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"FRECUENCIA RESPIRATORIA",mwkIntCSVaux.ESV_parFreResp ,miusu,mfhreg,2)
	endif
	if ESV_parGluc #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"GLUCEMIA",mwkIntCSVaux.ESV_parGluc ,miusu,mfhreg,3)
	endif
	if nvl(ESV_parGlucCorr,0)  #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"GLUCEMIA CORRECCION",mwkIntCSVaux.ESV_parGlucCorr  ,miusu,mfhreg,3)
	endif

	if ESV_parPeso #0
		if lpeso
			insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"PESO",mwkIntCSVaux.ESV_parPeso ,miusu,mfhreg,4)
			lpeso = .f.
		else
			update &tcCursor set hora = mwkIntCSVaux.ESV_hora ,valor =mwkIntCSVaux.ESV_parPeso,usuario = miusu, fechora = mfhreg;
				where linea = 4
		endif
	endif
	if ESV_paraltura #0
		if laltura
			insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"ALTURA",mwkIntCSVaux.ESV_paraltura ,miusu,mfhreg,5)
			laltura = .f.
		else
			update &tcCursor set hora = mwkIntCSVaux.ESV_hora ,valor =mwkIntCSVaux.ESV_paraltura,usuario = miusu, fechora = mfhreg;
				where linea = 5
		endif
	endif
	if ESV_parSatur #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"SATURACION O2",mwkIntCSVaux.ESV_parSatur ,miusu,mfhreg,6)
	endif
	if ESV_parTemAxl #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"TEMPERATURA AXILAR",mwkIntCSVaux.ESV_parTemAxl ,miusu,mfhreg,7)
	endif
	if ESV_parTemBuc #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"TEMPERATURA BUCAL",mwkIntCSVaux.ESV_parTemBuc ,miusu,mfhreg,8)
	endif
	if ESV_parTemRct #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"TEMPERATURA RECTAL",mwkIntCSVaux.ESV_parTemRct ,miusu,mfhreg,9)
	endif
	if ESV_parTensDia #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"TENSION DIASTOLICA ",mwkIntCSVaux.ESV_parTensDia ,miusu,mfhreg,10)
	endif
	if ESV_parTensSis #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"TENSION SISTOLICA ",mwkIntCSVaux.ESV_parTensSis ,miusu,mfhreg,11)
	endif
	if ESV_parTensAM #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"TENSION ARTERIAL MEDIA ",mwkIntCSVaux.ESV_parTensAM ,miusu,mfhreg,12)
	endif
	if ESV_parpic #0
		insert into &tcCursor values(mwkIntCSVaux.ESV_hora ,"PIC ",mwkIntCSVaux.ESV_parpic ,miusu,mfhreg,13)
	endif
endscan

feclim = sp_busco_fecha_serv("DT")-(24*3600-15*60)
select * from &tcCursor where fechora >= feclim order by determinacion into cursor mwkIntCSVaux
select mwkIntCSVaux
do while !eof()
	midet = determinacion
	select &tccurres
	locate for determinacion = midet
	if !found()
		insert into &tccurres (determinacion ) values (midet )
	endif
	do while !eof() and midet = determinacion
		mhora = hour(mwkIntCSVaux.fechora)
		mivalor = mwkIntCSVaux.valor
		mcpo = "h"+transform(mhora,"@L 99")
		select &tccurres
		replace &mcpo with mivalor
		select mwkIntCSVaux
		skip
	enddo
enddo
use in select('mwkIntCSVaux')
