Set Enginebehavior 70
do sp_conexion
FECHA= date()-7

mret = sqlexec(mcon1, "SELECT Turnos.*,"+;
	"  Registracio.REG_nombrepac, Registracio.REG_nrohclinica,"+;
	"  Prestacions.PRE_descriprest,"+;
	"  Prestacions.PRE_especialidad, Registracio.REG_sexo "+;
	" FROM SQLUser.Turnos Turnos, SQLUser.REGISTRACIO Registracio,"+;
	"  SQLUser.PRESTACIONS Prestacions"+;
	" WHERE Registracio.REG_nroregistrac = Turnos.afiliado"+;
	"   AND Turnos.codprest = Prestacions.PRE_codprest"+;
	"   AND Turnos.fechatur >= ?FECHA"+;
	"   AND Prestacions.PRE_codservicio in (2200)"+;
	"   AND Prestacions.PRE_especialidad NOT IN ('KINE','PSIC','AUDI','FONI') "+;
	" GROUP BY Turnos.afiliado, Turnos.codreserva, Turnos.fechatur, Turnos.codprest","turnosdobles")

USE c:\desaguemes\control_20100.dbf IN 0 SHARED
SELECT 3
BROWSE LAST

select * from turnosdobles into cursor acontrolar
select * from turnosdobles where alltrim(codreserva)+dtos(fechatur) not in (select alltrim(codreserva)+dtos(fechatur) from control_20100) ;
into cursor acontrolar
select * from acontrolar group by afiliado,codprest having count(codmed)>1 into cursor dobles

select * from acontrolar where transform(afiliado,"@L 9999999999")+transform(codprest ,"@L 9999999999") ;
	in (select transform(afiliado,"@L 9999999999")+transform(codprest ,"@L 9999999999")  from dobles );
	order by afiliado,codprest into cursor turdobles

copy to turnosdobles type xl5
copy to control_0804
