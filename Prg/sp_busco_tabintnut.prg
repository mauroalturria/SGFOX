parameters tnOpcion, tcWhere, tcCursor,tnhoras   && horas para atras

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif
if vartype(tnhoras) # "N"
	tnhoras = 0
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntNut'
endif
do case
	case tnOpcion = 1
		lcSql = "SELECT TabIntNut.*,PRE_descriprest,pre_alimenticio FROM TabIntNut "+;
			" inner join prestacions on TabIntNut.IN_codprest = prestacions.PRE_codprest "+ tcWhere
	case tnOpcion = 2  && busqueda para generar vale
		lcSql = "SELECT TabIntNut.*,tabintHCE.IH_admision, pac_sectorinternac,tabintHCE.IH_secuencia ,Tabnutprest.TNP_Dieta "+;
			" FROM TabIntNut "+;
			" inner join TabintHCE  on TabintHCE.id = TabIntNut.IN_idevol " + ;
			" inner join pacinternad on pin_codadmision  = tabintHCE.IH_admision " +;
			" inner join pacientes on pin_codadmision  = pac_codadmision " +;
			" inner join Tabnutprest on Tabnutprest.TNP_codPrest = Tabintnut.IN_codprest " +;
			" where IN_fechabaja >= '2090-01-01' " + tcWhere
	case tnOpcion = 3  &&para nutricion
		lcSql = "SELECT TabIntNut.*,tabintHCE.IH_admision, PAC_nombrepaciente,pac_sectorinternac,tabintHCE.IH_secuencia,tabintHCE.IH_secagrup"+;
			",PAC_habitacion, PAC_cama, PAC_categoria,nombre ,Prestacions.PRE_descriprest,pac_codadmision,Tabnutprest.TNP_Dieta "+;
			" FROM TabIntNut "+;
			" inner join TabintHCE  on TabintHCE.id = TabIntNut.IN_idevol " + ;
			" inner join pacinternad on pin_codadmision  = tabintHCE.IH_admision " +;
			" inner join pacientes on pin_codadmision  = pac_codadmision " +;
			" inner join Prestacions on PRE_codprest = Tabintnut.IN_codprest " +;
			" inner join Tabnutprest on Tabnutprest.TNP_codPrest = Prestacions.PRE_codprest " +;
			" left join Prestadores on Tabintnut.IN_codmed  = Prestadores.id " +;
			" where IN_fechabaja >= '2090-01-01' " + tcWhere
	case tnOpcion = 4  && suspensiones para nutricion
		mfecdia = prg_dtoc(mwkfecserv.fechahora-tnhoras*3600)
		mfecvigen  = prg_Dtoc(mwkfecserv.fechahora-(23*3600)-(59*60))
* mfecant = prg_dtoc(prg_calcula_diahabil(ttod(mwkfecserv.fechahora),-1,"1,7"))
* SELECT ID , INA_codmed , INA_fechaBaja , INA_fechaHoraIni , INA_idevol , INA_observa , INA_usuariobaja FROM SQLUser . TabIntAyuno
		lcSql = "SELECT  TabIntAyuno.*,IH_admision,tabintHCE.IH_secuencia  "+;
			" FROM TabIntAyuno "+;
			" inner join TabintHCE  on TabintHCE.id = TabIntAyuno.INA_idevol " + ;
			" inner join pacinternad on pin_codadmision  = tabintHCE.IH_admision " +;
			" inner join pacientes on pin_codadmision  = pac_codadmision " +;
			" where INA_fechaBaja >= ?mfecdia and INA_fechaHoraIni>= ?mfecvigen  " + tcWhere
	case tnOpcion = 5  && suspensiones para nutricion con suspendidos
		mfecdia = prg_dtoc(ttod(mwkfecserv.fechahora))
		mfecvigen  = prg_Dtoc(mwkfecserv.fechahora-(23*3600)-(59*60))
* mfecant = prg_dtoc(prg_calcula_diahabil(ttod(mwkfecserv.fechahora),-1,"1,7"))
* SELECT ID , INA_codmed , INA_fechaBaja , INA_fechaHoraIni , INA_idevol , INA_observa , INA_usuariobaja FROM SQLUser . TabIntAyuno
		lcSql = "SELECT  TabIntAyuno.*,IH_admision,tabintHCE.IH_secuencia  "+;
			" FROM TabIntAyuno "+;
			" inner join TabintHCE  on TabintHCE.id = TabIntAyuno.INA_idevol " + ;
			" inner join pacinternad on pin_codadmision  = tabintHCE.IH_admision " +;
			" where INA_fechaBaja >= ?mfecdia and INA_fechaHoraIni>= ?mfecvigen  " + tcWhere
	otherwise
		return .f.
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
