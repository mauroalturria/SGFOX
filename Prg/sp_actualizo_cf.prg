****
** actualizo codigos de facturacion
****
lparameters mfecreal
if mwkusuario.codigovax = 54035
*set step on
ENDIF
mfhora = sp_busco_fecha_serv('DT')
horalimite = ctot(dtoc(ttod(mfhora) )+" 11:00:00")
mhora = hour(mfhora)*100 + minute(mfhora)
select habitac,pac_nombrepaciente, hanam,pac_descripdiagn, anios;
	,pac_fechaadmision, ent_descrient;
	,indicacion ;
	,iif(empty(TNP_Observaciones1) and mhora<1300 and isnull(pac_fechaalta);
	and !(mhora>1100 and mhora<1300 and ctot(pac_fechaadmision) <= horalimite) ;
	,TNP_CodFact1,TNP_Observaciones1) as TNP_Observaciones1 ;
	,iif(mhora<1300 and isnull(pac_fechaalta),limpia(TNP_CodFact1,horalimite,1),'') as TNP_CodFact1;
	,iif(empty(TNP_Observaciones2) and isnull(pac_fechaalta),TNP_CodFact2,TNP_Observaciones2) as TNP_Observaciones2 ;
	,iif(isnull(pac_fechaalta),limpia(TNP_CodFact2,horalimite,2),'') as TNP_CodFact2;
	,observaciones;
	,afi_codentidad, pac_codadmision ,0 as lcambio ,pac_fechaalta;
	from mwkpndieta1 into cursor mwkactualiza
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
	if vartype(pac_fechaadmision)="D"
		if mhora>1100 and ctot(pac_fechaadmision) <= horalimite and ts = 1
			ncf = ''
		endif
	else
		ncf = ''
	endif
	return padr(ncf,50)
endfunc

