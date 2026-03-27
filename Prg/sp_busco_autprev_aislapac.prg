****
** busco internados aislados
****
Parameters mbusco1ac
mbusco1ac = Iif(Vartype(mbusco1ac)#"C",'',mbusco1ac)
mifecha= sp_busco_fecha_serv("DD")
mihora = sp_busco_fecha_serv("DT")
Do sp_busco_estados With 25," and tipo = 45 ","mwktipoaisla"
mret = SQLExec(mcon1, "select apv_codadmision, apv_estado , apv_fechaauditoria"+;
	", apv_horaauditoria , apv_idautprevias"+;
	", apv_descripsolic, IAP_Estado, IAP_Fechora1Control,IAP_FechoraFin, "+;
	"IAP_FechoraInicio,  IAP_TipoAisla ,GA_TipoAislamiento,GA_DiasPrimerPedido"+;
	",GA_DiasSigtePedido,IAP_TipoGermen,IAP_TipoGermen->GG_Germen "+;
	" from Zabintaislapac " + ;
	" inner join Zabgrupoaisla on Zabintaislapac.IAP_TipoAisla = Zabgrupoaisla.id " + ;
	" inner join autprevias on Zabintaislapac.IAP_IdAutprevia = autprevias.id " + ;
	" inner join pacinternad on autprevias.apv_codadmision = pacinternad.pin_codadmision " + ;
	" inner join pacientes on autprevias.apv_codadmision = pacientes.pac_codadmision " + ;
	" where  apv_presinsu = 'S' and IAP_FechoraFin>=?mihora"  + mbusco1ac+;
	" group by autprevias.id,IAP_TipoAisla,IAP_TipoGermen  ", "mwkpacaislados")
If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MWKPACINT00",48,"VALIDACION")
	Return .F.
Endif
Select  mwkpacaislados.*,Strtran(mwktipoaisla.Descrip,"AISLAMIENTO ","") As tipoaisla From mwkpacaislados,mwktipoaisla  ;
	WHERE GA_TipoAislamiento = mwktipoaisla.estado  Into Cursor mwkpacaislanew
 
Select mwkpacaislanew.*,Ctot(Dtoc(apv_fechaauditoria)+" "+Left(Ttoc(apv_horaauditoria,2),5)) As horaaud ;
	,chartipo(apv_codadmision ) As tiponaislanew,nuntipo(apv_codadmision ) As codaisla;
	,chargermen(apv_codadmision ) as germenes;
	From mwkpacaislanew;
	Group By apv_codadmision,apv_estado  Into Cursor mwkpacaisla
 

FUNCTION nuntipo(mcadmision)
Select Distinc iap_TipoAisla,apv_codadmision,apv_estado From mwkpacaislanew  WHERE apv_codadmision =mcadmision ;
	ORDER BY apv_codadmision,iap_TipoAisla,apv_estado Into Cursor mwktipo 
	SELECT mwktipo 
mtipoaisla = ''
Scan
	mtipoaisla = mtipoaisla + Transform(iap_TipoAisla )+"-"
Endscan
If Len(mtipoaisla )>1
	mtipoaisla = "A x "+Left(mtipoaisla ,Len(mtipoaisla )-1)
Endif
RETURN PADR(mtipoaisla ,250)

FUNCTION chartipo(mcadmision)
mctipoaisla  = ''

Select Distinc tipoaisla, apv_codadmision,apv_estado   From mwkpacaislanew WHERE apv_codadmision =mcadmision ;
 ORDER BY apv_codadmision,tipoaisla Into Cursor mwktipo
 SELECT mwktipo
Scan
	mctipoaisla  = mctipoaisla  + Alltrim(tipoaisla )+"-"
Endscan
If Len(mctipoaisla  )>1
	mctipoaisla  =Left(mctipoaisla  ,Len(mctipoaisla  )-1)
ENDIF
RETURN PADR(mctipoaisla,50)

FUNCTION chargermen(mcadmision)
mctipoger  = ''
Select Distinc tipoaisla, apv_codadmision,GG_Germen From mwkpacaislanew WHERE apv_codadmision =mcadmision ;
 ORDER BY apv_codadmision,tipoaisla Into Cursor mwktipo
 SELECT mwktipo
Scan
	mctipoger  = mctipoger  + Alltrim(GG_Germen )+CHR(10)
Endscan
 
RETURN PADR(mctipoger  ,250)