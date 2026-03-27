SELECT * FROM TURNOpac where inlist(codesp,"CARD","CARI","CLIN","DERM",:
	"DERI","DIAB","DIAI","ENDC","ENDI","FLEB","GASI","GAST","GINE",;
	"HEMA","HEMI","INFE","NEFR","NEFI","NEUM","NEUI","NEUC","NECI",;
	"NEUR","NEIN","OFTA","OFTI","PEDI","UROL") into cursor control

SELECT 1
SELECT 4
select * from control group by afiliado,codmed,codprest,fechatur into cursor control2
SELECT 4
select * from control group by afiliado,codmed,fechatur into cursor control2
select * from control group by afiliado,codmed,codprest,fechatur into cursor control2
select * from control group by afiliado,codmed,fechatur into cursor control2
select * from control group by afiliado,codmed,codprest,fechatur into cursor control2
select * from control group by afiliado,codmed,fechatur into cursor control2
select count(*) as varios,* from TURNOSDOBLE group by afiliado,codesp into cursor controlvarios
BROWSE LAST
select * from control2 where codesp+transf(afiliado,"99999999") in;
	(select codesp+transf(afiliado,"99999999") from controlvarios where varios>1) ;
	into cursor masdeuno
BROWSE LAST
copy to varios type xl5
select count(*) as varios,* from TURNOSDOBLE group by afiliado,PRE_especialidad into cursor controlvariosESP
select * from TURNOSDOBLE where PRE_especialidad+transf(afiliado,"99999999") in;
	(select PRE_especialidad+transf(afiliado,"99999999") from controlvariosESP where varios>1) ;
	ORDER BY PRE_especialidad,REG_NOMBREPAC;
	into cursor masdeuno

select count(*) as varios,* from TURNOSDOBLE ;
	group by afiliado,PRE_descriprest into cursor controlvariosESP
select * from TURNOSDOBLE where PRE_descriprest+transf(afiliado,"99999999") in;
	(select PRE_descriprest+transf(afiliado,"99999999") ;
	from controlvariosESP where varios>1) ;
	ORDER BY REG_NOMBREPAC;
	into cursor masdeuno

PRE_descriprest
