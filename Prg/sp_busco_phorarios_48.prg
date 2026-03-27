***
*** Generacion de planilla de Turnos
***
parameter mfecturno,mbusco
if type('mbusco')#"C"
	mbusco = " "
endif
** Dia anterior
mfectur_ant = mfecturno - iif( dow(mfecturno) = 2, 2, 1)
do while .t.
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_ant",'MWKFeriados')
	if reccount('MWKFeriados')>0 or dow(mfectur_ant)=1
		mfectur_ant = mfectur_ant -1
	else
		exit
	endif
enddo
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

mfectur_antv = mfectur_ant
if dow(mfectur_ant) = 7
	mfectur_antv = mfectur_ant-1
	cbusca = " fechatur <= ?mfectur_ant and fechatur >= ?mfectur_antv "
else
	cbusca = " fechatur = ?mfectur_ant "
endif
if !used('mwkphorario1')
	do sp_busco_phortur with mfecturno,mbusco
endif

select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
	reg_telefonos, mwkphorario1.usuario, fechatomado, mwkphorario1.codserv, fechatur, nombre, afi_nroafiliado,afiliado, ;
	reg_numdocumento, horatur, mwkphorario1.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, ;
	esp_descripcion, ttoc(hdesde1,2) as hdesde1, iif( left( ttoc( hdesde1, 2), 2)<"12",1,2) as hdes , ;
	mwkphorario1.codmed,sala,left(sala,1) as piso,mwkphorario1.codesp,mwkphorario1.codprest,;
	hca_motfalta,nvl(hca_fechaInic,ctot("01/01/1900")) as hca_fechaInic,reg_email;
	from mwkphorario1 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkppres on codprest = pre_codprest ;
	left join mwkmpfecha on (mwkphorario1.codmed = mwkmpfecha.codmed and ;
	mwkphorario1.codprest = mwkmpfecha.codprest and ;
	mwkphorario1.fechatur >= mwkmpfecha.fecvigend and ;
	mwkphorario1.fechatur < mwkmpfecha.fecvigenh and ;
	mwkphorario1.hhmmtur >= mwkmpfecha.hhmmdes and ;
	mwkphorario1.hhmmtur<mwkmpfecha.hhmmhas and ;
	mwkphorario1.diasem = mwkmpfecha.diasem );
	order by fechatur, horatur, afi_nroafiliado into cursor mwkphorario3

select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
	reg_telefonos, mwkphorario2.usuario, fechatomado, mwkphorario2.codserv, fechatur, nombre, afi_nroafiliado,afiliado,;
	reg_numdocumento, horatur, mwkphorario2.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, ;
	esp_descripcion, ttoc(hdesde1,2) as hdesde1, iif( left( ttoc( hdesde1, 2), 2)<"12",1,2) as hdes , ;
	mwkphorario2.codmed,sala,left(sala,1) as piso,mwkphorario2.codesp,mwkphorario2.codprest, ;
	0 as hca_motfalta,ctot("01/01/1900") as hca_fechaInic,padr("NO TIENE",50) as reg_email   ;
	from mwkphorario2 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkppres on codprest = pre_codprest ;
	left join mwkmpfecha on (mwkphorario2.codmed = mwkmpfecha.codmed and ;
	mwkphorario2.codprest = mwkmpfecha.codprest and ;
	mwkphorario2.fechatur >= mwkmpfecha.fecvigend and ;
	mwkphorario2.fechatur < mwkmpfecha.fecvigenh and ;
	mwkphorario2.hhmmtur >= mwkmpfecha.hhmmdes and ;
	mwkphorario2.hhmmtur<mwkmpfecha.hhmmhas and ;
	mwkphorario2.diasem = mwkmpfecha.diasem );
	order by fechatur, horatur, afi_nroafiliado into cursor mwkphorario4

select * from mwkphorario3 ;
	union ;
	select * from mwkphorario4;
	into cursor mwkphorarios

*** busca cantidad de turnos por medico
select codmed as codigomed,count(afiliado) as cantturxmed ;
	from mwkphorarios;
	group by codigomed ;
	into cursor mwkcanturxmed

*** busca primer medico para archivo
select distinc afiliado,codmed;
	from mwkphorario3;
	into cursor mwkturnospac

select afiliado,count(afiliado) as canttur;
	from mwkturnospac;
	group by afiliado order by afiliado;
	into cursor mwkcantur

if used('mwkturnospac')
	use in mwkturnospac
endif

select afiliado,horatur,codmed,nombre as otromed  from mwkphorario3 ;
	where mwkphorario3.afiliado in ;
	( select afiliado from mwkcantur ;
	where canttur >1 and mwkcantur.afiliado = mwkphorario3.afiliado ) ;
	order by afiliado,horatur desc into cursor mwktrasla

if used('mwkcantur')
	use in mwkcantur
endif

select * from mwktrasla group by afiliado into cursor mwkprimed

if used('mwktrasla')
	use in mwktrasla
endif


select afiliado,reg_nrohclinica,hca_fechaInic from mwkphorario1 ;
	order by afiliado group by afiliado into cursor mwkphorarioar

select mwkphorario3
use
select mwkphorario4
use
****
** Agregado para Archivo
****
if dow(mfectur_ant) = 7
	mfectur_antv = mfectur_ant-1
	cbusca = " fechatur >= ?mfectur_ant and fechatur <= ?mfectur_antv "
else
	cbusca = " fechatur = ?mfectur_ant "
endif
mret = sqlexec(mcon1, 'select afiliado  ' + ;
	'from turnos ' + ;
	'where  ' + ;
	" CODprest not in (42010181,78010600,78010601,67010201,22020300) and (not (CODprest like '28010%') or CODprest = 28010602 ) and " + ;
	" not (CODprest like '20012%') and codserv <> 1130 and " + ;
	'&cbusca ' + ;
	" and codesp not in('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') " + ;
	'', 'mwkphoraant1')


select * from mwkphoraant1 group by afiliado into cursor mwkphoraant


mret=sqlexec(mcon1,"SELECT * FROM TabHCUbica ",'MWKubica')


select mwkphorarios.*,mwkphoraant.afiliado as afi,otromed,abrevio;
	from mwkphorarios ;
	left join MWKubica on codubi = hca_motfalta ;
	left join mwkcanturxmed on codigomed = mwkphorarios.codmed;
	left outer join mwkphoraant on mwkphoraant.afiliado = mwkphorarios.afiliado;
	left outer join mwkprimed on (mwkprimed.afiliado = mwkphorarios.afiliado;
	and mwkprimed.codmed # mwkphorarios.codmed );
	order by cantturxmed, mwkphorarios.codmed,hdesde1, fechatur, termina ;
	into cursor mwkphorario
