MODIFY PROJECT c:\desaguemes\prj\quirofano.pjx
SELECT 15
BROWSE LAST
select * from quiroespserv where transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+nvl(codesp,"    ") not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)
copy to para arreglar
copy to para_arreglar type xls
select * from quiroespserv where transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+nvl(codesp,"    ") not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)
copy to para_arreglar type xl5
SELECT 12
BROWSE LAST
select * from quiroespserv where transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)
select * from quiroespserv where transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4) order by fechaquirof,pacnombre
select * from quiroespserv where transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4) order by fechaquirof,pacnombre and codmed>1
select * from quiroespserv where transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4) and codmed>1 order by fechaquirof,pacnombre
select * from quiroespserv where transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4) and codmed>1 order by fechaquirof,pacnombre into cursor algo
BROWSE LAST
copy to para_arreglar type xl5
select * from quiroespserv where codmed> 1 and (transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)) order by fechaquirof,pacnombre into cursor algo
BROWSE LAST
copy to para_arreglar type xl5
select * from quiroespserv where codmed> 1 and (transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)) order by fechaquirof,pacnombre into cursor algo
BROWSE LAST
copy to para_arreglar type xl5
select * from quiroespserv where codmed> 1 and (transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)) order by fechaquirof,nroquirof,pacnombre into cursor algo
select * from quiroespserv where codmed> 1 and (transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)) order by fechaquirof,nroquirofano,pacnombre into cursor algo
BROWSE LAST
copy to para_arreglar type xl5
requery('vista4')
requery('vista5')
select * from quiroespserv where codmed> 1 and (transf(codmed,"9999")+transf(servicio,"9999") not in ;
	(select transf(codprof,"9999")+transf(codserv,"9999") from vista5) or ;
	transf(codmed,"9999")+alltrim(nvl(codesp,"    ")) not in;
	(select transf(codprof,"9999")+alltrim(codiesp) from vista4)) order by fechaquirof,nroquirofano,pacnombre into cursor algo
BROWSE LAST
SELECT 12
BROWSE LAST