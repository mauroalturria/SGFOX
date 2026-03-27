****
** busco los cmd
****

parameter nf,msql_cmd1, mnamefrm

mnamefrm = "%"+alltrim(mnamefrm)+"%"
mfecpas = ctod('01/01/1900')
mret = sqlexec(mcon1, "select cmdnombre, nomfrm,tabfrm.id " + ;
	"from tabcmdfrm " + ;
	" left join tabfrmcmd on tabfrmcmd.codcmd = tabcmdfrm.id " + ;
	" left join tabfrm on tabfrmcmd.codfrm = tabfrm.id " + ;
	"where cmdnombre like ?mnamefrm and " + ;
	"tabfrm.fecpasiva = ?mfecpas and " + ;
	"tabfrmcmd.fecpasiva = ?mfecpas " + ;
	"order by nomfrm", "mwkcmd55"+nf)


msql_cmd1 = 'select cmdnombre, nomfrm,id from mwkcmd55'+nf+' into cursor mwkcmd5'+nf

