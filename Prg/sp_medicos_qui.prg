*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo.                  *
*****************************************************************
Lparameters tdfechadia

If Type ('tdfechadia') = "D"
	ldFecPass = tdfechadia
Else
	ldFecPass = sp_busco_fecha_serv('DD')
Endif

ldNull  = cTod("01/01/1900")

*!*	mccpoamb = ''
*!*	If mxambito >1
*!*		mccpoamb = "  and codambito = ?mxambito "
*!*	Endif


lcSql = "select TabUsuario.CodigoVax, Prestadores.*, Cast(0  as Integer)as tpf_filtro " + ;
	"from Prestadores " + ;
	"Inner join TabUsuario on IdCodMed = Prestadores.Id and IdCodMed > 1 " + ;
	"Inner join tabpermisosexe on tabpermisosexe.codusuario = tabusuario.id and " + ;
		"CodExe = 22 and tabpermisosexe.FecPasiva = ?ldNull " + ;
	"Where (fecpasivap = ?ldNull or fecpasivap >= ?ldFecPass) " 

if !Prg_EjecutoSql(lcSql,"mwkmed",.f.)
	Return .f.
Endif 


Select * From mwkmed Order By nombre Into Cursor mwkmedi
If Used('mwkmedicoQui')
	Use In mwkmedicoQui
Endif
Use Dbf('mwkmedi') Again In 0 Alias mwkmedicoQui
