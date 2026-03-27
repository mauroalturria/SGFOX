****
** actualizo codigos de facturacion
****
lparameters mfecreal
mfhora = sp_busco_fecha_serv('DT')
horalimite = ctot(dtoc(ttod(mfhora) )+" 11:00:00")
mhora = hour(mfhora)*100 + minute(mfhora)
mret = sqlexec(mcon1, "select TNP_codadmision,TNP_CodServ from TabNutPaciente,pacinternad " + ;
	" where TNP_codadmision = pin_codadmision and TNP_Fecha = ?mfecreal and TNP_CodServ in (1,2)", "mwknutcomi")
select habitac,pac_nombrepaciente, pac_descripdiagn, anios;
	,pacfechaadmision,tnp_observaciones as indicacion ;
	,iif(mhora<1300 and isnull(pac_fechaalta);
	and !(mhora>1100 and mhora<1300 and ctot(pacfechaadmision) <= horalimite) ;
	,TNP_CodFact,TNP_Observaciones) as TNP_Observaciones1 ;
	,iif(mhora<1300 and isnull(pac_fechaalta),limpia(TNP_CodFact,horalimite,1),'') as TNP_CodFact1;
	,iif(isnull(pac_fechaalta),TNP_CodFact,TNP_Observaciones) as TNP_Observaciones2 ;
	,iif(isnull(pac_fechaalta),limpia(TNP_CodFact,horalimite,2),'') as TNP_CodFact2;
	,tnd_observa as observaciones;
	,pac_codadmision ,0 as lcambio ,pac_fechaalta;
	from mwkdieta ;
	where PAC_codadmision not in ( select TNP_codadmision from mwknutcomi);
	into cursor mwkactualiza
	
if reccount ('mwkactualiza')>0
	do sp_actualizo_tab_nut with 1,mfecreal
endif

function limpia(codf,horalimite,ts)
	local mm,ncf,mpos,mcodf
	ncf = ''
	mcodf = codf
	do while !empty(mcodf) and vartype(prestafac)#"U"
		mpos = at(' ',mcodf)
		mm = iif(mpos>0,alltrim(left(mcodf,mpos)),alltrim(mcodf))
		if ascan(prestafac,mm)>0
			ncf = ncf + mm + ' '
		endif
		mcodf = iif(mpos>0, alltrim(substr(mcodf,mpos)) , '' )
	enddo
	if vartype(pacfechaadmision)="D"
		if mhora>1100 and ctot(pacfechaadmision) <= horalimite and ts = 1
			ncf = ''
		endif
	else
		ncf = ''
	endif
	return padr(ncf,50)
endfunc

