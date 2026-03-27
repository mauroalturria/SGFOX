*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
****************************************************************************
* Cursor de Impresion del listado de Medpresta
****************************************************************************
mret=sqlexec(mcon1,'SELECT F.Titulo,A.nombre,E.ESP_descripcion as Especialidad,C.diasem,C.horadesde,C.horahasta ' +;
	'FROM Prestadores AS A, Medpresta AS C, Especialid AS E, TabProfesion AS F ' +;
	'WHERE A.Id=C.Codmed AND trim(E.ESP_Codesp)=C.Codesp and a.estado=1 ' +;
	'AND A.codprof=F.id AND NOT c.diasem is Null AND c.Generaagen=1 ' + ;
	'GROUP BY c.codmed,E.ESP_descripcion,c.diasem,c.horadesde ' +;
	'ORDER BY E.ESP_descripcion,A.Nombre,C.Diasem,C.Horadesde ','MwkListaMedPrest')

if mret < 0
	messagebox('ERROR EN EL CURSOR DE IMPRESION',64,'Validación')
	mret=0

endif
