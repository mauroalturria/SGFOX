*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mfecturno

*!*	mfecturno = ctod("01/08/2009")

mbusco = ""
if !used('mwkphorario1')
	do sp_busco_phorTur with mfecturno,mbusco
endif
mret=sqlexec(mcon1,"SELECT * FROM TabHCUbica ",'MWKubica')

select left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
	pre_descriprest, left(REG_nrohclinica, 10) as REG_nrohclinica, ;
	fechatur, mwkpmed.nombre, AFI_nroafiliado, horatur, ;
	ESP_descripcion, mwkphorario1.codmed,mwkphorario1.codesp,mwkphorario1.codprest, ;
	Sala,abrevio;
	from mwkphorario1 ;
	left join mwkpesp on codesp = ESP_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = PRE_codprest ;
	left join MWKubica on codubi = hca_motfalta ;
	left join MwkMpFecha on MwkMpFecha.codprest = mwkphorario1.codprest and ;
		MwkMpFecha.codmed = mwkphorario1.codmed and ;
		MwkMpFecha.diasem = mwkphorario1.diasem and ;
		MwkMpFecha.fecvigend <= mwkphorario1.fechatur and ;
		MwkMpFecha.fecvigenh > mwkphorario1.fechatur and ;
		MwkMpFecha.hhmmdes <= mwkphorario1.hhmmtur and ;
		MwkMpFecha.hhmmhas > mwkphorario1.hhmmtur ;
	into cursor mwkphorario3

&& genero los traslados

*** registrados
select distinc REG_nrohclinica, codmed ;
	from mwkphorario3 where abrevio#"HCE" ;
	into cursor mwkturnospac

select REG_nrohclinica, count(REG_nrohclinica) as canttur ;
	from mwkturnospac;
	group by REG_nrohclinica ;
	order by REG_nrohclinica;
	into cursor mwkcantur

if used('mwkturnospac')
	use in mwkturnospac
endif

select * ;
	from mwkphorario3 ;
	where mwkphorario3.REG_nrohclinica in ;
		(select REG_nrohclinica from mwkcantur ;
		where canttur > 1 and mwkcantur.REG_nrohclinica = mwkphorario3.REG_nrohclinica) ;
	order by REG_nrohclinica, horatur ;
	into cursor mwktrasla

if used('mwkcantur')
	use in mwkcantur
endif
if used('mwkphorario3')
	use in mwkphorario3
endif

create cursor traslado (hcm_fechatur t, hcm_fechaturd t;
	, REG_nombrepac c(40), REG_nrohclinica c(10);
	, hcm_descMed c(40), tipo c (3), hcm_descEsp c(30);
	, hcm_descmedd c(40), tipod c (3), hcm_descespd c(30), Dife n(20), lugar c(20), lugard c(20))


select mwktrasla
mhorao 	= horatur
mmedo	= nombre
mespo 	= ESP_descripcion
mnrohc	= REG_nrohclinica
mpac 	= REG_nombrepac
msala   = sala

if !eof()
	skip
endif
do while !eof()
	if mnrohc	= REG_nrohclinica
		mhorad 	= horatur
		mmedd	= nombre
		mespd 	= ESP_descripcion
		msalad  = sala
		
		insert into traslado (hcm_fechatur, hcm_fechaturd, REG_nombrepac, REG_nrohclinica;
			, hcm_descmed, tipo, hcm_descesp;
			, hcm_descmedd, tipod, hcm_descespd, Dife, lugar, lugard) values ;
			( mhorao, mhorad, mpac, mnrohc, mmedo, '',mespo, mmedd, '', mespd, ;
			mhorad - mhorao, msala,msalad )
		mhorao 	= mhorad
		mmedo	= mmedd
		mespo 	= mespd
		msala   = msalad
		skip
		loop
	else
		mhorao 	= horatur
		mmedo	= nombre
		mespo 	= ESP_descripcion
		mnrohc	= REG_nrohclinica
		mpac 	= REG_nombrepac
		msala   = sala

		skip
		loop
	endif
enddo

