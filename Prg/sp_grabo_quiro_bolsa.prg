*******************************
* grabo nro de bolsa y despues el detalle
**********************

parameters mid,mnbolsa,mccad
mret = sqlexec(mcon1," select id,FechaQuirof,Nroregistrac,NroCirugia  from TabQuirofano "+;
	"Where id = ?mid ", "mwkValido")
mNroregistrac = mwkValido.Nroregistrac
mFechaQuirof = mwkValido.FechaQuirof
mccad = mccad +chr(1)
mret = sqlexec(mcon1,"Update Tabquirofano " + ;
	"set NroCirugia = ?mnbolsa where id = ?mid")

if mret < 0
	messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
mfecnull = ctod("01/01/1900")
msep1 = 1
msep3 = 1
mconta1 = atc(chr(9), mccad, msep1)
mconta3 = atc(chr(1), mresp, msep3)

minicial = 1
m_i = 0

do while mconta1 > 0
	codbolsa = subs(mresp,  minicial, (mconta1 -1) - (minicial -1))
	mret = sqlexec(mcon1," insert into Tabquirobolsa (TQB_bolsa, TQB_fecPasiva,TQB_idQuirofano)"+;
		" values (?codbolsa,?mfecnul, ?mid)" )
	msep1 		= msep1 + 1
	minicial 	= mconta1 + 1
	mconta1 	= atc(chr(9), mresp, msep1)
enddo
codbolsa = mresp
mret = sqlexec(mcon1," insert into Tabquirobolsa (TQB_bolsa, TQB_fecPasiva,TQB_idQuirofano)"+;
	" values (?codbolsa,?mfecnul, ?mid)" )

