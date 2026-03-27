Parameters admision, hclinica, tnCodVale

* --- Para prueba ---
*!*	Do sp_conexion
*!*	hclinica = "4087657-6"
*!*	admision = "640229-1"
*!*	Set Step On
* ------------------------------

lchclinica = hclinica

If !Vartype(tnCodVale)="N"
	tnCodVale = 0
Endif 

If !Vartype(admision)="C"
	lcadmision = ""
Else
	If Empty(admision)
		lcadmision = ""
	Else
		lcadmision = admision
	Endif
Endif

lcHC = "where ZDP_fechapasiva = '1900-01-01' and ZDP_hclinica = '"+Alltrim(lchclinica)+"'"


&& pregunta para Fabian porque recortar por admision al final ??????

*!*	lcHC2 = ""
*!*	If tnCodVale > 0
*!*		lcHC2 = " and ZDP_codvale = ?tnCodVale "
*!*	Endif 


lcsql = "SELECT ID, CodAmbito, FecHorDbAdd, FecHorDbUpd, UserDbAdd, UserDbUpd, ZDP_admision, ZDP_Binario, ZDP_fechacarga, ZDP_fechadocu, "+;
	"ZDP_fechapasiva, ZDP_fechavigencia, ZDP_hclinica, ZDP_observaciones, ZDP_sector, ZDP_tipoarch, ZDP_tipodoc, ZDP_usuariocarga, ZDP_usuariopasiva, "+;
	"cast(0000 as integer) as ZDP_codvale " + ;
	"FROM SQLUser.ZabDocuPac " + lcHC

If !Prg_EjecutoSql(lcsql,'mwkZabDocuPac')
	Return 0
Endif


lcsql = "SELECT ID, CodAmbito, FecHorDbAdd, FecHorDbUpd, UserDbAdd, UserDbUpd, ZDP_admision, ZDP_nombrearch, ZDP_fechacarga, ZDP_fechadocu, "+;
	"ZDP_fechapasiva, ZDP_fechavigencia, ZDP_hclinica, ZDP_observaciones, ZDP_sector, ZDP_tipoarch, ZDP_tipodoc, ZDP_usuariocarga, ZDP_usuariopasiva, "+;
	"ZDP_codvale " + ;
	"FROM ZabDocuPac2 " + lcHC 

If !Prg_EjecutoSql(lcsql,'mwkZabDocuPac2')
	Return 0
Endif


Select Id, CodAmbito, FecHorDbAdd, FecHorDbUpd, UserDbAdd, UserDbUpd, ZDP_admision, ZDP_fechacarga, ZDP_fechadocu,;
	ZDP_fechapasiva, ZDP_fechavigencia, ZDP_hclinica, ZDP_observaciones, ZDP_sector, ZDP_tipoarch, ZDP_tipodoc, ZDP_usuariocarga, ZDP_usuariopasiva,;
	1 As Tabla, ZDP_codvale From mwkZabDocuPac ;
	union ;
	SELECT Id, CodAmbito, FecHorDbAdd, FecHorDbUpd, UserDbAdd, UserDbUpd, ZDP_admision, ZDP_fechacarga, ZDP_fechadocu,;
	ZDP_fechapasiva, ZDP_fechavigencia, ZDP_hclinica, ZDP_observaciones, ZDP_sector, ZDP_tipoarch, ZDP_tipodoc, ZDP_usuariocarga, ZDP_usuariopasiva,;
	2 As Tabla, ZDP_codvale From mwkZabDocuPac2 ;
	into Cursor mwkDocuPac_0 Readwrite


If Len(lcadmision)>0
	lcsql = "Select * From mwkDocuPac_0 Where ZDP_admision = '" + lcadmision + "' into cursor mwkDocuPac Readwrite"
	&lcsql
Else
	Select * From mwkDocuPac_0 Into Cursor mwkDocuPac Readwrite
Endif


