*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* en un rango de fechas 										*
*****************************************************************
Lparameters fechades,fechahas,ltodos

mfecnul 	= Ctot('01/01/1900')
mbusamb=''
If Vartype(ltodos)<>"N"
	mbusamb =' and dambula = 1  and (fecpasiva = ?mfecnul  or fecpasiva > ?fechades)  '
Endif

If Vartype(fechades)<>"D"
	fechades =  sp_busco_fecha_serv("DD")
ENDIF

If Vartype(fechahas)<>"D"
	fechahas = CTOD("01/01/2100")
Endif
mreempl = " union SELECT id, nombre,codesp,codespe,cast(matriculas as integer) as matricula,cast(0 as integer) as TPF_filtro    FROM prestadores  " + ;
	" WHERE id = 1059 "


mret = SQLExec(mcon1,"SELECT Prestadores.id, nombre,codesp,codespe,cast(matriculas as integer) as matricula,TPF_filtro   "+;
	" FROM prestadores  " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?fechades) " +mbusamb ,"mwkmed01")

mret = SQLExec(mcon1," SELECT ID , nombre,cast('    ' as char(4))  as codesp,gerenciadora  as codespe,matricula,cast(0 as integer) as TPF_filtro  FROM TabMedExterno " + ;
	" where fechaIngreso >= ?fechades and fechaIngreso <= ?fechahas and not gerenciadora in ( 0,373) "+ mreempl,"mwkmed02")

Select * From mwkmed01 ;
	union Select Id , Alltrim(nombre)+" (R)" As nombre,codesp,codespe,matricula,0 as TPF_filtro    ;
	from mwkmed02 Into Cursor mwkmed
Select * From mwkmed Order By nombre Into Cursor mwkmedicoamb

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do sp_desconexion With "Err sp_medicos"
	Cancel
Endif
