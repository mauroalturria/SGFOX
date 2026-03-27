****
** busco internados
****

Parameters mbusco1, msql_pac

ctipopac = 	"PAC_tipopac<2 "
If !Used('mwkusuariosall')
	Do sp_busco_usuarios_all
Endif
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = " and sec_codsector in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif
mret = SQLExec(mcon1, "select PAC_nombrepaciente, PAC_edad, sec_codsector, " + ;
	" sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient,ENT_nroprestadorexterno, " + ;
	" PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, " + ;
	" PAC_horaadmision , pac_horaalta, PAC_codhci, PAC_operadm , PAC_operalta , " + ;
	" PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, pac_domicilio,PAC_fechaalta, " + ;
	" PAC_categoria, COB_codcontrato, ENT_codent, PAC_denuncia ,TPV_Estado, " + ;
	" PAC_ordeninternac,ORICodAutoriz,ORINroOrden, ORIObservac, ORITipoOrden, "+;
	" ORIVigDesde,oridiasvigencia,PAC_motivoalta,mte_descripcion, PAC_nombrerespons,REG_numdocumento  " + ;
	" from pacientes " + ;
	"Inner Join registracio on PAC_codhci = REG_nroregistrac " + ;
	" left join sectores on pacientes.PAC_sectorinternac = sectores.sec_codsector " +;
	" left join coberturas on pacientes.PAC_codadmision = coberturas.COB_pacientes " +;
	" left join pacinternad on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +;
	" left join entidades on coberturas.COB_codentidad = entidades.ENT_codent " +;
	" left outer join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
	" left join motivoegreso on pacientes.PAC_motivoalta = motivoegreso.mte_codmotivo " +;
	" left join  afiliacion on " +;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	coberturas.COB_codentidad = afiliacion.AFI_codentidad " + ;
	"left join ordeninternac on ordeninternac.oricodadmision = pacientes.PAC_codadmision "+;
	"where  PAC_tipopac<2 "+;
	mwcm  + mbusco1 , "mwkpacint0")

lret = .T.
Select PAC_codhci From mwkpacint0 Where INLIST(Nvl(TPV_Estado,0),1,3) Into Cursor mwkpass
If Reccount('mwkpass')>0 
	Do Form frmpass_sec WITH mwkpass.pac_codhci To lret
	mhc = Transf(mwkpass.PAC_codhci)
	Do sp_insert_tabCtrlErr With Iif(lret,"SI","NO") + mwkusuario.idusuario, mwkexe.nomexe+' pac_admitidos '+ miform + '-'+mhc, '',''
Endif

mwhere = Iif(!lret,' where !INLIST(Nvl(TPV_Estado,0),1,3) ','')

If mret<1
	=Aerr(eros)
	Messagebox(eros(2))

Endif
If !Used('mwkentexc_int')
	mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT' and tipoturno = 0","mwkentexc_int")
Endif
Select * From mwkpacint0 Left Join mwkentexc_int On codent = ENT_codent  &mwhere Into Cursor mwkpacint0

Select PAC_nombrepaciente, sec_codsector, sec_descripsec, PAC_habitacion, ;
	PAC_cama, PAC_categoria, ENT_descrient,Iif(Isnull(mwkpacint0.fecpasiva),'  ','PE') As PAC_excl, ;
	tabusuario1.idusuario As operadmi ,PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, ;
	substr(Ttoc(PAC_horaadmision) ,12,5) As PAC_horaadmision, ;
	ttoc(pac_horaalta,2) As PAC_horaalta, PAC_codhci, COB_codcontrato,  ;
	PAC_codhce, AFI_nroafiliado, PAC_fechaalta,'', PAC_descripdiagn, pac_domicilio,ENT_codent ;
	,tabusuario2.idusuario As operalta,PAC_operadm,TPV_Estado,ENT_nroprestadorexterno  ;
	,PAC_ordeninternac,ORICodAutoriz,ORINroOrden, ORIObservac, ORITipoOrden, ORIVigDesde;
	,PAC_motivoalta,mte_descripcion, PAC_nombrerespons,REG_numdocumento ;
	from mwkpacint0 ;
	left Join  mwkusuariosall As tabusuario1 On PAC_operadm 	= tabusuario1.codigovax;
	left Join  mwkusuariosall As tabusuario2 On PAC_operalta 	= tabusuario2.codigovax;
	group By PAC_codadmision Order By PAC_codadmision Into Cursor mwkpacint

msql_pac = "select * from mwkpacint into cursor mwkpacint1"

