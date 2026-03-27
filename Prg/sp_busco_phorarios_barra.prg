*!*
*!*	 Generacion de codigo de barra
*!*
*!*	 Nuevo parámetro : mbusfecha Tipo Lógico
*!*                    valor por defecto nullo, si esta definido viene con .T. para buscar por FECHATUR
*!*                    caso contrario busca por HORATUR
*!*

parameters mfecturno, mbusco1, mbusco2

do sp_busco_medprestam with mfecturno, mbusco1
do sp_muestra_ubicacion
if vartype(mbusco2)#"C"
	mbusco2=''
endif
if mxambito >1
	mccpoamb = " turnos.codambito = ?mxambito and "
	mccpoambf = " franjahoraria.codambito = ?mxambito and "
	mcjoin = 	" and turnos.codambito = franjahoraria.codambito "
else
	mccpoamb = ''
	mcjoin = ''
	mccpoambf = ''
endif

select * from MwkUbica into cursor mwkconsultorio
mcbusca2 = " turnos.fechatur = ?mfecturno  "

mret = sqlexec(mcon1, "select *  from turnos " + ;
	"where " + mcbusca2 + mbusco1+mccpoamb  , "mwkphorario1")

select left(ttoc(horatur,2), 5) as hora, codreserva, fechatomado, mwkphorario1.codserv, fechatur, ;
	horatur, mwkphorario1.id, ttoc(hdesde1,2) as hdesde1, hhasta1, mwkphorario1.codesp, mwkphorario1.codmed, ;
	mwkphorario1.diasem, sala, '*' + str(mwkphorario1.diasem,1) + strtran(str(mwkphorario1.codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + substr(ttoc(hdesde1,2), 4,2) +'*' as codbarra, afiliado, ;
	left(sala,1) as piso, mwkphorario1.codprest,nombre;
	from mwkphorario1 ;
	left join mwkmpfecha on (mwkphorario1.codmed = mwkmpfecha.codmed and ;
	mwkphorario1.codprest = mwkmpfecha.codprest and ;
	mwkphorario1.fechatur >= mwkmpfecha.fecvigend and ;
	mwkphorario1.fechatur < mwkmpfecha.fecvigenh and ;
	mwkphorario1.hhmmtur >= mwkmpfecha.hhmmdes and ;
	mwkphorario1.hhmmtur < mwkmpfecha.hhmmhas and ;
	mwkphorario1.diasem = mwkmpfecha.diasem );
	where generaagen = 1 ;
	into cursor mwkphorarioss


select mwkphorarioss.*,	mwkconsultorio.interno;
	from mwkphorarioss ;
	left outer join mwkconsultorio on mwkconsultorio.lugar = mwkphorarioss.sala;
	into cursor mwkphorarios

if used('mwkphorarioss')
	use in  mwkphorarioss
endif
if used('mwkphorario3')
	use in  mwkphorario3
endif
if used('mwkphorario4')
	use in  mwkphorario4
endif

****
** Agregado para Medicos sin turnos dados
****
do sp_listo_tabla with '','TabTipoFranja','mwktposerv'

mret = sqlexec(mcon1,"SELECT fecvigend , fecvigenh , horahasta , horadesde , turnos.codmed "+;
	", fecpasiva , nombre , hhmmdes , hhmmhas,prestadores.nombre,fechatur,"+;
	" turnos.diasem,esp_descripcion,hhmmtur,franjahoraria.tiposervicio  "+;
	" FROM turnos , prestadores , franjahoraria,especialid,TabTipoTurno "+; 
	" WHERE prestadores.id = turnos.codmed AND fecvigend <> fecvigenh " + ;
	" AND fecvigend <= ?mfecturno AND fecvigenh >= ?mfecturno " + ;
	" AND afiliado = 0 AND hhmmtur >= hhmmdes AND hhmmtur <= hhmmhas and "+;
	' turnos.tipoturno = TabTipoTurno.TipoTurno and '+;
	" turnos.diasem = franjahoraria.diasem and "+;
	mbusco2 + mccpoamb+mccpoambf+" esp_codesp  = prestadores.codesp AND fechatur = ?mfecturno and "+;
	" franjahoraria.codmed = turnos.codmed and TabTipoTurno.grupo in (0,1,2,3) ","mwkTurNoAsig")

select  mwkTurNoAsig.fecvigend , mwkTurNoAsig.fecvigenh , mwkTurNoAsig.horahasta ,;
	mwkTurNoAsig.horadesde as hdesde1 , mwkTurNoAsig.codmed , mwkTurNoAsig.fecpasiva , ;
	mwkTurNoAsig.nombre , mwkTurNoAsig.hhmmdes , '*' + str(mwkTurNoAsig.diasem,1) + ;
	strtran(str(mwkTurNoAsig.codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(mwkTurNoAsig.fechatur),1, 5),'/','') + ;
	left(ttoc(mwkTurNoAsig.horadesde,2), 2) +substr(ttoc(mwkTurNoAsig.horadesde,2), 4,2) + '*' as codbarra, mwktposerv.abrevio ;
	,mwkTurNoAsig.hhmmhas,mwkTurNoAsig.fechatur,mwkmpfecha.codesp,mwkTurNoAsig.diasem,;
	mwkTurNoAsig.esp_descripcion ;
	from mwkTurNoAsig ;
	left join mwktposerv on mwktposerv.id = tiposervicio ;
	left join mwkmpfecha on (mwkTurNoAsig.codmed = mwkmpfecha.codmed and ;
	mwkTurNoAsig.fechatur >= mwkmpfecha.fecvigend and ;
	mwkTurNoAsig.fechatur < mwkmpfecha.fecvigenh and ;
	mwkTurNoAsig.hhmmtur >= mwkmpfecha.hhmmdes and ;
	mwkTurNoAsig.hhmmtur<mwkmpfecha.hhmmhas and ;
	mwkTurNoAsig.diasem = mwkmpfecha.diasem );
	where generaagen = 1 ;
	group by mwkTurNoAsig.codmed ,mwkTurNoAsig.hhmmdes  ;
	into cursor mwkTurNoAsig2


