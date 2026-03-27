select * from turnoidpresta where !inlist(codesp,'KINE','PSIC','FONI','AUDI') INTO CURSOR turnolimp
select *,count(codesp) as cuantos  from turnolimp group by afiliado,fechatur,codesp into cursor turgr
select * from turnolimp group by afiliado,fechatur,codesp into cursor turgr
select *,count(codesp) as cuantos   from turgr group by afiliado,codesp into cursor turnodoble
BROWSE LAST
select *,count(codesp) as cuantos   from turgr group by afiliado,codesp order by cuantos desc into cursor turnodoble
BROWSE LAST
select * from turgr where alltrim(codesp)+alltrim(reg_nrohclinica) in (select alltrim(codesp)+alltrim(reg_nrohclinica) from turnodoble where cuantos>1) into cursor dosomas
select * from turgr where alltrim(codesp)+alltrim(reg_nrohclinica) in (select alltrim(codesp)+alltrim(reg_nrohclinica) from turnodoble where cuantos>2) into cursor tresomas
BROWSE LAST
SELECT 8
BROWSE LAST
copy to dosomas type xl5
SELECT 9
copy to tresomas type xl5
