****
** inserto datos de alta transitoria
****
parameter mafi  , mcodent,mnumdoc,mnombre,mreg,pasa,cartel

if used ('vales')
	use in vales
endif
create cursor vales ;
	(paciente  c(50),cuenta c(10))

lseomite = .f.
msql_reg	= ''
msql_pac = ''
msql_cons = ''

mnroreg 	= mreg
mbusco1 	= "pac_codhci = ?mnroreg and "
mfecdes 	= ctod('01/01/1900')
mfechas 	= sp_busco_fecha_serv('DD')
mtfhoy = mfechas
do sp_busco_consumos_paciente_new with mnroreg, msql_cons ,1

&msql_cons
msql_reg	= ''
msql_con	= ''
msql_ent	= ''
select * from mwkconsu group by val_codadmision into cursor mwkconsu
select mwkconsu
mhasta = reccount('mwkconsu')
go top
	mpac 			= mnombre
scan
	mtipopac = iif(mwkconsu.val_tipopaciente='AMB',mwkconsu.val_tipopaciente,mwkconsu.pac_sectorinternac)
	if  mtipopac = "GUA" or mtipopac = "AMB"
		mcodadmision = mwkconsu.val_codadmision
		lctaamb = .f.
		a = 1
		for i = 1 to 6
			if isalpha(substr(alltrim(mcodadmision),i,1))
				lctaamb = .t.
				exit
			endif
		next
		if lctaamb
			mret = sqlexec(mcon1, "select pac_nombrepaciente from pacientes " + ;
				"where   pac_codadmision = ?mcodadmision " ,"mwkpacconsu")
			mpac = chrtran(pac_nombrepaciente,",.","  ")
			insert into vales (paciente ,cuenta) values (mpac,mcodadmision )
		endif
	endif
	select mwkconsu
endscan

select distinct paciente  from vales into cursor valespac

if reccount("valespac")>1
	pasa = 1000
select valespac
scan
	cartel=cartel+alltrim(paciente)+"?"
endscan
endif
