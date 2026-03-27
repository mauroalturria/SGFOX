****
** busco cambios de cama
****
parameter msector , mfecha
if !used("mwkentidad")
	do sp_entidades
endif

mfechad = ttod(mfecha)
mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_nombrepaciente " + ;
	",sec_descripsec,lugarintern.*,PIN_codentidad " +;
	" from pacinternad, lugarintern,TabNutPaciente "+;
	" left join pacientes on TabNutPaciente.TNP_codadmision = pacientes.PAC_codadmision " + ;
	" left outer join sectores on pacientes.PAC_sectorinternac = sectores.sec_codsector " + ;
	" where TNP_codadmision = PIN_codadmision  and  PIN_codadmision = LUG_PACIENTES "+;
	" and lug_codsector = ?msector and lug_fechaegreso >= ?mfechad " +;
	" group by LUG_PACIENTES, lug_fechaegreso , LUG_habitacion , LUG_cama  ", "mwkcbiocama01")

if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif
select mwkcbiocama01.*,ent_descrient from mwkcbiocama01,mwkentidad ;
	where PIN_codentidad = ent_codent  ;
	order by LUG_habitacion,LUG_cama into cursor mwkcbiocama
