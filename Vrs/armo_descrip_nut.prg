****
** Busca nuevos vales de Nutricion
****
dimension cf(100)
store '' to cf

mfechabaja = sp_busco_fecha_srv2('DT')
mfechahoy  = ttod(mfechabaja)
mfechanull = ctot("01/01/1900")
mtiposer = 9
mret =	sqlexec(mcon1,"select TNP_codPrest,TNP_codfactu,TNP_factura,TNP_Dieta "+;
	" from TabNutPrest " , "mwkTNprest")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

mret =sqlexec(mcon1,"select * from TabNutPaciente "+;
	"where TNP_Fecha = ?mfechahoy "+;
	" and TNP_CodServ = ?mtiposer","mwkexistepac")
if reccount("mwkexistepac")>0
	select mwkexistepac
	do while !eof('mwkexistepac')
		mcodadm = alltrim(mwkexistepac.tnp_codadmision)
		mbusca= " and pac_codadmision = '" + mcodadm + "' "
		do sp_busco_dieta with mfechahoy, mtiposer, mbusca
		select mwknutdieta.*,pre_descriprest ;
			from mwknutdieta left join mwkpres on pre_codprest = tnd_codprest ;
			into cursor mwknutdieta1
		select mwknutdieta1
		midpac = mwknutdieta1.TND_idPaciente
		cmpres 	= ''
		mcodfac = ''
		ind_cf 	= 0
		store '' to cf
		do while !eof('mwknutdieta1')
			mcodfac = alltrim(mwknutdieta1.TNP_CodFactu)
			if !empty(mcodfac) and ascan(cf,mcodfac) = 0
				ind_Cf 		= ind_Cf +1
				cf(ind_cf)	= mcodfac
			endif
			descriprest = nvl( mwknutdieta1.pre_descriprest, '' )
			cmpres = cmpres + iif(!empty(cmpres ),"+",'') +;
				Iif(!empty( descriprest), Proper(Iif(At("DIETA",descriprest)=1;
				,Alltrim(Strtran(descriprest,"DIETA ",""));
				,Alltrim(descriprest)));
				,'')
			Skip 1 in mwknutdieta1
		enddo
		mcf = ''
		if ind_Cf>0
			for ind = 1 to ind_cf
				mcf= mcf + alltrim(cf(ind))+" "
			next
		endif
		do sp_actualizo_tab_nut_pac with 2,mcodadm,mtiposer,cmpres,mcf,midpac
		select mwkexistepac
		skip 1 in mwkexistepac
	enddo
endif
set step on
select * from tab_nut where tnd_fecbaja = ctot("01/01/1900") into cursor activo
update tab_nut set tnd_fecbaja = ctot("01/01/1900")  where tnd_nrovale in (select tnd_nrovale from activo)
MODIFY COMMAND c:\desaguemes\vrs\armo_descrip_nut.prg
do sp_conexion
DO c:\desaguemes\vrs\armo_descrip_nut.prg
select * from tab_nut where tnd_fecbaja = ctot("01/01/1900") into cursor activo
select * from tab_nut where  tnd_fecbaja > ctot("01/01/1900") and tnd_nrovale in (select tnd_nrovale from activo)
select * from tab_nut_arr where tnd_fecbaja = ctot("01/01/1900") into cursor activo
select * from tab_nut_arr where  tnd_fecbaja > ctot("01/01/1900") and tnd_nrovale in (select tnd_nrovale from activo)
