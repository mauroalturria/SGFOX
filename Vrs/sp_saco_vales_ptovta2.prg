****
**
****


DO SP_CONEXION

MRET = sqlexec(mcon1, "SELECT a.*, b.abrevio, reg_nombrepac " + ;
 						"FROM tabfacturas as a, tabformularios as b,  registracio as c " + ;
 							"WHERE a.tpocte = b.id AND nroregistracio = c.REG_nroregistrac and " + ;
							"a.CODENT IN (945, 948) and " + ;
 								"a.fechahora BETWEEN '2004-02-01 00:00:00' and " + ;
 								"'2004-02-29 23:59:00' AND A.PTOVTA = 2" , "mwktodo")
 								
 								
 =sqldisconnect(mcon1)								