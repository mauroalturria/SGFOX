
mret = sqlexec(mcon1, "select afi_codentidad, count(afi_codentidad) " + ;
						"from guardia, afiliacion " + ;
 						"where nroregistrac = registracio and " + ;
 						"afi_codentidad in (100, 101, 511, 512, 149, 825, 924, 925) and " + ;
 						"fechahoraing >= '2003-10-02 00:00:00' and " + ;
 						"fechahoraing <= '2003-10-02 24:00:00' " + ;
 						"group by afi_codentidad" ,"mwka")