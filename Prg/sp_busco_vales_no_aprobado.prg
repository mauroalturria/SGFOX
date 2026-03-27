****
** busco llos protocolos de vales no aprobados o suspendidos
****

parameter  maprob

mret = sqlexec(mcon1, "select guardia.protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
	"a.nombre as nombremed, guardiavale.diagnostico, " + ;
	"b.nomape as nombreefe, aprobado ,nrovale  " + ;
	"from guardia, registracio, tabusuario as b, guardiavale " + ;
	" left join prestadores as a on guardia.codmed = a.id " + ;
	"where guardiavale.protocolo = guardia.protocolo  and " + ;
	"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
	"guardia.usuario		= b.codigovax and " + ;
	"guardiavale.codserv	= 5410 " + maprob + ;
	" group by guardia.protocolo order by REG_nombrepac " , "mwkveoinsu")

if mret<0
	=aerr(eros)
	messagebox(eros(3))
endif
	&&&guardiavale.fechahora>='2006-07-25 01:30:00' and 