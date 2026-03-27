****
** busco prestaciones por servicio y nemonico
****

parameter mcodserv, mcodmed

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
						"pre_especialidad, pre_duracion, ser_descripserv, ppsnropantalla " + ;
						"FROM servicios, medpresta, prestacions left outer joint protprssec " + ;
						"on prestacions.pre_codprest = protprssec.ppscodprest and " + ;
						"ppscodsector = 'AMB' " + ;
						"where pre_codprest = codprest and " + ;
						"pre_codservicio = ser_codserv and " + ;
						"codserv = ?mcodserv and " + ;
						"codmed  = ?mcodmed " + ;
						"group by pre_codprest " + ;
						"ORDER BY ppsnropantalla, pre_descriprest", "mwkbustexto")

if mret < 0


endif						