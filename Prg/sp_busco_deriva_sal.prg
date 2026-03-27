****
** Busco Derivaciones de salida
****
parameter mfecdes,mfechas
fh = sp_busco_fecha_serv("DT")
if vartype(mfechas)#"T"
	mfechas = fh
endif

mret = SQLExec(mcon1, "select tabderivasal.id, tabderivasal.codent, " + ;
	"diagnostico, edad, tabderivasal.estado, tabderivasal.fechahora, notifica, " + ;
	"nroafi, nroregistrac, observa, tabderivasal.sexo, traslado, tabderivasal.usuario, ubicacion, " + ;
	"ENT_descrient, REG_nombrepac, " + ;
	"fechahoraingreso, " + ;
	"REG_numdocumento as nrodocumento, TabEstados.Descrip as estado1, tabderivasal.CodMedTrat, " + ;
	"prestadores.Nombre " + ;
	"from tabderivasal " + ;
	"inner join registracio on tabderivasal.nroregistrac = REG_nroregistrac " + ;
	"inner join entidades on tabderivasal.codent = ENT_codent " + ;
	"inner join TabEstados on tabderivasal.Estado = TabEstados.Estado " + ;
	"Left join Prestadores on prestadores.id = tabderivasal.CodMedTrat " + ;
	"where  tabderivasal.fechahora >= ?mfecdes " + ;
	" And tabderivasal.fechahora < ?mfechas " + ;
	" And TabEstados.Propietario = 8 and tipo = 0 " + ;
	"order by tabderivasal.fechahora", "mwkderiva1")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_deriva_sal1',transf(mfecdes)
	cancel
endif
mfechas = mfecdes
mfecdes = mfecdes-(60*24*3600)
mret = SQLExec(mcon1, "select tabderivasal.id, tabderivasal.codent, " + ;
	"diagnostico, edad, tabderivasal.estado, tabderivasal.fechahora, notifica, " + ;
	"nroafi, nroregistrac, observa, tabderivasal.sexo, traslado, tabderivasal.usuario, ubicacion, " + ;
	"ENT_descrient, REG_nombrepac, " + ;
	"fechahoraingreso, " + ;
	"REG_numdocumento as nrodocumento, TabEstados.Descrip as estado1, tabderivasal.CodMedTrat, " + ;
	"prestadores.Nombre " + ;
	"from tabderivasal " + ;
	"inner join registracio on tabderivasal.nroregistrac = REG_nroregistrac " + ;
	"inner join entidades on tabderivasal.codent = ENT_codent " + ;
	"inner join TabEstados on tabderivasal.Estado = TabEstados.Estado " + ;
	"Left join Prestadores on prestadores.id = tabderivasal.CodMedTrat " + ;
	"where  tabderivasal.fechahora >= ?mfecdes " + ;
	" And tabderivasal.fechahora < ?mfechas " + ;
	" And TabEstados.Propietario = 8 and tipo = 0 and tabderivasal.Estado = 0" + ;
	"order by tabderivasal.fechahora", "mwkderiva2")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_deriva_sal2',transf(mfecdes)
	cancel
endif
select * from mwkderiva2 union all;
	select * from mwkderiva1 ;
	into cursor mwkderiva
