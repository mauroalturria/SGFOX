*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo.                  *
*****************************************************************
Lparameters fechadia,lxcentro,lmastecnico
If Vartype(lxcentro)<>"N"
	lxcentro=0
Endif

If Vartype(lmastecnico)<>"N"
	lmastecnico = 0
Endif
If Type ('fechadia')#"D"
	mfecturno	= sp_busco_fecha_serv('DD')
	mdiasem 	= Dow(mfecturno)
	mfecpasmsg 	= prg_dtoc(mfecturno)
	mfecnul 	= Ctot('01/01/1900')
	msegundos 	= 18 * 3600 && 12 horas por default
	mfeclim 	= MWKFecServ.fechaHora - msegundos
Else
	mfecturno	= fechadia
	mdiasem 	= Dow(mfecturno)
	mfecpasmsg 	= prg_dtoc(mfecturno)
	mfecnul 	= Ctot('01/01/1900')
	msegundos 	= 18 * 3600 && 12 horas por default
	mfeclim 	= fechadia
Endif
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
Endif
mcfiltraxcentro = ''
mcfiltraxcentror = ''
mcfiltraxcm= ''
If myip = '172.16.1.7'
 SET STEP ON
Endif
If Vartype(mxcentromedico )="N" And lxcentro=1
	mcfiltraxcentro = " and centromed = ?mxcentromedico  "
	mcfiltraxcentror = " and (ambcentror= ?mxcentromedico or ambcentror is null)  "
	mcfiltraxcm = ' UNION ALL SELECT * FROM mwkmed01 WHERE id = 1 OR NVL(TPF_filtro ,0)=1 '
Endif
mfecreemp	= mfecturno	+ 1
mreempl = " union SELECT Prestadores.id, nombre,codesp,codespe,cast(matriculas as integer) as matricula, TPF_filtro,dni " + ;
	" FROM Prestadores " + ;
	" inner join TabProfFiltro on (Prestadores.id = TabProfFiltro.TPF_codmed and TabProfFiltro.tpf_filtro = 2) "

mret = SQLExec(mcon1,"select codmed,bloquedesde, bloquehasta,centromed "+;
	"From FranjaHoraria,prestadores " +;
	" where FranjaHoraria.codmed = prestadores.id and diasem = ?mdiasem and" +;
	" fecvigenh > ?mfecturno and fecvigend <= ?mfecturno and" +;
	" fecvigenh <> fecvigend  "+mccpoamb+ mcfiltraxcentro ,"mwkmedhab")


mret = SQLExec(mcon1,"SELECT Prestadores.id, nombre,codesp,codespe,cast(matriculas as integer) as matricula,  TPF_filtro,dni  " + ;
	" FROM Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecturno) and  dambula = 1  and " +;
	"(fecpasiva = ?mfecnul  or fecpasiva > ?mfecturno) " ,"mwkmed01")
mret = SQLExec(mcon1,"SELECT Prestadores.id, nombre,codesp,codespe,cast(matriculas as integer) as matricula,  TPF_filtro,dni  " + ;
	" FROM Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecturno) and  dambula = 1  and codprof = 3 and " +;
	"(fecpasiva = ?mfecnul  or fecpasiva > ?mfecturno) " ,"mwktec01")

mret = SQLExec(mcon1," SELECT TabMedExterno.ID , TabMedExterno.nombre,cast('    ' as char(4))  as codesp,"+;
	"gerenciadora  as codespe,TabMedExterno.matricula,cast(0 as integer) as TPF_filtro,TabMedExterno.matricula as dni,prestadores.nombre as nomrplzo"+;
	" FROM TabMedExterno left join prestadores on gerenciadora = prestadores.id " + ;
	" where TabMedExterno.fechaIngreso >= ?mfeclim and TabMedExterno.fechaIngreso <= ?mfecreemp "+mcfiltraxcentror +;
	" and TabMedExterno.matricula>0 and not gerenciadora in ( 0,222,373)"+;
	" group by ambcentror,TabMedExterno.fechaIngreso ,TabMedExterno.matricula,gerenciadora,TabMedExterno.hhmmDesr  " ,"mwkmed02e")
mret = SQLExec(mcon1," SELECT Prestadores.id, nombre,codesp,codespe,cast(matriculas as integer) as matricula, TPF_filtro,dni " + ;
	" FROM Prestadores " + ;
	" inner join TabProfFiltro on (Prestadores.id = TabProfFiltro.TPF_codmed and TabProfFiltro.tpf_filtro = 2) ","mwkmed02i")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do sp_desconexion With "Err sp_medicos"
	Cancel
Endif
Select Id , Left(Alltrim(Left(nombre,30))+" (R-"+Left(nomrplzo,10)+")",40) As nombre,codesp,codespe,matricula,TPF_filtro,dni    ;
	from mwkmed02e Union All Select * From  mwkmed02i Into Cursor mwkmed02
mret = SQLExec(mcon1," SELECT * FROM TabMedExterno " + ;
	" where fechaIngreso >= ?mfeclim and fechaIngreso <= ?mfecreemp "+mcfiltraxcentror +;
	" and matricula>0 and not gerenciadora in ( 0,222,373) group by ambcentror,fechaIngreso ,matricula,gerenciadora,hhmmDesr  " ,"mwkmedexter02")
If lxcentro=0
	Select * From mwkmed01 ;
		where Id In (Select codmed From mwkmedhab Where !Between(mfecturno,bloquedesde, bloquehasta) ) ;
		union All Select Id ,nombre,codesp,codespe,matricula,TPF_filtro,dni    ;
		from mwkmed02 Into Cursor mwkmed
Else

	Select * From mwkmed01 ;
		where Id In (Select codmed From mwkmedhab Where !Between(mfecturno,bloquedesde, bloquehasta)  ) ;
		union All Select Id , nombre,codesp,codespe,matricula,TPF_filtro,dni    ;
		from mwkmed02 ;
		UNION All Select * From mwkmed01 Where Id = 1 Or Nvl(TPF_filtro ,0)=1 ;
		UNION All Select * From mwktec01  ;
		Into Cursor mwkmed

Endif
Select * From mwkmed Order By nombre,Id Desc Into Cursor mwkmedi
If Used('mwkmedicoamb')
	Use In mwkmedicoamb
Endif
Use Dbf('mwkmedi') Again In 0 Alias mwkmedicoamb
