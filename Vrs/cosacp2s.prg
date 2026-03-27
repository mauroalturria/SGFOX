public mcon3
do sp_conexion_tablas

mfecdes = ctod("01/07/2004")
mfechas = ctod("31/07/2004")

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

mfecdes = ctod("01/08/2004")
mfechas = ctod("31/08/2004")

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
copy to totago type xls

mfecdes = ctod("01/09/2004")
mfechas = ctod("30/09/2004")

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
copy to totsep type xls

mfecdes = ctod("01/10/2004")
mfechas = ctod("31/10/2004")

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
copy to totoct type xls

mfecdes = ctod("01/11/2004")
mfechas = ctod("30/11/2004")

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
copy to totnov type xls


mfecdes = ctod("01/12/2004")
mfechas = ctod("31/12/2004")

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
copy to totdic type xls

close all

