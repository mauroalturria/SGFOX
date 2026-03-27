***
*** Busco otros Turnos para el mismo paciente
***
parameters mnroregistrac, mfecturno,mbuscamas,mbuscamasmas
if type('mbuscamas')#"N"
	mbuscamas = 0
endif
cbusca = "( fechatur = ?mfecturno "
if type('mbuscamasmas')#"N"
	mbuscamasmas = 0
endif
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

if dow(mfecturno) = 7
	mfectur_lun = mfecturno + 2
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_lun",'MWKFeriados')
	if reccount('MWKFeriados')>0
		mfectur_lun = mfecturno + 3
	endif
	if used('MWKFeriados')
		use in 	mwkferiados
	endif
	cbusca = cbusca + " or fechatur = ?mfectur_lun "
endif
if mbuscamas = 1
	iso = 0
	do while .t.
		iso = iso + 1
		mfectur_mas = iif (dow(mfecturno) = 7,mfectur_lun,mfecturno) + iso
		if dow(mfectur_mas) = 1
			loop
		endif
		mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_mas",'MWKFeriados')
		if reccount('MWKFeriados')>0 
			use in 	mwkferiados
			loop
		else
			exit
		endif
	enddo
	cbusca = cbusca + " or fechatur = ?mfectur_mas "
endif
if mbuscamasmas = 1
	iso = 0
	do while .t.
		iso = iso + 1
		mfectur_mm = mfectur_mas + iso
		if dow(mfectur_mm) = 1
			loop
		endif
		mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_mm ",'MWKFeriados')
		if reccount('MWKFeriados')>0
			use in 	mwkferiados
			loop
		else
			exit
		endif
	enddo
	cbusca = cbusca + " or fechatur = ?mfectur_mm "
endif
cbusca = cbusca +" ) "

mret = sqlexec(mcon1, "select afiliado, horatur, codmed, codesp,CODprest " + ;
	" from turnos "+;
	"where afiliado = ?mnroregistrac and "+;
	"codesp not in("+mfiltraesp +" 'CLIN','DERI','DERM','CARD','CARI','PEDI','CIRG', 'TRAU','NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', "+;
	"'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') and " + ;
	" codprest not in (78010600,78010601,67010201,22020300) and "+;
	"(not (codprest like '28010%') or codprest = 28010602 ) and " + ;
	" not (codprest like '20012%') and codserv <> 1130 and " +cbusca + ;
	"order by horatur " , "mwkotrostur")
**confirmado =0 and
if mret<1
	=aerr(eros)
	messagebox(eros(2))

endif
	select * from mwkotrostur;
		where  codesp in ('AUDI', 'OTOR', 'INVE') ;
		into cursor mwkotrostur
