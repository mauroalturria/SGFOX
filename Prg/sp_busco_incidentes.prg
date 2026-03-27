*** busqueda de incidentes
LPARAMETERS cWhere

mret = SQLExec(mcon1,"select a.id,a.id as _id,a.zis_pacinv as pacinv,a.zis_fecincidente as fecincidente,a.zis_horincidente as horincidente,NVL(a.zis_estadolg,0) as estadolg,a.*, " +;
	"b.nombre as edificio, c.nombre as piso, d.nombre as sector," +;
	"nvl(e.reg_nombrepac,'') as reg_nombrepac,NVL(e.reg_numdocumento,0) as reg_numdocumento,NVL(e.reg_nrohclinica,'') as reg_nrohclinica,NVL(f.zld_tipanalisis,0) as zld_tipanalisis," +;
	"nvl(g.ZSH_tipo,0) as ZSH_tipo, NVL(g.ZSH_tinvolucra,0) as ZSH_tinvolucra, a.ZIS_invlegmant,a.ZIS_invseghig " +;
	"from ZabISeg as a " +;
	"left join ZabISLegDatos as f on a.id = f.ZLD_idinciden " +;
	"left join ZabISegHig as g on a.id = g.ZSH_idinciden " +;
	"left join TabEeEdificios as b on a.zis_edificio = b.id " +;
	"left join TabEePlantasEdificio as c on a.zis_piso = c.id " +;
	"left join TabEeAreasPlanta as d on a.zis_sector = d.id " +;
	"left join registracio as e on a.zis_nroregistrac = e.reg_nroregistrac " + ;
	"where " + cWhere,"mwkDatos1")

If mret < 0
	Messagebox("ERROR EN LA LECTURA DE INCIDENTES DE SEGURIDAD",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

RETURN .t.
