****
** Tablas para Quirofano
****

mfecturno = sp_busco_fecha_serv('DD')
mfecnull  = ctod("01/01/1900")

if used('mwkentidad1')
	use in mwkentidad1
endif

mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_fecpas,ENT_prepaga,ENT_tipo,ENT_codagrup, ENT_nroprestadorexterno from entidades " + ;
	"where ENT_fecpas is null " + ;
	"order by ENT_descrient", "mwkentidad1")

mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_fecpas,ENT_prepaga,ENT_tipo,ENT_codagrup, ENT_nroprestadorexterno  from entidades " + ;
	"order by ENT_descrient", "mwkentidadall")

if mret > 0
	mret = sqlexec(mcon1,"SELECT id, nombre,codesp FROM prestadores " + ;
		" WHERE (fecpasivap = ?mfecnull or fecpasivap > ?mfecturno) " + ;
		" ORDER BY nombre", "mwkmedicos" )
endif
do sp_busco_profserv with 0
do sp_busco_profesp with 0

mret = sqlexec(mcon1,"select * from TabEstados where propietario = 22 and tipo in (0,1,2,3) order by descrip", "mwkTabEstados")
if mret < 0
	messagebox("EN CONSULTA TABLA DE ESTADOS",16,"ERROR")
	cancel
endif

mret = sqlexec(mcon1,"select * from TabQuiroSala where TQS_habilitado=1 and TQS_Prog = 1 order by id", "mwkquisala")
if mret < 0
	=aerror(merror)
	messagebox("EN MAESTRO DE QUIROFANO/SALAS"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	cancel
endif
use in select("mwkPreregQui")
mret = sqlexec(mcon1," select id, nombre,codesp,codesp as codespe,matricula from TabMedExterno "+;
	"where gerenciadora = 222 order by nombre ","mwkPreregQui")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0

endif
do sp_busco_medrempzt with ctot("01/01/2015"),,,,"QUI"
SELECT * FROM mwkmedicogua INTO CURSOR mwkMedrpzt 