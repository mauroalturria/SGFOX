**********
*** Busco cie10 por sector
**********
Lparameters mopc, mcodagr,mcodsec

Use In Select("mwkCiediagSec")
mfecnul = Ctod("01/01/1900")

Do Case
Case mopc = 1 &&&consulta
	mret = SQLExec(mcon1, "select  TabCiap2E.ID , Codigo , Componente , Criterio , "+;
		"DescrAbrev , Descripcion , Excluye , Incluye,fecanula,Zabintdiagsec.DS_patologia "+;
		" from  TabCiap2E,tabcie10,Zabintdiagsec  where Codigo= codcie10 and tabcie10.id = Zabintdiagsec.Ds_codcie10  "+;
		"  and (ds_sector= ?mcodsec or ds_agrupamiento=?mcodagr) and DS_fecpasiva=?mfecnul  ", "mwkCiediagSeca")
	Select  Id , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula,DS_patologia ;
		from  mwkCiediagSeca Where fecanula = Ctod('01/01/1900') Order By DescrAbrev  Into Cursor mwkCiediagSec
Case mopc = 2 &&& para habilitar opcion de busqueda
	mret = SQLExec(mcon1, "select top 1 * "+;
		" from  Zabintdiagsec  where (ds_sector= ?mcodsec or ds_agrupamiento=?mcodagr) and DS_fecpasiva=?mfecnul  ", "mwkCiediagSeca")

	Select * From  mwkCiediagSeca Into Cursor mwkCiediagSec
Endcase
