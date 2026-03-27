***
*** Generacion de etiquetas
***
parameter mfecturno
mfechaini = dtot(ctod("01/01/1900"))
if type('mbusco')#"C"
	mbusco = ""
endif
if !used('mwkphorario1')
	do sp_busco_phortur with mfecturno,mbusco
endif

select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
	reg_telefonos, mwkphorario1.usuario, fechatomado, fechatur, nombre, afi_nroafiliado, ;
	reg_numdocumento, horatur, '*' + str(mwkphorario1.diasem,1) + strtran(str(mwkphorario1.codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + '*' as codbarra, afiliado, ;
	mwkphorario1.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, esp_descripcion, ;
	hdesde1, mwkphorario1.codmed ;
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
	where !isnull(reg_nombrepac) ;
	order by fechatur, horatur, afi_nroafiliado ;
	into cursor mwkphorarios



select *,'*' + padl( alltrim( strtran( strtran( reg_nrohclinica, '/', '' ), '-', '' )) , 8, '0' ) + '*'  as hca_codbarra from mwkphorarios ;
	group by nombre, afiliado into cursor turnos

select * from turnos where 1=2 into cursor mwketimed
use dbf('mwketimed') again in 0 alias medicos

select medicos

append from dbf('turnos')


wait windows ("Generando Códigos de Barra") nowait

select * from turnos group by afiliado into cursor afilia

select afilia
scan
	mnregistrac = afilia.afiliado
	mccodbarra 	= afilia.hca_codbarra
	do sp_busco_hcarchivo with mnregistrac

	if reccount('mwkhcarchivo')=0
		mret= sqlexec(mcon1," insert into TabHCArchivo " + ;
			"(hca_registrac, hca_codbarra, hca_reimprime " + ;
			", hca_estado, hca_motfalta, hca_orden,hca_fechaInic) values " + ;
			"( ?mnregistrac, ?mccodbarra , 0, 0, 0 ,0, ?mfechaini) " )
	else
		morden = mwkhcarchivo.hca_orden
		mret= sqlexec(mcon1," update TabHCArchivo " + ;
			" set hca_reimprime = 0, hca_orden = 0 " + ;
			" where hca_registrac = ?mnregistrac" )
*		if mwkhcarchivo.id < 280716 OR  mwkhcarchivo.id> 280830
*		if mwkhcarchivo.id < 281053
		if morden # 9999
			delete from medicos where afiliado = mnregistrac
		endif

	endif

endscan

select codmed,nombre,nombre as reg_nombrepac,mfecturno as fechatur ;
	from medicos group by codmed,reg_nombrepac into cursor tottur

select codmed,nombre,nvl(reg_nombrepac,"sin nombre") as reg_nombrepac ,fechatur from tottur  group by codmed into cursor tottur

select medicos
append from dbf('tottur')
