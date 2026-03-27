select codigo,CHRTRAN(upper(codicie.descrip),"аимсз","AEIOU") as nueva,codcie10,tabcie10 .descrip ;
 from codicie LEFT JOIN tabcie10 ON alltrim(codigo)=alltrim(codcie10)
SELECT 7
BROWSE LAST
select codigo,CHRTRAN(upper(codicie.descrip),"аимсз","AEIOU") as nueva,codcie10,tabcie10 .descrip ;
 from codicie LEFT JOIN tabcie10 ON alltrim(codigo)=alltrim(codcie10)
select codigo,CHRTRAN(upper(codicie.descrip),"аимсз","AEIOU") as nueva,codcie10,tabcie10 .descrip,codicie.descrip as descripcion ;
 from codicie LEFT JOIN tabcie10 ON alltrim(codigo)=alltrim(codcie10) INTO CURSOR CAMBIOS
BROWSE LAST
SELECT * FROM CAMBIOS WHERE NUEVA#DESCRIP
COPY TO CAMBIOS TYPE XLS
select * from cambios where codigo not in (select codigo from tabciap2e) into cursor agrego
select codigo,1 as componente,'' as criterio,descrip as descrabrev, descripcion,'' as excluye,;
	ctod("01/01/1900") as fecanula,'' as incluye from agrego into cursor nuevos
	
select ('tabciap2e')
append from dbf('nuevos')
	