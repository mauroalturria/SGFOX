parameters lcForm, lcCmd, lnIdUsua,mcursor

ldFecNull = ctod("01/01/1900")
if vartype(mcursor)#"C"
	mcursor = "mwkPerQui"
endif
lcSql = "select Distinct TabPermisosFrmCmd.codcmd " + ;
	"from TabPermisosFrmCmd " + ;
	"inner join Tabusuario on Tabusuario.id = TabPermisosFrmCmd.CodUsuario and  Tabusuario.id  = ?lnIdUsua " + ;
	"inner join  TabCmdFrm on  TabCmdFrm.Id = TabPermisosFrmCmd.codcmd and cmdnombre = ?lcCmd " + ;
	"inner join  TabFrm on  TabFrm.Id = TabPermisosFrmCmd.codfrm and nomfrm = ?lcForm " + ;
	"where TabPermisosFrmCmd.FecPasiva = ?ldFecNull "

if !Prg_EjecutoSql(lcSql,mcursor,.f.)
	return .f.
endif
