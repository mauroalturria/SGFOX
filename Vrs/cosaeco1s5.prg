public mcon3
do sp_conexion_tablas


mfecdes = ctod("01/01/2005")
mfechas = ctod("31/01/2005")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,"+;
	" val_tipopaciente ,val_horasolicitud,pia_cantsolicitada " + ;
	" ,pia_valesasist,pia_secuen_carga,pac_codhce "+;
	",VAL_circuitoorigen,pia_codprest "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale =7900 and val_tipopaciente in ('AMB','GUA','INT') " + ;
	" order by val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select *,left(val_horasolicitud,2) as hora1,cdow(val_fechasolicitud) as dia  ;
from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce;
where not (dow(val_fechasolicitud)>=2 and dow(val_fechasolicitud)<=6 ;
	and val_horasolicitud>'08.00' and val_horasolicitud<'20.00' );
	 into cursor agrupo

select val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
 from agrupo group by val_tipopaciente,hora1 into cursor total

select dia,val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes  ;
,dow(val_fechasolicitud) as ndia from agrupo group by dia,val_tipopaciente,hora1 into cursor totald

select total
copy to ecoene5 type xls
select totald
copy to ecoene5d type xls

mfecdes = ctod("01/02/2005")
mfechas = ctod("28/02/2005")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,"+;
	" val_tipopaciente ,val_horasolicitud,pia_cantsolicitada " + ;
	" ,pia_valesasist,pia_secuen_carga,pac_codhce "+;
	",VAL_circuitoorigen,pia_codprest "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale =7900 and val_tipopaciente in ('AMB','GUA','INT') " + ;
	" order by val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select *,left(val_horasolicitud,2) as hora1,cdow(val_fechasolicitud) as dia  ;
from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce;
where not (dow(val_fechasolicitud)>=2 and dow(val_fechasolicitud)<=6 ;
	and val_horasolicitud>'08.00' and val_horasolicitud<'20.00' );
	 into cursor agrupo

select val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
 from agrupo group by val_tipopaciente,hora1 into cursor total

select dia,val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
,dow(val_fechasolicitud) as ndia from agrupo group by dia,val_tipopaciente,hora1 into cursor totald

select total
copy to ecofeb5 type xls
select totald
copy to ecofeb5d type xls

mfecdes = ctod("01/03/2005")
mfechas = ctod("31/03/2005")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,"+;
	" val_tipopaciente ,val_horasolicitud,pia_cantsolicitada " + ;
	" ,pia_valesasist,pia_secuen_carga,pac_codhce "+;
	",VAL_circuitoorigen,pia_codprest "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale =7900 and val_tipopaciente in ('AMB','GUA','INT') " + ;
	" order by val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select *,left(val_horasolicitud,2) as hora1,cdow(val_fechasolicitud) as dia  ;
from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce;
where not (dow(val_fechasolicitud)>=2 and dow(val_fechasolicitud)<=6 ;
	and val_horasolicitud>'08.00' and val_horasolicitud<'20.00' );
	 into cursor agrupo

select val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
 from agrupo group by val_tipopaciente,hora1 into cursor total

select dia,val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
,dow(val_fechasolicitud) as ndia from agrupo group by dia,val_tipopaciente,hora1 into cursor totald

select total
copy to ecomar5 type xls
select totald
copy to ecomar5d type xls

mfecdes = ctod("01/04/2005")
mfechas = ctod("30/04/2005")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,"+;
	" val_tipopaciente ,val_horasolicitud,pia_cantsolicitada " + ;
	" ,pia_valesasist,pia_secuen_carga,pac_codhce "+;
	",VAL_circuitoorigen,pia_codprest "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale =7900 and val_tipopaciente in ('AMB','GUA','INT') " + ;
	" order by val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select *,left(val_horasolicitud,2) as hora1,cdow(val_fechasolicitud) as dia  ;
from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce;
where not (dow(val_fechasolicitud)>=2 and dow(val_fechasolicitud)<=6 ;
	and val_horasolicitud>'08.00' and val_horasolicitud<'20.00' );
	 into cursor agrupo

select val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
 from agrupo group by val_tipopaciente,hora1 into cursor total

select dia,val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
,dow(val_fechasolicitud) as ndia from agrupo group by dia,val_tipopaciente,hora1 into cursor totald

select total
copy to ecoabr5 type xls
select totald
copy to ecoabr5d type xls


mfecdes = ctod("01/05/2005")
mfechas = ctod("31/05/2005")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,"+;
	" val_tipopaciente ,val_horasolicitud,pia_cantsolicitada " + ;
	" ,pia_valesasist,pia_secuen_carga,pac_codhce "+;
	",VAL_circuitoorigen,pia_codprest "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale =7900 and val_tipopaciente in ('AMB','GUA','INT') " + ;
	" order by val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select *,left(val_horasolicitud,2) as hora1,cdow(val_fechasolicitud) as dia  ;
from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce;
where not (dow(val_fechasolicitud)>=2 and dow(val_fechasolicitud)<=6 ;
	and val_horasolicitud>'08.00' and val_horasolicitud<'20.00' );
	 into cursor agrupo

select val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
 from agrupo group by val_tipopaciente,hora1 into cursor total

select dia,val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
,dow(val_fechasolicitud) as ndia from agrupo group by dia,val_tipopaciente,hora1 into cursor totald

select total
copy to ecomay5 type xls
select totald
copy to ecomay5d type xls



mfecdes = ctod("01/06/2005")
mfechas = ctod("30/06/2005")

mret = sqlexec(mcon3, "select val_codservvale,val_fechasolicitud,"+;
	" val_tipopaciente ,val_horasolicitud,pia_cantsolicitada " + ;
	" ,pia_valesasist,pia_secuen_carga,pac_codhce "+;
	",VAL_circuitoorigen,pia_codprest "+;
	" from valesasist,presinsuvas  " + ;
	" left outer join coberturas on val_codadmision = cob_pacientes " + ;
	" left outer join pacientes on val_codadmision = pacientes.pacientes " + ;
	" where valesasist = pia_valesasist " + ;
	" and val_fechasolicitud between ?mfecdes and ?mfechas " + ;
	" and val_codservvale =7900 and val_tipopaciente in ('AMB','GUA','INT') " + ;
	" order by val_horasolicitud", "mwktodogua1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select *,left(val_horasolicitud,2) as hora1,cdow(val_fechasolicitud) as dia  ;
from mwktodogua1 group by pia_valesasist,pia_secuen_carga,pac_codhce;
where not (dow(val_fechasolicitud)>=2 and dow(val_fechasolicitud)<=6 ;
	and val_horasolicitud>'08.00' and val_horasolicitud<'20.00' );
	 into cursor agrupo

select val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
 from agrupo group by val_tipopaciente,hora1 into cursor total

select dia,val_tipopaciente,hora1 ,count (pia_cantsolicitada) as pacientes ;
,dow(val_fechasolicitud) as ndia from agrupo group by dia,val_tipopaciente,hora1 into cursor totald

select total
copy to ecojun5 type xls
select totald
copy to ecojun5d type xls


