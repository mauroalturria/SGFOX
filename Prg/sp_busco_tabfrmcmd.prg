****
** busco los cmd
****

parameter nf, msql_cmd1, msql_cmd2, mcodfrm, mcodsec

	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "select tabcmdfrm.* from tabcmdfrm " + ;
				"where tabcmdfrm.id not in(select tabfrmcmd.codcmd " + ;
				"from tabfrmcmd " + ;
				"where tabfrmcmd.codfrm = ?mcodfrm and " + ;
				"tabfrmcmd.fecpasiva = ?mfecpas and tabfrmcmd.codsector = ?mcodsec) " + ;
				" group by cmdnombre order by cmdnombre", "mwkcmd33"+nf)

	mret = sqlexec(mcon1, "select tabcmdfrm.id, cmdnombre,cmdinv " + ;
							"from tabfrmcmd, tabcmdfrm " + ;
							"where codfrm = ?mcodfrm and " + ;
								"codcmd = tabcmdfrm.id and codsector = ?mcodsec and " + ;
								"tabfrmcmd.fecpasiva = ?mfecpas " + ;
							"order by cmdnombre", "mwkcmd44"+nf)
						
	msql_cmd1 = 'select cmdnombre,iif(cmdinv=1,"INV","   "), id from mwkcmd33'+nf+' into cursor mwkcmd3'+nf

	msql_cmd2 = 'select cmdnombre,iif(cmdinv=1,"INV","   "), id from mwkcmd44'+nf+' into cursor mwkcmd4'+nf
	
