Parameters lnCodValeAsist && = loCntVale

*!*	Public loCntVale As cnt_cabvale Of "c:\desaguemes\lib\lib_fbases_sg.vcx"
*!*	loCntVale = Newobject("cnt_cabvale","c:\desaguemes\lib\lib_fbases_sg.vcx")
*!*	loCntVale.nrovale = 25694295
*!*	Public dat_vale, Ite_Vale


store '' to item_vale
store '' to dat_vale
*!*
*!*		(Case Presta2.Matriculas when 0, Presta2.matProv else Presta2.Matriculas)as Mat_medicosolicit,

mbusco1  = ""
lcSql = "Select val_tipopaciente, val_codservvale, " + ;
	"Valesasist, " + ;
	"val_codvaleasist, VAL_codmnemoserv, VAL_fechasolicitud, " + ;
	"VAL_horasolicitud, Val_CodAdmision, val_urgenciaserv, " + ;
	"VAL_observaciones, Val_NroProtocolo, VAL_Prestador, " + ;
	"val_verficasolicit, Val_CodPun, VAL_Bono, val_tipopaciente, Val_medicosolicit, " + ;
	"PAC_nombrepaciente, PAC_edad, PAC_habitacion, PAC_cama, " + ;
	"PAC_sexo, PAC_codadmision, PAC_fechaadmision, " + ;
	"PAC_horaadmision , PAC_horaalta, PAC_codhci, PAC_operadm , PAC_operalta , " + ;
	"PAC_codhce, PAC_descripdiagn, PAC_domicilio,PAC_fechaalta, " + ;
	"PAC_categoria, PAC_denuncia, PAC_fecnacimiento, " + ;
	"sec_codsector, sec_descripsec, " + ;
	"COB_codcontrato, " + ;
	"Ent_CodEnt, ENT_descrient,ENT_nroprestadorexterno, " + ;
	"AFI_nroafiliado, " + ;
	"CON_codcont, CON_descricont, " + ;
	"Presta1.Nombre as Des_Prestador, " + ;
	"(Case when Nvl(Presta1.Matriculas,0) = 0 then Presta1.matProv else Presta1.Matriculas end ) as Mat_Prestador, " + ;
	"Presta2.Nombre as Des_medicosolicit, " + ;
	"(Case when Nvl(Presta2.Matriculas,0) = 0 then Presta2.matProv else Presta2.Matriculas end ) as Mat_medicosolicit, " + ;
	"Servicios.SER_descripServ, " + ;
	"Val_Estado, val_operadorConforme, val_fechaconforme, val_horaconforme,  " + ;
	"TabUsuario.NomApe as NombOpeConf " + ;
	",VALESASIST.VAL_FHSolicitud " + ;
	"from ValesAsist " + ;
	"Left Join pacientes on valesasist.val_CodAdmision = pacientes.Pac_CodAdmision " + ;
	"left join sectores on pacientes.PAC_sectorinternac = sectores.sec_codsector " + ;
	"left join coberturas on pacientes.PAC_codadmision = coberturas.COB_pacientes " + ;
	"left join entidades on coberturas.COB_codentidad = entidades.ENT_codent " + ;
	"left join  afiliacion on " + ;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	ENT_codent = afiliacion.AFI_codentidad " + ;
	"Left Join CONTRATOS ON COB_codcontrato = CON_codcont " + ;
	"Left Join Prestadores as Presta1 ON ValesAsist.VAL_Prestador = Presta1.Id " + ;
	"Left Join Prestadores as Presta2 ON ValesAsist.Val_medicosolicit = Presta2.Id " + ;
	"Left Join Servicios ON ValesAsist.val_codservvale = Servicios.SER_codserv " + ;
	"Left join TabUsuario ON TabUsuario.CodigoVax = ValesAsist.val_operadorConforme " + ;
	"Where valesasist.val_CodValeAsist = ?lnCodValeAsist "



*?loCntVale.nrovale

