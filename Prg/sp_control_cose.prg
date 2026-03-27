*******************
* control control cobro coseguros
*******************
Parameters mfecdes, mfechas, vr_pvta

	mret = SQLExec(mcon1,"select id, descrip, sector from tabmotivos " , "mwkmotcose")
mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient, ENT_turnoshabilit,ent_capita ,ENT_tipo,ENT_nroprestadorexterno from entidades " + ;
	"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")
	mret=SQLExec(mcon1,"SELECT importeBono, importeCose, motivoIndiv, factura, Tabctrlcose.fechahora, motivoGlobal,"+;
		" b.aplinrocte, b.codent, Registracio.REG_nombrepac, Tabctrlcose.nroregistracio,"+;
		" Registracio.REG_nrohclinica, Registracio.REG_numdocumento,Tabctrlcosedet.codpun,"+;
		" Tabusuario.codigovax, Tabusuario.nomape, b.importe,b.nrovale, Tabctrlcose.descripcion"+;
		" FROM Tabctrlcose INNER JOIN TabCtrlCoseDet "+;
		" ON  Tabctrlcose.ID = idCab "+;
		"  INNER JOIN Tabusuario ON  usuario = Tabusuario.codigovax "+;
		"  INNER JOIN Registracio ON  Tabctrlcose.nroregistracio = REG_nroregistrac "+;
		"    LEFT OUTER JOIN Tabfacturas as b ON  (factura = b.nrocte and Tabctrlcose.nroregistracio = b.nroregistracio) "+;
		"  WHERE  Tabctrlcose.ID >= ( 6720004 ) "+;
		" AND Tabctrlcose.fechahora BETWEEN ?mfecdes AND ?mfechas  " ,"MWKFacturacion0")


If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR de Facturacion, REINTENTE",16, "Validacion")
	mret=0
	Cancel
Endif

