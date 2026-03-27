select *,min(hhmmtur) as hini,max(hhmmtur) as hfin;
	 from turnoid where at(") |",observa)>0 ;
	 group by fechatur,codmed into cursor repro
select *,val(substr(observa,31,4)) as medori,substr(observa,19,5) as fechaori,;
	dow(fechatur) as dia;
	from turnoid where at(") |",observa)>0 ;
	into cursor turnoidr

select turnoidr.*,hhmmdes,hhmmhas from turnoidr left join medpresta ;
	on (turnoidr.codmed = medpresta.codmed and diasem = dia;
	and fecvigend<fechatur and fecvigenh>fechatur ;
	and hhmmtur>=hhmmdes and hhmmtur<hhmmhas);
	into cursor turnoi
select *,nvl(hhmmdes,0) as franjades from turnoi into cursor turnoii
select *,min(hhmmtur) as hini,max(hhmmtur) as hfin 	from turnoii;
	group by fechatur,codmed,hhmmdes into cursor repro
BROWSE LAST
select *,int(hini/100)+60+mod(hini,100) as minini,;
	int(hfin/100)+60+mod(hfin,100) as minfin ;
	from repro into cursor repro2
select *,val(substr(observa,31,4)) as medori,substr(observa,19,5) as fechaori,min(hhmmtur) as hini,max(hhmmtur) as hfin from turnoid where at(") |",observa)>0 group by fechatur,codmed into cursor repro
BROWSE LAST
select *,int(hini/100)+60+mod(hini,100) as minini,int(hfin/100)+60+mod(hfin,100) as minfin from repro into cursor repro2
BROWSE LAST
select *,int(hini/100)*60+mod(hini,100) as minini,;
	int(hfin/100)*60+mod(hfin,100) as minfin ;
	,int(franjades /100)*60+mod(franjades ,100) as mindes ;
	,int(hhmmhas/100)*60+mod(hhmmhas,100) as minhas ;
	,int(minini/60)*100+mod(minini,60) as hturd;
	,int(hfin/60)*100+mod(hfin,60) as hturh;
	from repro,prestadores where medori=id into cursor repro2
