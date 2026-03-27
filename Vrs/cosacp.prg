public mcon3
do sp_conexion_tablas

mfecdes = ctod("01/01/2004")
mfechas = ctod("31/01/2004")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,pac_codhce,"+;
	" val_tipopaciente ,cob_codentidad,pia_cantsolicitada " + ;
	",VAL_circuitoorigen,VAL_prestador,pia_valesasist,pia_secuen_carga "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale in ( 2200, 8900 ) and val_tipopaciente = 'AMB' " + ;
	" and pia_codprest in ( 42010115, 42010184,42030338,46010187 ) " + ;
	" order by val_fechasolicitud, val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select * from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce into cursor agrupo

select val_prestador , VAL_circuitoorigen,count (pac_codhce) as pacientes ;
 from mwktodogua1 group by val_prestador,VAL_circuitoorigen into cursor total
select total
copy to totene type xls
set step on
select sum(iif(val_tipopaciente="GUA" and cob_codentidad=945,1,0)) as gua945, ;
 sum(iif(val_tipopaciente="GUA" and cob_codentidad=948,1,0)) as gua948, ; 
sum(iif(val_tipopaciente="GUA" and cob_codentidad=484,1,0)) as gua484, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=945,1,0)) as amb945, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=948,1,0)) as amb948, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=484,1,0)) as amb484  ; 
 from agrupo into cursor totalgr
select totalgr
copy to totenegr type xls

mfecdes = ctod("01/02/2004")
mfechas = ctod("29/02/2004")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,pac_codhce,"+;
	" val_tipopaciente ,cob_codentidad,pia_cantsolicitada " + ;
	",VAL_circuitoorigen,VAL_prestador,pia_valesasist,pia_secuen_carga "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale in ( 2200, 8900 ) and val_tipopaciente = 'AMB' " + ;
	" and pia_codprest in ( 42010115, 42010184,42030338,46010187 ) " + ;
	" order by val_fechasolicitud, val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select * from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce into cursor agrupo

select val_prestador , VAL_circuitoorigen,count (pac_codhce) as pacientes ;
 from mwktodogua1 group by val_prestador,VAL_circuitoorigen into cursor total

select total
copy to totfeb type xls
select sum(iif(val_tipopaciente="GUA" and cob_codentidad=945,1,0)) as gua945, ;
 sum(iif(val_tipopaciente="GUA" and cob_codentidad=948,1,0)) as gua948, ; 
sum(iif(val_tipopaciente="GUA" and cob_codentidad=484,1,0)) as gua484, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=945,1,0)) as amb945, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=948,1,0)) as amb948, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=484,1,0)) as amb484  ; 
 from agrupo into cursor totalgr
select totalgr
copy to totfebgr type xls

mfecdes = ctod("01/03/2004")
mfechas = ctod("31/03/2004")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,pac_codhce,"+;
	" val_tipopaciente ,cob_codentidad,pia_cantsolicitada " + ;
	",VAL_circuitoorigen,VAL_prestador,pia_valesasist,pia_secuen_carga "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale in ( 2200, 8900 ) and val_tipopaciente = 'AMB' " + ;
	" and pia_codprest in ( 42010115, 42010184,42030338,46010187 ) " + ;
	" order by val_fechasolicitud, val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select * from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce into cursor agrupo

select val_prestador , VAL_circuitoorigen,count (pac_codhce) as pacientes ;
 from mwktodogua1 group by val_prestador,VAL_circuitoorigen into cursor total

select total
copy to totmar type xls
select sum(iif(val_tipopaciente="GUA" and cob_codentidad=945,1,0)) as gua945, ;
 sum(iif(val_tipopaciente="GUA" and cob_codentidad=948,1,0)) as gua948, ; 
sum(iif(val_tipopaciente="GUA" and cob_codentidad=484,1,0)) as gua484, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=945,1,0)) as amb945, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=948,1,0)) as amb948, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=484,1,0)) as amb484  ; 
 from agrupo into cursor totalgr
select totalgr
copy to totmargr type xls

mfecdes = ctod("01/04/2004")
mfechas = ctod("30/04/2004")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,pac_codhce,"+;
	" val_tipopaciente ,cob_codentidad,pia_cantsolicitada " + ;
	",VAL_circuitoorigen,VAL_prestador,pia_valesasist,pia_secuen_carga "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale in ( 2200, 8900 ) and val_tipopaciente = 'AMB' " + ;
	" and pia_codprest in ( 42010115, 42010184,42030338,46010187 ) " + ;
	" order by val_fechasolicitud, val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select * from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce into cursor agrupo

