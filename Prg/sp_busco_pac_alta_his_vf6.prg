****
** Busco pacientes de alta por nombre y fecha_alta desde
****
Parameter mbusco1, mfechad, mfechah, msql_pac, mnomcur

If Vartype(mnomcur)#"C"
	mnomcur = 'mwkpacalta1'
Endif

If !Used('mwkusuariosall')
	Do sp_busco_usuarios_all
Endif


If Type ('mfechad')="D"
	cfecha = " PAC_fechaalta 			>= ?mfechad and " +;
		"PAC_fechaalta 			<= ?mfechah and "
Else
	cfecha = " "
Endif

ctipopac = " Pac_tipopac<2  AND "
*

mret = SQLExec(mcon1, "select PAC_codadmision, PAC_nombrepaciente, PAC_fechaadmision, " + ;
	" PAC_fechaalta, ENT_descrient,PAC_sectorinternac, mte_descripcion, ltrim({fn space(1)}),PAC_sexo, " + ;
	" PAC_edad, PAC_diagegreso, PAC_nombrerespons, PAC_domicresponsab,PAC_descripdiagegr," + ;
	" PAC_telefresponsab, PAC_medicoadmision, PAC_descripdiagn, PAC_denuncia," + ;
	" PAC_medicoalta, PAC_observalta, PAC_codhce,PAC_horaadmision, PAC_horaalta, " + ;
	" PAC_operadm , PAC_operalta , PAC_aislacion, PAC_habitacion,PAC_cama," + ;
	" PAC_categoria, PAC_motivoalta, PAC_areainternac, PAC_codcie10diagegr,PAC_codhci, " +;
	" PAC_codcie10diagegr->descrip as descripegr, PAC_codcie10diagalt, PAC_codcie10diagalt->descrip as descripegralt, " +;
	" REG_domicilio, REG_telefonos, ENT_codent,PAC_fecnacimiento,REG_nroregistrac , TPV_Estado, " + ;
	" PAC_ordeninternac,ORICodAutoriz,ORINroOrden, ORIObservac, ORITipoOrden, ORIVigDesde,Tabpacobito.PO_FechaIngreso, " + ;
	" pac_fotocrechab,pac_fotocdni,pac_fotoccarnetos,pac_ordeninternac, Tabpacobito.PO_admision,Tabpacobito.po_estado,"+;
	" PO_SolicAmbu,coberturas.cob_codentidad, REG_numdocumento   " +;
	" from  coberturas, entidades, registracio,pacientes " + ;
	" left join motivoegreso on pacientes.PAC_motivoalta = motivoegreso.mte_codmotivo " +;
	" left outer join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
	" left join  ordeninternac on ordeninternac.oricodadmision = pacientes.PAC_codadmision "+;
	" left join  Tabpacobito on  Tabpacobito.PO_admision = pacientes.PAC_codadmision "+;
	" where PAC_codadmision 	= COB_pacientes and " + ;
	" COB_codentidad 		= ENT_codent and " + ;
	ctipopac + mbusco1 + cfecha +;
	" PAC_codhci				= REG_nroregistrac " + ;
	"" , "mwkpacalta1a")
&& REG_fecnacimiento>= to_date('01/01/1900','dd/mm/yyyy')

If mret<=0

**SET STEP ON

	Messagebox("ERROR EN LA GENERACION DEL CURSOR. AVISE A SISTEMAS.",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

lret = .T.
Select PAC_codhci From mwkpacalta1a Where INLIST(Nvl(TPV_Estado,0),1,3) Into Cursor mwkpass
If Reccount('mwkpass')>0
	Do Form frmpass_sec To lret
	mhc = Transf(mwkpass.PAC_codhci)
	Do sp_insert_tabCtrlErr With Iif(lret,"SI","NO") + mwkusuario.idusuario, mwkexe.nomexe+' pac_admitidos '+ miform + '-'+mhc, '',''
Endif

mwhere = Iif(!lret,' where !INLIST(Nvl(TPV_Estado,0),1,3) ','')
mhoy = sp_busco_fecha_serv("DD")
Select PAC_codadmision, PAC_nombrepaciente, PAC_fechaadmision;
	,PAC_fechaalta,'00:00' As hora, ENT_descrient,PAC_sectorinternac, mte_descripcion;
	,tabusuario2.idusuario As operalta, Iif(Isnull(ORItipoorden),"N","S") As orden ;
	,alltrim(pac_fotocrechab )+" "+Alltrim(pac_fotocdni) + " "+Alltrim(pac_fotoccarnetos) As DocInCompl, PAC_sexo ;
	,PAC_edad, PAC_diagegreso, PAC_nombrerespons, PAC_domicresponsab;
	,PAC_telefresponsab, PAC_medicoadmision, PAC_descripdiagn ;
	,PAC_denuncia, PAC_medicoalta, PAC_observalta,PAC_descripdiagegr ;
	,PAC_codhce, PAC_horaadmision, PAC_horaalta, PAC_operadm , PAC_operalta  ;
	,PAC_aislacion, PAC_habitacion,PAC_cama,PAC_categoria;
	,PAC_motivoalta, PAC_areainternac, PAC_codcie10diagegr,PAC_codcie10diagalt, descripegralt ;
	,REG_domicilio, REG_telefonos, ENT_codent,PAC_fecnacimiento ,REG_nroregistrac ;
	,iif(PAC_edad>0,Transf(PAC_edad,"999"),Transf(Round((mhoy-PAC_fecnacimiento)/30,0),"99")+"M") As anios ;
	, descripegr,tabusuario1.idusuario As operadmi,PO_FechaIngreso ;
	,ORICodAutoriz,ORINroOrden, ORIObservac, ORItipoorden, ORIVigDesde,Nvl(po_estado ,0) As denuncia;
	,PO_SolicAmbu,cob_codentidad;
	,REG_numdocumento   ;
	from mwkpacalta1a ;
	left Join  mwkusuariosall As tabusuario1 On PAC_operadm 	= tabusuario1.codigovax;
	left Join  mwkusuariosall As tabusuario2 On PAC_operalta 	= tabusuario2.codigovax;
	&mwhere  Group By PAC_codadmision Order By PAC_codadmision ;
	into Cursor &mnomcur


msql_pac = "select * from " + mnomcur + " into cursor mwkpacalta"
*!*	endif
**		tabusuario2.idusuario as operalta,PAC_sexo, ;
*AC_codcie10diagalt,
