****
** busco dieta de un paciente
****
parameter madmision
if !used("mwkentidad")
	do sp_entidades
endif
mfecdia = sp_busco_fecha_serv('DD')
mfechanull  = "1900-01-01 00:00:00"
if !used('mwkusuariosall')
	do sp_busco_usuarios_all
endif	

mdieta = ' ((TNP_codserv = 0 and  TND_codPrest>0) or TNP_codserv>0) and '
mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision " +;
	" ,PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
	", Tabnutdetalle.*, Tabnutpaciente.*,sec_descripsec,PAC_fechaalta, pac_categoria " + ;
	", sec_codsector "+;
	", PAC_codhci "+;
	" from TabNutPaciente inner join pacientes on TabNutPaciente.TNP_codadmision = pacientes .PAC_codadmision " + ;
	" left join TabNutDetalle on TabNutDetalle .TND_idPaciente = TabNutPaciente.id" + ;
	" inner join sectores on pacientes.PAC_sectorinternac = sectores .sec_codsector " + ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle .TND_codPrest" + ;
	" where TNP_codadmision = ?madmision ", "mwknutpac1")
if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif
if !used('mwkpres')
	mret =	sqlexec(mcon1, "select pre_codprest,PRE_descriprest" + ;
		" from prestacions " + ;
		" where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")
endif
select mwknutpac1.*,usupiso.nomape as usuario_piso,usunutri.nomape as usuario_nutri from mwknutpac1 ;
	left join mwkpres on TND_codPrest = pre_codprest ;
	left join mwkusuariosall as usupiso on usupiso.codigovax = tnd_usuario;
	left join mwkusuariosall as usunutri on usunutri.codigovax = tnp_usuario;
	where &mdieta !inlist(TNP_CodServ,1,2);
	group by TNP_Fecha,TND_hora, TNP_CodServ ;
	into cursor mwknutpac0

select mwknutpac1.*,usupiso.nomape as usuario_piso,usunutri.nomape as usuario_nutri from mwknutpac1 ;
	left join mwkpres on TND_codPrest = pre_codprest ;
	left join mwkusuariosall as usupiso on usupiso.codigovax = tnd_usuario;
	left join mwkusuariosall as usunutri on usunutri.codigovax = tnp_usuario;
	where inlist(TNP_CodServ,1,2);
	into cursor mwknutpacac

select * from mwknutpac0 ;
	union all ;
	select * from mwknutpacac ;
	into cursor mwknutpac01
	
select * from mwknutpac01 ;
	order by TNP_Fecha,TND_hora, TNP_CodServ,TND_NroVale  ;
	into cursor mwknutpac