*!*		TPV_Estado,
*!*		left outer join TabPacVip on pacientes.PAC_codhci = TabPacVip.TPV_NroReg
*!*		left join pacinternad on pacinternad.pin_codadmision = pacientes.PAC_codadmision

mret = SQLExec(mcon1, lcSql + mbusco1 , "mwkValeAsist")

If mret <= 0
	Aerror(eros)
	Messagebox(eros(3))

	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA VALESASIST",48,"VALIDACION")
	Return .F.
Endif

Select mwkValeAsist
dat_vale(1)  = Transform(val_codvaleasist)
dat_vale(2)  = VAL_codmnemoserv	&& NEM
dat_vale(3)  = Alltrim(ser_descripserv)	&& DSERV
dat_vale(4)  = Transform(VAL_fechasolicitud) && FEC
dat_vale(5)  = VAL_horasolicitud  && HOR
dat_vale(6)  = Val_CodAdmision	&& HC
dat_vale(7)  = Alltrim(AFI_nroafiliado) && AFI
dat_vale(8)  = Pac_CodHce && HCLI
dat_vale(9)  = Pac_Sexo && SEX
dat_vale(10) = Transform(Pac_edad) && ED
dat_vale(11) = Alltrim(PAC_nombrepaciente) && NOM
dat_vale(12) = Transform(CON_codcont) && CONT
dat_vale(13) = Alltrim(CON_descricont) && DCONT
dat_vale(14) = Iif(val_urgenciaserv = '0','N','S') && URG
dat_vale(15) = Alltrim(Nvl(VAL_observaciones,'')) && COM
dat_vale(16) = Transform(Val_NroProtocolo)
dat_vale(17) = ''&& UBICACION // Mapeo
dat_vale(18) = ''&& CNSLT // Mapeo
dat_vale(19) = Transform(VAL_Prestador) && MEDPREST
dat_vale(20) = Alltrim(Des_Prestador) && SOLIC nombre
dat_vale(21) = Alltrim(Des_medicosolicit) && DSOLIC // VAL_MEDICOSOLICIT
dat_vale(22) = Transform(Nvl(VAL_Bono,''))&& nrobono
dat_vale(23) = ''&& Operadro // Mapeo
dat_vale(24) = Transform(val_verficasolicit) && sec
dat_vale(25) = Transform(Val_CodPun) && codpun
dat_vale(26) = Transform(ENT_codent) && codent
dat_vale(27) = Transform(Pac_FecNacimiento) && fecha Nacim
dat_vale(28) = ''
dat_vale(29) = ''
dat_vale(30) =  VAL_FHSolicitud  

If mwkValeAsist.val_codservvale = 5410

	lcSql = "Select Presinsuvas.pia_cantsolicitada, " + ;
		"insumos.INS_codinsumo as PRE_CodPrest, " + ;
		"insumos.INS_descriinsumo as PRE_descriprest, " + ;
		"?mwkValeAsist.val_codservvale " + ;
		"from Presinsuvas " + ;
		"Left Join insumos on insumos.insumos = presinsuvas.PIA_codinsumo " + ;
		"Where presinsuvas.pia_valesasist = ?mwkValeAsist.Valesasist "

Else

	lcSql = "Select Presinsuvas.pia_cantsolicitada, " + ;
		"Prestacions.PRE_CodPrest, " + ;
		"Prestacions.PRE_descriprest, " + ;
		"?mwkValeAsist.val_codservvale as val_codservvale, " + ;
		"PRESTINSUMO.PRI_Codinsumo, PRESTINSUMO.PRI_Cantidad, PRESTINSUMO.PRI_Conforme, " +;
		"INSUMOS.ins_codpuntero, INSUMOS.ins_codinsumo, INSUMOS.ins_descriinsumo, " +;
		" IAS_coddinsum,IAS_cantidad "+;
		"from Presinsuvas " + ;
		"Left Join Prestacions on Presinsuvas.Pia_CodPrest = Prestacions.PRE_CodPrest " + ;
		"left join PRESTINSUMO on Presinsuvas.Pia_CodPrest = PRESTINSUMO.PRI_PRESTACIONS " +;
		"left join INSUMOS on PRESTINSUMO.PRI_Codinsumo = INSUMOS.ins_codpuntero " +;
		" LEFT OUTER JOIN INASOVALEAS ON  PRESINSUVAS = IAS_PRESINSUVAS "+;
		" Where presinsuvas.pia_valesasist = ?mwkValeAsist.Valesasist and INSUMOS.ins_fechapasivo is null "

