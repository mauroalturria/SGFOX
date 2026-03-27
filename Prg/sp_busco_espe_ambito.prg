Parameters tbFecha
*******************************
* AUTOR:Yo
* FECHA:30/08/2013
*******************************

Use in select("mwkespecial")

mccpoamb = ''
if mxambito > 1
	mccpoamb = " and codambito = ?mxambito "
Endif


If tbFecha

	mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion, " + ;
		"CAST(case ESP_turnobloqueo When 1 Then '11:00 hs.' Else '15:00 hs.' end as char(9)) as Habilito  " + ;
			 "FROM especialid " + ;
			 "inner join " + ;
			 "(select distinct codesp from turnos where " + ;
			 	"exists(select 1 from turnos where fechatur >= {fn CURDATE()} &mccpoamb ) and fechatur >= {fn CURDATE()} " + ;
			 	"&mccpoamb ) as medp on trim(ESP_codesp) = medp.codesp " + ;
			 "WHERE  exists(select 1 from especialid where ESP_descripcion is not Null and ESP_genagendaturno <>'N' ) and " + ;
			 "ESP_descripcion is not Null and ESP_genagendaturno <>'N' " + ;
			 "ORDER BY ESP_descripcion ","MWKespecial")

	if mret < 0
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
		mret=0	
		Return .f.
	Else
		Return .t.
	Endif

Endif 

mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion, CAST(case ESP_turnobloqueo When 1 Then '11:00 hs.' Else '15:00 hs.' end as char(9)) as Habilito  " + ;
		 "FROM especialid " + ;
		 "inner join (select distinct codesp from medpresta where fecvigend <> fecvigenh and diasem is not Null " + ;
		 	"&mccpoamb ) as medp on trim(ESP_codesp) = medp.codesp " + ;
		 "WHERE ESP_descripcion is not Null and ESP_genagendaturno <>'N' " + ;
		 "ORDER BY ESP_descripcion ","MWKespecial")
 
if mret < 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
	mret=0	
	Return .f.
Endif


