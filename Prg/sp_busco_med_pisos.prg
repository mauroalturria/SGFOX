****
** Busco medicos de pisos con usuario medico
****
lparameters mfbaja
if vartype(mfbaja)="D"
	mwfecha = " and (fecpasivap = ?mfecnul or fecpasivap > ?mfechoy) and (fecpasivai = ?mfecnul  or fecpasivai > ?mfechoy) "
	mufecha = " and (tabusuario.fecpasiva = ?mfecnul  or tabusuario.fecpasiva > ?mfechoy) "
else
	mwfecha = " "
	mufecha = " "
endif
mfecnul = ctod("01/01/1900")
mfechoy = sp_busco_fecha_serv("DD")
mfeclim = mwkfecserv.fechahora -12*3600


if used("mwkMedicoint" )
	use in mwkMedicoint
endif

mret = sqlexec(mcon1,"SELECT prestadores.id, nombre,codesp,codespe,cast(matriculas as integer) as matricula " + ;
	",idcodmed,nomape,codigovax,idusuario "+;
	" FROM prestadores  " + ;
	" inner join tabusuario on Prestadores.id = tabusuario.idcodmed " + ;
	"WHERE prestadores.id>1  "+mwfecha +;
	mufecha+ ;
	" union  SELECT ID , nombre,codesp, gerenciadora  as codespe,matricula,id as idcodmed,nombre as nomape"+;
	",cast(0 as integer) as codigovax,cast('AUDITOR' as CHARACTER(20)) as idusuario "+;
	" FROM TabMedExterno " + ;
	" where gerenciadora = 200 " +;
	" union  SELECT TabMedExterno.ID , nombre,codesp, gerenciadora  as codespe,matricula,idcodmed,nomape"+;
	',codigovax,idusuario '+;
	" FROM TabMedExterno " + ;
	" inner join tabusuario on TabMedExterno.id = tabusuario.idcodmed " + ;
	" where  gerenciadora = 222 " +;
	"ORDER BY nombre", "mwkMedicoint" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif

