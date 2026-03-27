****
** actualizo codigos de facturacion
****
Lparameters mfecreal
mfhora = sp_busco_fecha_serv('DT')
horalimite = Ctot(Dtoc(Ttod(mfhora) )+" 11:00:00")
mhora = Hour(mfhora)*100 + Minute(mfhora)

Select habitac,pac_nombrepaciente, pac_descripdiagn, anios;
	,pac_fechaadmision, ent_descrient;
	,indicacion ;
	,TNP_CodFact1 As TNP_Observaciones1 ;
	,Iif(mhora<1300 And Isnull(pac_fechaalta),limpia(TNP_CodFact1,horalimite,1),'') As TNP_CodFact1;
	,TNP_CodFact2 As TNP_Observaciones2 ;
	,Iif(Isnull(pac_fechaalta),limpia(TNP_CodFact2,horalimite,2),'') As TNP_CodFact2;
	,observaciones;
	,afi_codentidad, pac_codadmision ,0 As lcambio ,pac_fechaalta;
	FROM mwkpndiet1 Into Cursor mwkactualiza
If Used('mwkactualiza')
	If Reccount ('mwkactualiza')>0
		Do sp_actualizo_tab_nut_coc With 1,mfecreal,1
	Endif
Endif
Function limpia(codf,horalimite,ts)
Local mm,ncf,mpos,mcodf
ncf = ''
mcodf = codf
Do While !Empty(mcodf) And Vartype(prestafac)#"U"
	mpos = At(' ',mcodf)
	mm = Iif(mpos>0,Alltrim(Left(mcodf,mpos)),Alltrim(mcodf))
	If Ascan(prestafac,mm)>0
		ncf = ncf + mm + ' '
	Endif
	mcodf = Iif(mpos>0, Alltrim(Substr(mcodf,mpos)) , '' )
Enddo
If Vartype(pac_fechaadmision)="D"
	If mhora>1100 And Ctot(pac_fechaadmision) <= horalimite And ts = 1
		ncf = ''
	Endif
Else
	ncf = ''
Endif
Return Padr(ncf,50)
Endfunc