Endif

mret = SQLExec(mcon1, lcSql + mbusco1 , "mwkIteAsist0")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA PRESINSUVAS",48,"VALIDACION")
	Return .F.
Endif

** ----------- Marcelo Torres, 29/01/2025. Buscamos los items pendientes
lcSql = "Select PREPEN_codigo,PREPEN_vale " + ;
"from Prestapendi " +;
"Where PREPEN_vale = ?lnCodValeAsist"

mret = SQLExec(mcon1, lcSql , "mwkItePendi")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA PENDIENTES",48,"VALIDACION")
	Return .F.
Endif

** ----------- Marcelo Torres, 03/07/2019. Separamos los items de la cabecera.
Use In Select("mwkPrestaItems")
If mwkValeAsist.val_codservvale = 5410
	Select *,pia_cantsolicitada As _CantCalc ,1 As Estado From mwkIteAsist0 Where PRE_CodPrest Is Not Null ;
		INTO Cursor mwkPrestaItems
	Select Distinct pia_cantsolicitada, PRE_CodPrest, PRE_descriprest, 5410 as val_codservvale From mwkIteAsist0 Into Cursor mwkIteAsist

Else

	Select pia_cantsolicitada,PRE_CodPrest, PRE_descriprest, val_codservvale,PRI_Codinsumo;
		,PRI_Cantidad, PRI_Conforme, ins_codpuntero, ins_codinsumo, ins_descriinsumo;
		, Iif(!Isnull(IAS_cantidad),IAS_coddinsum,PRI_Codinsumo) As IAS_coddinsum,Nvl(IAS_cantidad,PRI_Cantidad * pia_cantsolicitada ) As IAS_cantidad  ;
		FROM mwkIteAsist0 Into Cursor mwkIteAsist1

	Select pia_cantsolicitada,PRE_CodPrest, PRE_descriprest, val_codservvale,PRI_Codinsumo;
		,PRI_Cantidad, PRI_Conforme, ins_codpuntero, ins_codinsumo, ins_descriinsumo;
		,IAS_coddinsum, IAS_cantidad  ;
		FROM mwkIteAsist1 Where IAS_coddinsum=PRI_Codinsumo Into Cursor mwkIteAsist
	Select *,IAS_cantidad As _CantCalc ,1 As Estado From mwkIteAsist Where ins_codinsumo Is Not Null Into Cursor mwkPrestaItems

	Select Distinct pia_cantsolicitada, PRE_CodPrest, PRE_descriprest, val_codservvale From mwkIteAsist Into Cursor mwkIteAsist

Endif
Go Top


** --------------------------------------
Ix = 0
Select mwkIteAsist
Go Top
Scan All
	Ix = Ix + 1
	item_vale(Ix,1) = Transform(mwkIteAsist.PRE_CodPrest)
	item_vale(Ix,2) = Transform(mwkIteAsist.pia_cantsolicitada)
	item_vale(Ix,3) = Alltrim(mwkIteAsist.PRE_descriprest)
	if Ix >=30
		dime item_vale(ix+1,3)
	ENDIF
		Select mwkIteAsist
Endscan

*!*	Use In Select("mwkValeAsist")
*!*	Use In Select("mwkIteAsist")

*!*	Set Alternate To c:\prueba.txt
*!*	Set Alternate on

*!*	For Ix = 1 To 30
*!*		?dat_vale(Ix)
*!*	Next
*!*	For Ix = 1 To 31
*!*		?item_vale(Ix,1)
*!*		?item_vale(Ix,2)
*!*		?item_vale(Ix,3)
*!*	Next

*!*	Set Alternate off
*!*	Set Alternate To