select val_prestador , VAL_circuitoorigen,count (pac_codhce) as pacientes ;
 from mwktodogua1 group by val_prestador,VAL_circuitoorigen into cursor total
select total
copy to totabr type xls
select sum(iif(val_tipopaciente="GUA" and cob_codentidad=945,1,0)) as gua945, ;
 sum(iif(val_tipopaciente="GUA" and cob_codentidad=948,1,0)) as gua948, ; 
sum(iif(val_tipopaciente="GUA" and cob_codentidad=484,1,0)) as gua484, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=945,1,0)) as amb945, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=948,1,0)) as amb948, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=484,1,0)) as amb484  ; 
 from agrupo into cursor totalgr
select totalgr
copy to totabrgr type xls

mfecdes = ctod("01/05/2004")
mfechas = ctod("31/05/2004")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,pac_codhce,"+;
	" val_tipopaciente ,cob_codentidad,pia_cantsolicitada " + ;
	",VAL_circuitoorigen,VAL_prestador,pia_valesasist,pia_secuen_carga "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale in ( 2200, 8900 ) and val_tipopaciente = 'AMB' " + ;
	" and pia_codprest in ( 42010115, 42010184,42030338,46010187 ) " + ;
	" order by val_fechasolicitud, val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select * from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce into cursor agrupo

select val_prestador , VAL_circuitoorigen,count (pac_codhce) as pacientes ;
 from mwktodogua1 group by val_prestador,VAL_circuitoorigen into cursor total
select total
copy to totmay type xls
select sum(iif(val_tipopaciente="GUA" and cob_codentidad=945,1,0)) as gua945, ;
 sum(iif(val_tipopaciente="GUA" and cob_codentidad=948,1,0)) as gua948, ; 
sum(iif(val_tipopaciente="GUA" and cob_codentidad=484,1,0)) as gua484, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=945,1,0)) as amb945, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=948,1,0)) as amb948, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=484,1,0)) as amb484  ; 
 from agrupo into cursor totalgr
select totalgr
copy to totmaygr type xls

mfecdes = ctod("01/06/2004")
mfechas = ctod("30/06/2004")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,pac_codhce,"+;
	" val_tipopaciente ,cob_codentidad,pia_cantsolicitada " + ;
	",VAL_circuitoorigen,VAL_prestador,pia_valesasist,pia_secuen_carga "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale in ( 2200, 8900 ) and val_tipopaciente = 'AMB' " + ;
	" and pia_codprest in ( 42010115, 42010184,42030338,46010187 ) " + ;
	" order by val_fechasolicitud, val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select * from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce into cursor agrupo

select val_prestador , VAL_circuitoorigen,count (pac_codhce) as pacientes ;
 from mwktodogua1 group by val_prestador,VAL_circuitoorigen into cursor total
select total
copy to totjun type xls
select sum(iif(val_tipopaciente="GUA" and cob_codentidad=945,1,0)) as gua945, ;
 sum(iif(val_tipopaciente="GUA" and cob_codentidad=948,1,0)) as gua948, ; 
sum(iif(val_tipopaciente="GUA" and cob_codentidad=484,1,0)) as gua484, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=945,1,0)) as amb945, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=948,1,0)) as amb948, ; 
sum(iif(val_tipopaciente="AMB" and cob_codentidad=484,1,0)) as amb484  ; 
 from agrupo into cursor totalgr
select totalgr
copy to totjungr type xls

mfecdes = ctod("01/07/2005")
mfechas = ctod("31/07/2005")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,pac_codhce,"+;
	" val_tipopaciente ,cob_codentidad,pia_cantsolicitada " + ;
	",VAL_circuitoorigen,VAL_prestador,pia_valesasist,pia_secuen_carga "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale in ( 2200, 8900 ) and val_tipopaciente = 'AMB' " + ;
	" and pia_codprest in ( 42010115, 42010184,42030338,46010187 ) " + ;
	" order by val_fechasolicitud, val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select * from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce into cursor agrupo

select val_prestador , VAL_circuitoorigen,count (pac_codhce) as pacientes ;
 from mwktodogua1 group by val_prestador,VAL_circuitoorigen into cursor total
select total
copy to totjul type xls
set step on
