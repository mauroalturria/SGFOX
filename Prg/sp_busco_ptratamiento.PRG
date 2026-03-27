*
* Busqueda de planillas de Tratamientos
*

Lparameters mfec1, mfec2, mregistra, msolo

mwhere = ""

If vartype(mregistra) = "N" and mregistra > 0
	mwhere = mwhere + " TFP_registracio=?mregistra and "
Endif

If vartype(mfec1) = "D"
	mfec1a = ctot( dtoc(mfec1)  + " 00:00:00" )
	mfec2b = ctot( dtoc(mfec2+1)+ " 00:00:00" )
	mwhere = mwhere + " TFP_fecmov >= ?mfec1a and TFP_fecmov < ?mfec2b and "
Endif

mwhere = mwhere + iif(msolo>0," TFP_estado = ?msolo "," TFP_estado > 0 ")

If used('mwkdetplan')
	Use in mwkdetplan
Endif

mret = sqlexec(mcon1,"select TabFarmPlan.id as lid, TFP_fecmov as fecha,"+;
	"TFI_descripcion,TFP_fecpasiva,TFP_registracio,TFP_diagnos,"+;
	"TFP_peso,TFP_talla,TFP_supcor,TFP_medico,TFP_matricula,TFP_ubicacion,TFP_pisocama,"+;
	"TFP_institucion,TFP_formula,TFP_esquema,TabFarmEsq.TFE_esquema as lesquema,TFP_estado"+;
	" from TabFarmPlan"+;
	" join TabFarmIns on TabFarmIns.Id = TabFarmPlan.TFP_institucion "+;
	" left join TabFarmEsq on TabFarmEsq.Id = TabFarmPlan.TFP_esquema where " + mwhere,"mwkdetplan")

If mret < 0
	Messagebox("EN BUSQUEDA DE PLANILLAS DE TRATAMIENTOS"+CHR(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else

	Select lid, fecha, sp_busco_farmacia_paciente(TFP_registracio) as paciente,TFI_descripcion,;
		TFP_diagnos,nvl(TFP_fecpasiva,{//}) as TFP_fecpasiva,;
		sp_busco_farmacia_Obra(TFP_registracio) as obrasoc,nvl(lesquema,space(60)) as lesquema,;
		TFP_registracio,TFP_peso,TFP_talla,TFP_supcor,TFP_medico,;
		TFP_matricula,TFP_ubicacion,TFP_pisocama,TFP_institucion,TFP_formula,TFP_esquema,TFP_estado;
		from mwkdetplan into cursor mwkdetplan

Endif












