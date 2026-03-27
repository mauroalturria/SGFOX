Parameters lcForm, lcCmd, lnIdMed

ldFecNull = Ctod("01/01/1900")

lcSql = "select Distinct TabPermisosFrmCmd.codcmd " + ;
	"from TabPermisosFrmCmd " + ;
	"inner join Tabusuario on Tabusuario.id = TabPermisosFrmCmd.CodUsuario and  IDCodMed = ?lnIdMed " + ;
	"inner join  TabCmdFrm on  TabCmdFrm.Id = TabPermisosFrmCmd.codcmd and cmdnombre = ?lcCmd " + ;
	"inner join  TabFrm on  TabFrm.Id = TabPermisosFrmCmd.codfrm and nomfrm = ?lcForm " + ;
	"where TabPermisosFrmCmd.FecPasiva = ?ldFecNull AND IDCodMed > 1" 

if !Prg_EjecutoSql(lcSql,"mwkPerQui",.f.)
	Return .f.
Endif 