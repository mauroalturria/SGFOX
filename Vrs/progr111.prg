*
*
*/
XXXXX *
do sp_conexion

mret = sqlexec(mcon1, "SELECT f.titulo,c.codmed, A.nombre,C.diasem,C.horadesde, " + ;
			"C.horahasta, c.fecvigend,C.fecvigenh,E.ESP_descripcion " + ; 
 			"FROM Prestadores AS A, Medpresta AS C, Especialid AS E, TabProfesion AS F " + ;
 			"WHERE A.Id=C.Codmed AND trim(E.ESP_Codesp)=C.Codesp " + ;
 				"AND A.codprof=F.id AND NOT c.diasem is Null and " + ;
 				"fecvigenh > to_date('01/11/2003','dd/mm/yyyy') " + ;
 			"GROUP BY c.codmed,c.diasem,c.horadesde,c.horahasta,C.codesp,C.fecvigend,C.fecvigenh " + ; 	                  
			"ORDER BY A.Nombre,C.Diasem,C.Horadesde,E.ESP_descripcion,C.fecvigend ", "mwktodos")
			
mret = sqlexec(mcon1, "select franjahoraria.*, " + ;
				"{fn convert(horadesde, sql_time)} as horad, " + ;
				"{fn convert(horahasta, sql_time)} as horah, " + ;
				"abrevio from franjahoraria, tabtipofranja "  + ;
				"where tiposervicio = tabtipofranja.id", "mwkfranja")			


select t.*, abrevio,  f.fecvigend as fecd, f.fecvigenh as fech ;
from mwktodos as t left outer join mwkfranja as f on ;
	t.codmed = f.codmed and t.diasem = f.diasem and ;
	t.horadesde = f.horad and t.horahasta = f.horah and ;
	t.fecvigend = f.fecvigend and t.fecvigenh = f.fecvigenh ;
into cursor mwkmirof	

=sqldisconnect(mcon1)