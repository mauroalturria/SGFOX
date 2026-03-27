****
** busco los cmd
****

parameter nf,msql_cmd1, msql_cmd2, mcoduser, mcodfrm, mcodsec

mfecpas = ctod('01/01/1900')
mret = sqlexec(mcon1, "select tabcmdfrm.* from tabfrmcmd " + ;
	"left join tabcmdfrm on tabcmdfrm.id = tabfrmcmd.codcmd " + ;
	"where tabfrmcmd.codcmd not in(select codcmd " + ;
	"from tabpermisosfrmcmd " + ;
	"where codusuario = ?mcoduser and codfrm = ?mcodfrm and " + ;
	"fecpasiva = ?mfecpas and codsector = ?mcodsec) AND tabfrmcmd.CODFRM=?mcodfrm  " + ;
	"GROUP  by cmdnombre order by cmdnombre", "mwkcmd33"+nf)

mret = sqlexec(mcon1, "select tabcmdfrm.id,cmdinv, cmdnombre " + ;
	"from tabpermisosfrmcmd, tabcmdfrm " + ;
	"where codusuario  = ?mcoduser and codfrm = ?mcodfrm and " + ;
	"codcmd = tabcmdfrm.id and tabpermisosfrmcmd.codsector = ?mcodsec and " + ;
	"tabpermisosfrmcmd.fecpasiva = ?mfecpas " + ;
	"order by cmdnombre", "mwkcmd44"+nf)

msql_cmd1 = 'select cmdnombre,iif(cmdinv=1,"INV","   "), id from mwkcmd33'+nf+' into cursor mwkcmd3'+nf

msql_cmd2 = 'select cmdnombre,iif(cmdinv=1,"INV","   "), id from mwkcmd44'+nf+' into cursor mwkcmd4'+nf

