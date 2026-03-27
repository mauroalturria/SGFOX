*
* Historial de Consultas
*
Lparameters mnrohcl,mnroreg,mint,mgua,mamb,mdesde,mhasta

miduser = mwkusuario.idusuario
mfechac = sp_busco_fecha_serv('DT')

mret = sqlexec(mcon1,"insert into TabConHis(TCH_nrohclinica,TCH_nroregistrac,TCH_fechapedido,"+;
	"TCH_int,TCH_amb,TCH_gua,TCH_fecdesde,TCH_fechasta,TCH_idusuario) "+;
	"values(?mnrohcl,?mnroreg,?mfechac,?mint,?mgua,?mamb,?mdesde,?mhasta,?miduser)")

If mret < 0
	Messagebox("EN EL REGISTRO HISTORICO DE LA CONSULTA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

